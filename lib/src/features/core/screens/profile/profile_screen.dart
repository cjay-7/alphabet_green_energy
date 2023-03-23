import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/screens/profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          aProfile,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.apply(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDefaultSize),
          child: Column(
            children: [
              SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                      ))),
              const SizedBox(height: 10),
              Text(
                aProfileHeading,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                aProfileSubHeading,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: aAccentColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(aEditProfile,
                      style: TextStyle(color: aDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              //Menu

              ProfileMenuWidget(
                  title: aMenu1, icon: Icons.settings, onPress: () {}),
              ProfileMenuWidget(
                  title: aMenu2,
                  icon: Icons.account_balance_wallet,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: aMenu3, icon: Icons.verified_user, onPress: () {}),
              const Divider(),
              ProfileMenuWidget(
                  title: aMenu4, icon: Icons.info, onPress: () {}),
              ProfileMenuWidget(
                  title: aMenu5,
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    AuthenticationRepository.instance.logout();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
