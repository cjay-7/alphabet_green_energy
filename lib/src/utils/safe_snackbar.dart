import 'package:flutter/material.dart';

import 'app_keys.dart';

/// Shows a snackbar via the app's root ScaffoldMessenger key.
///
/// This used to resolve `Get.context` and check `Overlay.maybeOf(context)`
/// before calling `Get.snackbar`/`ScaffoldMessenger.of(context)`. Confirmed
/// live (web signup's duplicate-email error path, 2026-10-01): `Get.context`
/// in this app resolves to the Navigator widget's own element, which sits
/// *above* the Overlay the Navigator creates — so `Overlay.maybeOf` can
/// never find an Overlay ancestor there, no matter how long you poll. Every
/// call was silently giving up after 20 attempts without ever showing
/// anything, with no error to indicate why.
///
/// `scaffoldMessengerKey` (wired into `GetMaterialApp` in main.dart)
/// sidesteps context resolution entirely — this is the standard Flutter
/// pattern for showing a SnackBar from outside the widget tree (a
/// repository/controller, not a build method). Still retries briefly in
/// case this is called before the first frame attaches the key's state.
Future<void> showSnackbarSafely(
  String title,
  String message, {
  Color? backgroundColor,
  Color? colorText,
}) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '$title: $message',
                  style: TextStyle(color: colorText),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
        ),
      );
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
