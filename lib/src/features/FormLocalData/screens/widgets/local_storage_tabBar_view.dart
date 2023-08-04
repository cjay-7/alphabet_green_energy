import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_beneficiary_data.dart';
import 'local_survey_data.dart';
import 'local_visit_data.dart';

class LocalStorageTabBarView extends StatelessWidget {
  final TabController tabController;

  const LocalStorageTabBarView({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Obx(() {
          return localBeneficiaryData(context);
        }),
        Obx(() {
          return localVisitData(context);
        }),
        Obx(() {
          return localSurveyData(context);
        }),
      ],
    );
  }
}
