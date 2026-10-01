import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/constants/text.dart';
import 'package:alphabet_green_energy/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:alphabet_green_energy/src/features/core/screens/profile/widgets/profile_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
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
              Obx(() {
                final imageUrl = controller.userData.value?.profileImageUrl;
                return SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.person, size: 100),
                              )
                            : const Icon(
                                Icons.person,
                                size: 100,
                              )));
              }),
              const SizedBox(height: 10),
              Obx(() {
                final user = controller.userData.value;
                return Column(
                  children: [
                    Text(
                      user?.fullName ?? "Unknown User",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (user?.email.isNotEmpty ?? false)
                      Text(
                        user!.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (user?.phoneNo.isNotEmpty ?? false)
                      Text(
                        user!.phoneNo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                );
              }),
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

              // ProfileMenuWidget(
              //     title: aMenu1, icon: Icons.settings, onPress: () {}),
              // ProfileMenuWidget(
              //     title: aMenu2,
              //     icon: Icons.account_balance_wallet,
              //     onPress: () {}),
              // ProfileMenuWidget(
              //     title: aMenu3, icon: Icons.verified_user, onPress: () {}),
              // const Divider(),
              // ProfileMenuWidget(
              //     title: aMenu4, icon: Icons.info, onPress: () {}),
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
