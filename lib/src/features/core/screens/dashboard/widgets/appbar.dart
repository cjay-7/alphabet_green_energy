import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/text.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.menu, color: Colors.black),
      title: Text(
        aAppName,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: aAccentColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(55);
}