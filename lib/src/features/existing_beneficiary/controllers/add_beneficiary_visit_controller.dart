import 'package:alphabet_green_energy/src/repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import 'package:get/get.dart';

import '../models/add_beneficiary_visit_model.dart';

class AddBeneficiaryVisitController extends GetxController {
  static AddBeneficiaryVisitController get instance => Get.find();
  late var stoveImgVisit = "";
  late var usedRegularly = "Yes";
  late var worksProperly = "Yes";
  late var idNumber = "";

  final beneficiaryAddRepo = Get.put(BeneficiaryAddRepository());

  Future<void> addVisitData(
      AddBeneficiaryVisitModel visitModel, String idNumber) async {
    await beneficiaryAddRepo.checkAndSetVisitData(idNumber, visitModel);
  }
}
