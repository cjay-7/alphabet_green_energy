import 'package:flutter/material.dart';

class DashboardIconButton extends StatelessWidget {
  const DashboardIconButton(
      {Key? key,
      required this.dashboardIcon,
      required this.dashboardIconLabel,
      required this.onPressed})
      : super(key: key);

  final IconData dashboardIcon;
  final String dashboardIconLabel;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: onPressed, iconSize: 100.0, icon: Icon(dashboardIcon)),
        Text(
          dashboardIconLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
