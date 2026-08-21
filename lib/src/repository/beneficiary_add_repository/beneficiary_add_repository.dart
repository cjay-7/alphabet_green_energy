// ignore_for_file: avoid_print

import 'package:get/get.dart';

import '../../constants/firestore_keys.dart';
import '../../features/beneficiary_form/models/beneficiary_model.dart';
import '../firestore_add_repository.dart';

class BeneficiaryAddRepository extends FirestoreAddRepository<BeneficiaryModel>
    with VisitSubcollectionMixin {
  static BeneficiaryAddRepository get instance => Get.find();

  @override
  String get collectionName => FirestoreCollections.beneficiaryData;

  @override
  String get entityLabel => "Beneficiary";

  @override
  String docIdFor(BeneficiaryModel model) => model.idNumber;

  @override
  Map<String, dynamic> toJson(BeneficiaryModel model) => model.toJson();

  Future<void> addData(BeneficiaryModel beneficiary) => add(beneficiary);

  Future<BeneficiaryModel> getBeneficiaryDetails(String serialNumber) async {
    final stoveIDSnapshot = await db
        .collection(FirestoreCollections.beneficiaryData)
        .where(BeneficiaryFields.stoveID, isEqualTo: serialNumber)
        .get();

    if (stoveIDSnapshot.docs.isNotEmpty) {
      final beneficiaryData = stoveIDSnapshot.docs
          .map((e) => BeneficiaryModel.fromSnapshot(e))
          .single;
      print(
          "Beneficiary found with ID Number: ${beneficiaryData.idNumber}"); // Add this line
      return beneficiaryData;
    } else {
      final idNumberSnapshot = await db
          .collection(FirestoreCollections.beneficiaryData)
          .where(BeneficiaryFields.idNumber, isEqualTo: serialNumber)
          .get();

      if (idNumberSnapshot.docs.isNotEmpty) {
        final beneficiaryData = idNumberSnapshot.docs
            .map((e) => BeneficiaryModel.fromSnapshot(e))
            .single;
        print(
            "Beneficiary found with ID Number: ${beneficiaryData.idNumber}"); // Add this line
        return beneficiaryData;
      } else {
        print(
            "No beneficiary data found for serial number: $serialNumber"); // Add this line
        throw Exception(
            "No beneficiary data found for the provided serial number");
      }
    }
  }
}
