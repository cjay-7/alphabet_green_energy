import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_storage_controller.dart';

class LocalFormAppBar extends StatelessWidget implements PreferredSizeWidget {
  LocalFormAppBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;
  final localStorageController = Get.put(LocalStorageController());
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text('Local Storage Data'),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Form Data'),
                  const SizedBox(width: 2.8),
                  Badge(
                    label: Obx(() {
                      if (localStorageController.formDataCount.value > 0) {
                        return Text(
                          localStorageController.formDataCount.value.toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    }),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Visit Data'),
                  const SizedBox(width: 2.8),
                  Badge(
                    label: Obx(() {
                      if (localStorageController.visitDataCount.value > 0) {
                        return Text(
                          localStorageController.visitDataCount.value
                              .toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    }),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Survey Data'),
                  const SizedBox(width: 2.8),
                  Badge(
                    label: Obx(() {
                      if (localStorageController.surveyDataCount.value > 0) {
                        return Text(
                          localStorageController.surveyDataCount.value
                              .toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      } else {
                        return const Text(
                          "0",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    }),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(105);
}
