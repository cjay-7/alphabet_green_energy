import 'package:flutter/material.dart';

/// Shows a blocking spinner while [task] runs, then dismisses it.
/// Always dismisses the spinner, even if [task] throws.
Future<T> runWithLoader<T>(
  BuildContext context,
  Future<T> Function() task,
) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
  try {
    return await task();
  } finally {
    if (navigator.mounted) navigator.pop();
  }
}
