import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_heading.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_icon_button.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/screens/existing_beneficiary.dart';
import 'package:alphabet_green_energy/src/features/survey_form/screens/survey_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/text.dart';

import '../../../FormLocalData/screens/form_local_data_screen.dart';
import '../../../beneficiary_form/screens/beneficiary_form/beneficiary_form.dart';
import '../../controllers/profile_controller.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        Get.put(ProfileController()); // Create an instance of ProfileController

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDashboardPadding),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //const DashboardHeading(),
                const SizedBox(height: 30.0),
                // Display the user's full name
                FutureBuilder<void>(
                  future: profileController.getUserData(), // Call getUserData()
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...'); // Show loading message
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final userData = profileController.userData.value;
                      final fullName = userData?.fullName ?? "Unknown User";
                      return Text(
                        'Welcome, $fullName',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                Column(
                  children: [
                    const SizedBox(height: 300.0),
                    DashboardIconButton(
                        onPressed: () =>
                            Get.to(() => const BeneficiaryFormWidget()),
                        dashboardIcon: Icons.person_add_alt_rounded,
                        dashboardIconLabel: aAddBeneficiary),
                    const SizedBox(height: 10),
                    DashboardIconButton(
                        onPressed: () =>
                            Get.to(() => const ExistingBeneficiary()),
                        dashboardIcon: Icons.contact_page_rounded,
                        dashboardIconLabel: aExistingBeneficiary),
                    const SizedBox(height: 10),
                    DashboardIconButton(
                      dashboardIcon: Icons.fact_check,
                      dashboardIconLabel: aSurvey,
                      onPressed: () => Get.to(() => const SurveyForm()),
                    ),
                    const SizedBox(height: 10),
                    DashboardIconButton(
                      dashboardIcon: Icons.sd_storage,
                      dashboardIconLabel: aLocalBeneficiary,
                      onPressed: () =>
                          Get.to(() => const FormLocalDataScreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
