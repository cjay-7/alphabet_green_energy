import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_heading.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_icon_button.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/screens/existing_beneficiary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/text.dart';

import '../../../FormLocalData/screens/widgets/form_local_data_screen.dart';
import '../../../beneficiary_form/screens/beneficiary_form/beneficiary_form.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 50.0),
                Column(
                  children: [
                    DashboardIconButton(
                        onPressed: () =>
                            Get.to(() => const BeneficiaryFormWidget()),
                        dashboardIcon: Icons.person_add_alt_rounded,
                        dashboardIconLabel: aAddBeneficiary),
                    const SizedBox(height: 30.0),
                    DashboardIconButton(
                        onPressed: () =>
                            Get.to(() => const ExistingBeneficiary()),
                        dashboardIcon: Icons.contact_page_rounded,
                        dashboardIconLabel: aExistingBeneficiary),
                    const SizedBox(height: 30.0),
                    DashboardIconButton(
                      dashboardIcon: Icons.sd_storage,
                      dashboardIconLabel: aLocalBeneficiary,
                      onPressed: () =>
                          Get.to(() => const FormLocalDataScreen()),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
