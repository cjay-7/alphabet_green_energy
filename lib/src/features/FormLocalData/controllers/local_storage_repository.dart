import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import this library for JSON conversion
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/existing_beneficiary/models/add_beneficiary_visit_model.dart';

import '../../beneficiary_form_primary/models/primary_beneficiary_model.dart';
import '../../survey_form/models/survey_model.dart';

class LocalStorageRepository {
  final String primaryBeneficiaryDataKey = 'primaryBeneficiaryData';
  final String formDataKey = 'formData';
  final String visitDataKey = 'visitData';
  final String surveyDataKey = 'surveyData';

  Future<List<PrimaryBeneficiaryModel>>
      getPrimaryBeneficiaryDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final primaryBeneficiaryDataJsonList =
        prefs.getStringList(primaryBeneficiaryDataKey);
    if (primaryBeneficiaryDataJsonList != null) {
      return primaryBeneficiaryDataJsonList
          .map((data) => PrimaryBeneficiaryModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }

  Future<List<BeneficiaryModel>> getFormDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final formDataJsonList = prefs.getStringList(formDataKey);
    if (formDataJsonList != null) {
      return formDataJsonList
          .map((data) => BeneficiaryModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }

  Future<List<AddBeneficiaryVisitModel>> getVisitDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final visitDataJsonList = prefs.getStringList(visitDataKey);
    if (visitDataJsonList != null) {
      return visitDataJsonList
          .map((data) => AddBeneficiaryVisitModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }

  Future<List<SurveyModel>> getSurveyDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final surveyDataJsonList = prefs.getStringList(surveyDataKey);
    if (surveyDataJsonList != null) {
      return surveyDataJsonList
          .map((data) => SurveyModel.fromJson(jsonDecode(data)))
          .toList();
    }
    return [];
  }
}
