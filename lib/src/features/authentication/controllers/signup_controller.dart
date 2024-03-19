import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:alphabet_green_energy/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();

  Future<void> registerUser(
      String email, String password, UserModel agent) async {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password, agent);
  }
}
