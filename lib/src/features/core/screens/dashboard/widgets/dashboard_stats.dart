import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../services/activity_stats_service.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = Get.put(ActivityStatsService(), permanent: true);
    stats.load();
    final isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final text = Theme.of(context).textTheme;

    Widget cell(String label, ActivityStat s) {
      return Expanded(
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${stats.totals[s]!.value}',
                    style: text.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text('${stats.today[s]!.value} today',
                    style: text.bodySmall?.copyWith(color: aAccentColor)),
                const SizedBox(height: 2),
                Text(label,
                    textAlign: TextAlign.center, style: text.bodySmall),
              ],
            )),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey.withOpacity(0.1) : aCardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cell('Forms\nsubmitted', ActivityStat.forms),
          cell('Visits\nconducted', ActivityStat.visits),
          cell('Local data\nin', ActivityStat.localIn),
          cell('Local data\nout', ActivityStat.localOut),
        ],
      ),
    );
  }
}
