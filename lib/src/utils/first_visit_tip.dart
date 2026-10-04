import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/text.dart';

/// Shows a one-time "Got it" dialog the first time a screen is visited,
/// tracked locally via SharedPreferences — per-device, not per-account, but
/// that's fine here since each field agent generally uses one device.
///
/// For the Dashboard's main actions (Add Beneficiary, Survey, Local
/// Storage), see the full first-login onboarding flow instead
/// (OnboardingScreen) — this is for secondary screens (Existing
/// Beneficiary, Profile) that get a lighter, standalone tip instead of
/// being bundled into that flow.
Future<void> showFirstVisitTip(
  BuildContext context, {
  required String prefsKey,
  required String title,
  required String message,
}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(prefsKey) ?? false) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(aGotIt, style: TextStyle(color: aAccentColor)),
        ),
      ],
    ),
  );
  await prefs.setBool(prefsKey, true);
}
