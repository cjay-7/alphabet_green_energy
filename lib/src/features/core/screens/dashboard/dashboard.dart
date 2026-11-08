import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_icon_button.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_stats.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/screens/existing_beneficiary.dart';
import 'package:alphabet_green_energy/src/features/survey_form/screens/survey_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/text.dart';

import '../../../FormLocalData/screens/form_local_data_screen.dart';
import '../../../beneficiary_form/screens/beneficiary_form.dart';
import '../../controllers/profile_controller.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        Get.put(ProfileController()); // Create an instance of ProfileController

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(aDashboardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the user's full name, reacting to userData once
              // ProfileController's onInit() fetch completes.
              Obx(() {
                final userData = profileController.userData.value;
                final fullName = userData?.fullName ?? "Unknown User";
                return Text(
                  'Welcome, $fullName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              const SizedBox(height: 16),
              const DashboardStats(),
              const SizedBox(height: 16),
              // The four buttons share all remaining height equally.
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: DashboardIconButton(
                          fill: true,
                          onPressed: () =>
                              Get.to(() => const BeneficiaryFormWidget()),
                          dashboardIcon: Icons.person_add_alt_rounded,
                          dashboardIconLabel: aAddBeneficiary),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: DashboardIconButton(
                          fill: true,
                          onPressed: () =>
                              Get.to(() => const ExistingBeneficiary()),
                          dashboardIcon: Icons.contact_page_rounded,
                          dashboardIconLabel: aExistingBeneficiary),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: DashboardIconButton(
                        fill: true,
                        dashboardIcon: Icons.fact_check,
                        dashboardIconLabel: aSurvey,
                        onPressed: () => Get.to(() => const SurveyForm()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: DashboardIconButton(
                        fill: true,
                        dashboardIcon: Icons.sd_storage,
                        dashboardIconLabel: aLocalBeneficiary,
                        onPressed: () =>
                            Get.to(() => const FormLocalDataScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
