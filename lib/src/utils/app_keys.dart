import 'package:flutter/material.dart';

/// Root ScaffoldMessenger key, wired into GetMaterialApp in main.dart.
///
/// showSnackbarSafely uses this directly instead of resolving a BuildContext
/// first. Get.context in this app resolves to the Navigator widget's own
/// element, which sits *above* the Overlay the Navigator creates — so
/// Overlay.maybeOf(Get.context) can never find an Overlay ancestor, no
/// matter how long you poll. Confirmed live: every showSnackbarSafely call
/// was silently giving up after 20 attempts without ever showing anything.
/// A GlobalKey<ScaffoldMessengerState> sidesteps context resolution
/// entirely — this is the standard Flutter pattern for showing a SnackBar
/// from outside the widget tree (a repository/controller, not a build
/// method).
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
