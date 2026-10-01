import 'package:flutter/material.dart';

import '../constants/sizes.dart';

/// Wraps a single form field in the standard field padding repeated around
/// every TextFormField/DropdownSearch/button-row across the beneficiary and
/// survey form sections.
class FormFieldPadding extends StatelessWidget {
  const FormFieldPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(aFieldPadding),
      child: child,
    );
  }
}
