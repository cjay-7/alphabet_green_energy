import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import this library for JSON conversion
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/models/add_beneficiary_visit_model.dart';

import '../../../constants/storage_keys.dart';
import '../../survey_form/models/survey_model.dart';

class LocalStorageRepository {
  Future<List<BeneficiaryModel>> getFormDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final formDataJsonList = prefs.getStringList(aFormDataStorageKey);
    if (formDataJsonList != null) {
      return formDataJsonList
          .map((data) => BeneficiaryModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }

  Future<List<AddBeneficiaryVisitModel>> getVisitDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final visitDataJsonList = prefs.getStringList(aVisitDataStorageKey);
    if (visitDataJsonList != null) {
      return visitDataJsonList
          .map((data) => AddBeneficiaryVisitModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }

  Future<List<SurveyModel>> getSurveyDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final surveyDataJsonList = prefs.getStringList(aSurveyDataStorageKey);
    if (surveyDataJsonList != null) {
      return surveyDataJsonList
          .map((data) => SurveyModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }
}
