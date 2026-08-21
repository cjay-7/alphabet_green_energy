import 'dart:convert';

import 'package:alphabet_green_energy/src/features/beneficiary_form_primary/controllers/primary_beneficiary_add_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/firestore_keys.dart';
import '../../../repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import '../../../repository/primary_beneficiary_add_repository/primary_beneficiary_add_repository.dart';
import '../../../repository/survey_add_repository/survey_add_repository.dart';
import '../../../services/error_log_service.dart';
import '../../../services/image_upload_service.dart';
import '../../../services/json_share_service.dart';
import '../../beneficiary_form/controllers/beneficiary_add_controller.dart';
import '../../beneficiary_form/models/beneficiary_model.dart';
import '../../beneficiary_form_primary/models/primary_beneficiary_model.dart';
import '../../existing_beneficiary/models/add_beneficiary_visit_model.dart';
import '../../survey_form/models/survey_model.dart';
import 'local_storage_repository.dart';

class LocalStorageController extends GetxController {
  static LocalStorageController get instance => Get.find();
  RxList<PrimaryBeneficiaryModel> primaryBeneficiaryDataList =
      RxList<PrimaryBeneficiaryModel>();
  RxList<BeneficiaryModel> formDataList = RxList<BeneficiaryModel>();
  RxList<AddBeneficiaryVisitModel> visitDataList =
      RxList<AddBeneficiaryVisitModel>();
  RxList<SurveyModel> surveyDataList = RxList<SurveyModel>();
  final primaryBeneficiaryAddController =
      Get.put(PrimaryBeneficiaryAddController());
  final beneficiaryAddController = Get.put(BeneficiaryAddController());
  final LocalStorageRepository _localStorageRepo = LocalStorageRepository();
  final primaryBeneficiaryAddRepo = Get.put(PrimaryBeneficiaryAddRepository());
  final beneficiaryAddRepo = Get.put(BeneficiaryAddRepository());
  final surveyRepo = Get.put(SurveyAddRepository());
  final _imageUploadService = ImageUploadService();
  final _errorLogService = ErrorLogService();
  final _jsonShareService = JsonShareService();
  RxInt formDataCount = 0.obs;
  RxInt primaryBeneficiaryDataCount = 0.obs;
  RxInt visitDataCount = 0.obs;
  RxInt surveyDataCount = 0.obs;
  RxBool isUploading = false.obs;

  Future<String> uploadImage(String imagePath) {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    return _imageUploadService.upload(imagePath, fileName: '$imageName.jpg');
  }

  Future<String> uploadImageToFirestore(String imagePath) {
    return _imageUploadService.upload(imagePath, folder: 'files');
  }

  Future<void> writeErrorToFirestore(String error) {
    return _errorLogService.writeErrorToFirestore(error);
  }

  @override
  void onInit() {
    // Call the updateCounts() method whenever formDataList or visitDataList changes
    ever(primaryBeneficiaryDataList, (_) {
      updateCounts();
    });
    ever(formDataList, (_) {
      updateCounts();
    });

    ever(visitDataList, (_) {
      updateCounts();
    });
    ever(surveyDataList, (_) {
      updateCounts();
    });
    super.onInit();
  }

  Future<void> retrievePrimaryBeneficiaryDataFromLocalStorage() async {
    primaryBeneficiaryDataList.assignAll(
        await _localStorageRepo.getPrimaryBeneficiaryDataFromLocalStorage());
  }

  Future<void> retrieveFormDataFromLocalStorage() async {
    formDataList
        .assignAll(await _localStorageRepo.getFormDataFromLocalStorage());
  }

  Future<void> retrieveVisitDataFromLocalStorage() async {
    visitDataList
        .assignAll(await _localStorageRepo.getVisitDataFromLocalStorage());
  }

  Future<void> retrieveSurveyDataFromLocalStorage() async {
    surveyDataList
        .assignAll(await _localStorageRepo.getSurveyDataFromLocalStorage());
  }

  void updateCounts() {
    primaryBeneficiaryDataCount.value = primaryBeneficiaryDataList.length;
    formDataCount.value = formDataList.length;
    visitDataCount.value = visitDataList.length;
    surveyDataCount.value = surveyDataList.length;
  }

  /// Runs `updateCounts()` and re-reads the just-synced cache, so screens
  /// showing the "still pending" list pick up the removals a sync just made.
  void _finishSync(Future<void> Function() refresh) {
    updateCounts();
    refresh();
  }

  Future<void> syncPrimaryBeneficiaryDataToFirebase() async {
    for (var primaryBeneficiaryData in primaryBeneficiaryDataList) {
      try {
        isUploading.value = true;
        // Upload images to Firebase Storage and get download URLs
        List<String> imageUrls = await uploadPrimaryBeneficiaryImagesToStorage(
            primaryBeneficiaryData);

        // Create a new instance of BeneficiaryModel with updated image URLs
        PrimaryBeneficiaryModel updatedPrimaryBeneficiaryData =
            PrimaryBeneficiaryModel(
          id: primaryBeneficiaryData.id,
          stoveID: primaryBeneficiaryData.stoveID,
          stoveImg: imageUrls[0],
          image1: imageUrls[1],
          idImageFront: imageUrls[2],
          idImageBack: imageUrls[3],
          fullName: primaryBeneficiaryData.fullName,
          phoneNumber: primaryBeneficiaryData.phoneNumber,
          idNumber: primaryBeneficiaryData.idNumber,
          currentDate: primaryBeneficiaryData.currentDate,
          surveyorName: primaryBeneficiaryData.surveyorName,
        );

        // Save the updated formData to Firestore

        await primaryBeneficiaryAddRepo
            .addPrimaryBeneficiaryData(updatedPrimaryBeneficiaryData);

        // Remove synced form data from local storage
        await removePrimaryBeneficiaryDataFromLocalStorage(
            primaryBeneficiaryData);
        if (kDebugMode) {
          print('Removed data from local storage');
        }
        isUploading.value = false;
      } catch (e) {
        if (kDebugMode) {
          print('Error during syncPrimaryBeneficiaryDataToFirebase: $e');
        }
      }
    }
    _finishSync(retrievePrimaryBeneficiaryDataFromLocalStorage);
  }

  Future<List<String>> uploadPrimaryBeneficiaryImagesToStorage(
      PrimaryBeneficiaryModel primaryBeneficiaryData) async {
    List<String> downloadUrls = [];

    // Upload StoveImg to Firebase Storage
    String stoveImgUrl = await uploadImage(primaryBeneficiaryData.stoveImg);
    downloadUrls.add(stoveImgUrl);

    // Upload Image1 to Firebase Storage
    String image1Url = await uploadImage(primaryBeneficiaryData.image1);
    downloadUrls.add(image1Url);

    // Upload IdImage to Firebase Storage
    String idImageUrl1 = await uploadImage(primaryBeneficiaryData.idImageFront);
    downloadUrls.add(idImageUrl1);
    // Upload IdImage to Firebase Storage
    String idImageUrl2 = await uploadImage(primaryBeneficiaryData.idImageBack);
    downloadUrls.add(idImageUrl2);

    return downloadUrls;
  }

  Future<void> removePrimaryBeneficiaryDataFromLocalStorage(
      PrimaryBeneficiaryModel primaryBeneficiaryData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedPrimaryBeneficiaryData =
        prefs.getStringList('primaryBeneficiaryData') ?? [];
    if (kDebugMode) {
      print('Before removal: $savedPrimaryBeneficiaryData');
    }
    if (kDebugMode) {
      print('Before removal: $primaryBeneficiaryData');
    }

    savedPrimaryBeneficiaryData.removeWhere(
        (data) => data == jsonEncode(primaryBeneficiaryData.toJson()));

    await prefs.setStringList(
        'primaryBeneficiaryData', savedPrimaryBeneficiaryData);

    if (kDebugMode) {
      print('After removal: $primaryBeneficiaryData');
    }
  }

  Future<void> syncFormDataToFirebase() async {
    try {
      for (var formData in formDataList) {
        try {
          isUploading.value = true;
          // Upload images to Firebase Storage and get download URLs
          List<String> imageUrls = await uploadImagesToStorage(formData);

          // Create a new instance of BeneficiaryModel with updated image URLs
          BeneficiaryModel updatedFormData = BeneficiaryModel(
            id: formData.id,
            stoveID: formData.stoveID,
            stoveImg: imageUrls[0],
            image1: imageUrls[1],
            image2: imageUrls[2],
            image3: imageUrls[3],
            idImageFront: imageUrls[4],
            idImageBack: imageUrls[5],
            consentImg: imageUrls[6],
            fullName: formData.fullName,
            address1: formData.address1,
            address2: formData.address2,
            zip: formData.zip,
            state: formData.state,
            district: formData.district,
            town: formData.town,
            phoneNumber: formData.phoneNumber,
            idNumber: formData.idNumber,
            idType: formData.idType,
            currentDate: formData.currentDate,
            surveyorName: formData.surveyorName,
          );

          // Save the updated formData to Firestore

          await beneficiaryAddRepo.addData(updatedFormData);

          // Remove synced form data from local storage
          await removeFormDataFromLocalStorage(formData);
          isUploading.value = false;
        } catch (e) {
          if (kDebugMode) {
            print('Error during syncFormDataToFirebase: $e');
          }
          // Log the error for debugging purposes
          await writeErrorToFirestore(e.toString());
        }
      }
      _finishSync(retrieveFormDataFromLocalStorage);
    } catch (e) {
      if (kDebugMode) {
        print('Top-level error during syncFormDataToFirebase: $e');
      }
      // Log the top-level error for debugging purposes
      await writeErrorToFirestore(e.toString());
    }
  }

  Future<List<String>> uploadImagesToStorage(BeneficiaryModel formData) async {
    List<String> downloadUrls = [];

    // Upload StoveImg to Firebase Storage
    String stoveImgUrl = await uploadImage(formData.stoveImg);
    downloadUrls.add(stoveImgUrl);

    // Upload Image1 to Firebase Storage
    String image1Url = await uploadImage(formData.image1);
    downloadUrls.add(image1Url);

    // Upload Image2 to Firebase Storage
    String image2Url = await uploadImage(formData.image2);
    downloadUrls.add(image2Url);

    // Upload Image3 to Firebase Storage
    String image3Url = await uploadImage(formData.image3);
    downloadUrls.add(image3Url);

    // Upload IdImage to Firebase Storage
    String idImageUrl1 = await uploadImage(formData.idImageFront);
    downloadUrls.add(idImageUrl1);
    // Upload IdImage to Firebase Storage
    String idImageUrl2 = await uploadImage(formData.idImageBack);
    downloadUrls.add(idImageUrl2);

    // Upload ConsentImg to Firebase Storage
    String consentImgUrl = await uploadImage(formData.consentImg);
    downloadUrls.add(consentImgUrl);

    return downloadUrls;
  }

  Future<void> removeFormDataFromLocalStorage(BeneficiaryModel formData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedFormData = prefs.getStringList('formData');
    if (savedFormData != null) {
      savedFormData.remove(jsonEncode(formData.toJson()));
      await prefs.setStringList('formData', savedFormData);
    }
  }

  Future<void> saveVisitDataToFirestore(String idNumber, String imageUrl,
      String usedRegularly, String worksProperly) async {
    final db = FirebaseFirestore.instance;
    final visitCollectionRef = db
        .collection(FirestoreCollections.beneficiaryData)
        .doc(idNumber)
        .collection(FirestoreCollections.visitData);

    // Find the first unused "VisitN" document (Visit1 if none exist yet).
    var visitNumber = 1;
    while (await visitCollectionRef
        .doc("Visit$visitNumber")
        .get()
        .then((snapshot) => snapshot.exists)) {
      visitNumber++;
    }

    await visitCollectionRef.doc("Visit$visitNumber").set({
      VisitFields.stoveImgVisit: imageUrl,
      VisitFields.usedRegularly: usedRegularly,
      VisitFields.worksProperly: worksProperly,
    });
  }

  Future<void> syncVisitDataToFirebase() async {
    for (var visitData in visitDataList) {
      try {
        isUploading.value = true;
        final idNumber = visitData.idNumber;
        if (idNumber.isNotEmpty) {
          final imageUrl =
              await uploadImageToFirestore(visitData.stoveImgVisit);
          await saveVisitDataToFirestore(idNumber, imageUrl,
              visitData.usedRegularly, visitData.worksProperly);

          // Remove synced visit data from local storage
          await removeVisitDataFromLocalStorage(visitData);
          isUploading.value = false;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    _finishSync(retrieveVisitDataFromLocalStorage);
  }

  Future<void> removeVisitDataFromLocalStorage(
      AddBeneficiaryVisitModel visitData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedVisitData = prefs.getStringList('visitData');
    if (savedVisitData != null) {
      savedVisitData.remove(jsonEncode(visitData.toJson()));
      await prefs.setStringList('visitData', savedVisitData);
    }
  }

  Future<void> syncSurveyDataToFirebase() async {
    for (var surveyData in surveyDataList) {
      try {
        isUploading.value = true;
        // Upload images to Firebase Storage and get download URLs
        List<String> imageUrls = await uploadSurveyImagesToStorage(surveyData);

        // Create a new instance of SurveyModel with updated image URLs
        SurveyModel updatedSurveyData = SurveyModel(
          id: surveyData.id,
          image: imageUrls[0],
          idImageFront: imageUrls[1],
          idImageBack: imageUrls[2],
          fullName: surveyData.fullName,
          address1: surveyData.address1,
          address2: surveyData.address2,
          town: surveyData.town,
          state: surveyData.state,
          zip: surveyData.zip,
          phoneNumber: surveyData.phoneNumber,
          totalPersons: surveyData.totalPersons,
          idNumber: surveyData.idNumber,
          idType: surveyData.idType,
          gender: surveyData.gender,
          fuelType1: surveyData.fuelType1,
          fuelType2: surveyData.fuelType2,
          fuelType1amount: surveyData.fuelType1amount,
          fuelType2amount: surveyData.fuelType2amount,
          currentDate: surveyData.currentDate,
          surveyorName: surveyData.surveyorName,
        );

        // Save the updated surveyData to Firestore
        await surveyRepo.addSurveyData(updatedSurveyData);

        // Remove synced survey data from local storage
        await removeSurveyDataFromLocalStorage(surveyData);
        isUploading.value = false;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    _finishSync(retrieveSurveyDataFromLocalStorage);
  }

  Future<List<String>> uploadSurveyImagesToStorage(
      SurveyModel surveyData) async {
    List<String> downloadUrls = [];

    // Upload Image to Firebase Storage
    String imageUrl = await uploadImage(surveyData.image);
    downloadUrls.add(imageUrl);

    // Upload IdImage1 to Firebase Storage
    String idImageUrl1 = await uploadImage(surveyData.idImageFront);
    downloadUrls.add(idImageUrl1);

    // Upload IdImage2 to Firebase Storage
    String idImageUrl2 = await uploadImage(surveyData.idImageBack);
    downloadUrls.add(idImageUrl2);
    return downloadUrls;
  }

  Future<void> removeSurveyDataFromLocalStorage(SurveyModel surveyData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSurveyData = prefs.getStringList('surveyData');
    if (savedSurveyData != null) {
      savedSurveyData.remove(jsonEncode(surveyData.toJson()));
      await prefs.setStringList('surveyData', savedSurveyData);
    }
  }

  Future<void> shareFormData() => _jsonShareService.shareAsJson(
        formDataList,
        (data) => data.toJson(),
        fileName: 'form_data.json',
        shareText: 'Sharing FormData as JSON with Images',
        errorContext: 'shareFormData',
      );

  Future<void> sharePrimaryBeneficiaryData() => _jsonShareService.shareAsJson(
        primaryBeneficiaryDataList,
        (data) => data.toJson(),
        fileName: 'primary_beneficiary_data.json',
        shareText: 'Sharing Primary Beneficiary Data as JSON',
        errorContext: 'sharePrimaryBeneficiaryData',
      );

  Future<void> shareSurveyData() => _jsonShareService.shareAsJson(
        surveyDataList,
        (data) => data.toJson(),
        fileName: 'survey_data.json',
        shareText: 'Sharing Survey Data as JSON',
        errorContext: 'shareSurveyData',
      );

  Future<void> shareVisitData() => _jsonShareService.shareAsJson(
        visitDataList,
        (data) => data.toJson(),
        fileName: 'visit_data.json',
        shareText: 'Sharing Visit Data as JSON',
        errorContext: 'shareVisitData',
      );
}
