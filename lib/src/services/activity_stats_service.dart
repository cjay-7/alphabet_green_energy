import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_keys.dart';
import '../constants/storage_keys.dart';

/// Caseworker activity counters shown on the dashboard.
///
/// - forms / visits: counted from Firestore by the `SubmittedBy` uid stamped
///   on each record, so they follow the caseworker across devices. Records
///   still waiting in this phone's offline queue are added on top. Records
///   written before attribution shipped have no uid and are not counted.
/// - localIn / localOut: records saved to / uploaded from THIS phone's
///   offline queue. Inherently per-device, kept in SharedPreferences.
enum ActivityStat { forms, visits, localIn, localOut }

class ActivityStatsService extends GetxController {
  static ActivityStatsService get instance => Get.find();

  final totals = {for (final s in ActivityStat.values) s: 0.obs};
  final today = {for (final s in ActivityStat.values) s: 0.obs};

  String? _uid;

  String get _todayStamp {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  String _key(ActivityStat s, String part) => 'stats_${_uid}_${s.name}_$part';

  /// Loads cached values instantly, then refreshes forms/visits from Firestore.
  Future<void> load() async {
    _uid = FirebaseAuth.instance.currentUser?.uid;
    if (_uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    for (final s in ActivityStat.values) {
      totals[s]!.value = prefs.getInt(_key(s, 'total')) ?? 0;
      final sameDay = prefs.getString(_key(s, 'day')) == _todayStamp;
      today[s]!.value = sameDay ? (prefs.getInt(_key(s, 'today')) ?? 0) : 0;
    }
    await refreshRemote();
  }

  Future<int> _count(Query<Map<String, dynamic>> q, {String? day}) async {
    var query = q.where(SubmissionFields.submittedBy, isEqualTo: _uid);
    if (day != null) {
      query = query.where(SubmissionFields.submittedDay, isEqualTo: day);
    }
    return (await query.count().get()).count ?? 0;
  }

  int _pending(SharedPreferences prefs, String key) =>
      prefs.getStringList(key)?.length ?? 0;

  /// Recomputes forms and visits. On any failure (offline, missing index or
  /// rules not deployed yet) the last cached numbers stay on screen.
  Future<void> refreshRemote() async {
    if (_uid == null) return;
    try {
      final db = FirebaseFirestore.instance;
      final day = _todayStamp;
      final beneficiaries = db.collection(FirestoreCollections.beneficiaryData);
      final surveys = db.collection(FirestoreCollections.surveyData);
      final visits = db.collectionGroup(FirestoreCollections.visitData);
      final r = await Future.wait([
        _count(beneficiaries),
        _count(surveys),
        _count(visits),
        _count(beneficiaries, day: day),
        _count(surveys, day: day),
        _count(visits, day: day),
      ]);
      final prefs = await SharedPreferences.getInstance();
      final pendingForms = _pending(prefs, aFormDataStorageKey) +
          _pending(prefs, aSurveyDataStorageKey);
      final pendingVisits = _pending(prefs, aVisitDataStorageKey);
      // Offline-queued records were filled in today on this phone (an
      // approximation for older queued items), so they count toward today.
      await _set(ActivityStat.forms, r[0] + r[1] + pendingForms,
          r[3] + r[4] + pendingForms, prefs);
      await _set(ActivityStat.visits, r[2] + pendingVisits,
          r[5] + pendingVisits, prefs);
    } catch (_) {
      // keep cached values
    }
  }

  Future<void> _set(
      ActivityStat s, int total, int todayCount, SharedPreferences prefs) async {
    totals[s]!.value = total;
    today[s]!.value = todayCount;
    await prefs.setInt(_key(s, 'total'), total);
    await prefs.setInt(_key(s, 'today'), todayCount);
    await prefs.setString(_key(s, 'day'), _todayStamp);
  }

  /// Increments a per-device counter (localIn / localOut).
  Future<void> _bump(ActivityStat s) async {
    if (_uid == null || _uid != FirebaseAuth.instance.currentUser?.uid) {
      _uid = FirebaseAuth.instance.currentUser?.uid;
      if (_uid == null) return;
    }
    final prefs = await SharedPreferences.getInstance();
    final stamp = _todayStamp;
    if (prefs.getString(_key(s, 'day')) != stamp) today[s]!.value = 0;
    await _set(s, (prefs.getInt(_key(s, 'total')) ?? 0) + 1,
        today[s]!.value + 1, prefs);
  }

  Future<void> record(ActivityStat s) async {
    if (s == ActivityStat.localIn || s == ActivityStat.localOut) {
      await _bump(s);
    } else {
      // forms / visits: let Firestore (plus the offline queue) be the truth.
      await refreshRemote();
    }
  }
}

/// Fire-and-forget helper so call sites stay one line.
void recordActivity(ActivityStat s) {
  if (!Get.isRegistered<ActivityStatsService>()) {
    Get.put(ActivityStatsService(), permanent: true);
  }
  ActivityStatsService.instance.record(s);
}
