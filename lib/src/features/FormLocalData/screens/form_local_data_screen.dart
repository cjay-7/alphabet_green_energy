import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/local_storage_controller.dart';

import 'widgets/local_storage_appBar.dart';
import 'widgets/local_storage_floating_button.dart';
import 'widgets/local_storage_tabBar_view.dart';

class FormLocalDataScreen extends StatefulWidget {
  const FormLocalDataScreen({Key? key}) : super(key: key);

  @override
  FormLocalDataScreenState createState() => FormLocalDataScreenState();
}

class FormLocalDataScreenState extends State<FormLocalDataScreen>
    with SingleTickerProviderStateMixin {
  final localStorageController = Get.put(LocalStorageController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    localStorageController.retrieveFormDataFromLocalStorage();
    localStorageController.retrieveVisitDataFromLocalStorage();
    localStorageController.retrieveSurveyDataFromLocalStorage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LocalFormAppBar(
        tabController: _tabController,
      ),
      body: LocalStorageTabBarView(tabController: _tabController),
      floatingActionButton:
          LocalStorageFloatingButton(tabController: _tabController),
    );
  }
}
