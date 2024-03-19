import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/text.dart';
import '../../profile/profile_screen.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return AppBar(
      backgroundColor:
          isDark ? aSecondaryColor : aAccentColor.withBlue(9).withOpacity(.5),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(aAlphabetGreensLogo),
            width: 30,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(aDashboard, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const ProfileScreen());
          },
          icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(65);
}
