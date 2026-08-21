import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows a Get.snackbar only once an Overlay ancestor genuinely exists for
/// the current route.
///
/// GetX's SnackbarController looks up the Overlay via Get.overlayContext,
/// which isn't a reliable readiness check: it returns a child of the
/// overlay's *current content*, so it's null whenever the overlay is simply
/// empty (the normal steady state) and can reference a since-removed
/// element otherwise — neither case proves an Overlay ancestor exists for
/// the current route. That failure surfaces as an unhandled "No Overlay
/// widget found" exception, since GetQueue only catches `on Exception` and
/// the thrown FlutterError isn't one. This is especially likely right after
/// a Navigator.pop()/push(), while the route transition is still settling.
///
/// Polls Overlay.maybeOf on the current route's own context instead, which
/// is what Flutter itself uses to answer "does an Overlay ancestor exist".
Future<void> showSnackbarSafely(
  String title,
  String message, {
  Color? backgroundColor,
  Color? colorText,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
}) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    final context = Get.context;
    if (context != null && Overlay.maybeOf(context) != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
      );
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
