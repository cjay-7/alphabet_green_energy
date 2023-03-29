import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/appbar.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_heading.dart';
import 'package:alphabet_green_energy/src/features/core/screens/dashboard/widgets/dashboard_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/text.dart';

import '../../../beneficiary_form/screens/beneficiary_form/beneficiary_form.dart';
import '../../../beneficiary_form/screens/beneficiary_form/widgets/beneficiaryDialogBuilder.dart';

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
                const DashboardHeading(),
                const SizedBox(height: 75.0),
                Column(
                  children: [
                    DashboardIconButton(
                        onPressed: () =>
                            Get.to(() => const BeneficiaryFormWidget()),
                        dashboardIcon: Icons.person_add_alt_rounded,
                        dashboardIconLabel: aAddBeneficiary),
                    const SizedBox(height: 30.0),
                    DashboardIconButton(
                        onPressed: () {
                          BeneficiaryDialog.beneficiaryDialogBuilder(context);
                        },
                        dashboardIcon: Icons.contact_page_rounded,
                        dashboardIconLabel: aExistingBeneficiary)
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
