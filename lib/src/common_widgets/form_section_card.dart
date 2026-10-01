import 'package:flutter/material.dart';

import 'form_field_padding.dart';

/// The bordered "section card with a headline title" skeleton repeated
/// across every beneficiary/survey form section (Personal Details, ID
/// Details, Stove Details, ...) — same border, corner radius, and title
/// styling each time, just a different title and set of field widgets.
class FormSectionCard extends StatelessWidget {
  const FormSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String title;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          FormFieldPadding(
            child:
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ),
          ...children,
        ],
      ),
    );
  }
}
