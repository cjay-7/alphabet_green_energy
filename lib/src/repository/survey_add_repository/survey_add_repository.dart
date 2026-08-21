import 'package:get/get.dart';

import '../../constants/firestore_keys.dart';
import '../../features/survey_form/models/survey_model.dart';
import '../firestore_add_repository.dart';

class SurveyAddRepository extends FirestoreAddRepository<SurveyModel> {
  static SurveyAddRepository get instance => Get.find();

  @override
  String get collectionName => FirestoreCollections.surveyData;

  @override
  String get entityLabel => "Survey";

  @override
  String docIdFor(SurveyModel model) => model.idNumber;

  @override
  Map<String, dynamic> toJson(SurveyModel model) => model.toJson();

  Future<void> addSurveyData(SurveyModel survey) => add(survey);
}
