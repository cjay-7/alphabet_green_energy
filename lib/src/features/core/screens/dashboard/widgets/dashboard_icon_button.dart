import 'package:flutter/material.dart';

import '../../../../../constants/colors.dart';

class DashboardIconButton extends StatelessWidget {
  const DashboardIconButton(
      {Key? key,
      required this.dashboardIcon,
      required this.dashboardIconLabel,
      this.textColor,
      this.endIcon = true,
      this.fill = false,
      required this.onPressed})
      : super(key: key);

  final IconData dashboardIcon;
  final String dashboardIconLabel;
  final VoidCallback onPressed;
  final Color? textColor;
  final bool endIcon;

  /// When true, stretches to fill the height its parent gives it.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? aPrimaryColor : aSecondaryColor;
    final tileColor = isDark
        ? Colors.blueGrey.withOpacity(0.1)
        : aAccentColor.withOpacity(.4);
    if (fill) {
      return Material(
        color: tileColor,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: iconColor.withOpacity(0.1)),
                  child: Icon(dashboardIcon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(dashboardIconLabel,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.apply(color: textColor)),
                ),
                if (endIcon)
                  const Icon(Icons.chevron_right,
                      size: 24.0, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
    return ListTile(
      shape: const StadiumBorder(),
      tileColor: tileColor,
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
