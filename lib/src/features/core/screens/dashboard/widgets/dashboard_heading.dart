import 'package:flutter/material.dart';

import '../../../../../constants/text.dart';

class DashboardHeading extends StatelessWidget {
  const DashboardHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(aDashboard, style: Theme.of(context).textTheme.headlineLarge),
    ]);
  }
}
