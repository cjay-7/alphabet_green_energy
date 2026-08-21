import 'package:get/get.dart';

import '../../constants/firestore_keys.dart';
import '../../features/beneficiary_form_primary/models/primary_beneficiary_model.dart';
import '../firestore_add_repository.dart';

class PrimaryBeneficiaryAddRepository
    extends FirestoreAddRepository<PrimaryBeneficiaryModel>
    with VisitSubcollectionMixin {
  static PrimaryBeneficiaryAddRepository get instance => Get.find();

  @override
  String get collectionName => FirestoreCollections.primaryBeneficiaryData;

  @override
  String get entityLabel => "Beneficiary";

  @override
  String docIdFor(PrimaryBeneficiaryModel model) => model.idNumber;

  @override
  Map<String, dynamic> toJson(PrimaryBeneficiaryModel model) =>
      model.toJson();

  Future<void> addPrimaryBeneficiaryData(PrimaryBeneficiaryModel beneficiary) =>
      add(beneficiary);
}
