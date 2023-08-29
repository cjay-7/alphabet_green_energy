import 'package:flutter/material.dart';

import '../../../../../constants/colors.dart';

class DashboardIconButton extends StatelessWidget {
  const DashboardIconButton(
      {Key? key,
      required this.dashboardIcon,
      required this.dashboardIconLabel,
      this.textColor,
      this.endIcon = true,
      required this.onPressed})
      : super(key: key);

  final IconData dashboardIcon;
  final String dashboardIconLabel;
  final VoidCallback onPressed;
  final Color? textColor;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? aPrimaryColor : aSecondaryColor;
    return ListTile(
      shape: const StadiumBorder(),
      tileColor: isDark
          ? Colors.blueGrey.withOpacity(0.1)
          : aAccentColor.withOpacity(.4),
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: iconColor.withOpacity(0.1)),
        child: Icon(dashboardIcon, color: iconColor),
      ),
      title: Text(dashboardIconLabel,
          style:
              Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.2),
              ), // BoxDecoration
              child: const Icon(Icons.chevron_right,
                  size: 20.0, color: Colors.grey))
          : null,
    );
  }
}
