import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/features/core/controllers/profile_controller.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: Text(aEditProfile,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.apply(color: aPrimaryColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  return Column(
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
                      const SizedBox(height: 20),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: userData.fullName,
                              decoration: const InputDecoration(
                                  label: Text(aFullName),
                                  prefixIcon: Icon(Icons.person)),
                            ),
                            const SizedBox(height: aFormHeight - 20),
                            TextFormField(
                              initialValue: userData.email,
                              decoration: const InputDecoration(
                                  label: Text(aEmail),
                                  prefixIcon: Icon(Icons.mail_outline)),
                            ),
                            const SizedBox(height: aFormHeight - 20),
                            TextFormField(
                              initialValue: userData.phoneNo,
                              decoration: const InputDecoration(
                                  label: Text(aPhoneNo),
                                  prefixIcon: Icon(Icons.phone)),
                            ),
                            const SizedBox(height: aFormHeight - 20),
                            TextFormField(
                              initialValue: userData.password,
                              decoration: const InputDecoration(
                                  label: Text(aPassword),
                                  prefixIcon: Icon(Icons.fingerprint)),
                            ),
                            const SizedBox(height: aFormHeight),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    Get.to(() => const UpdateProfileScreen()),
                                child: const Text(
                                  aEditProfile,
                                  style: TextStyle(color: aDarkColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
