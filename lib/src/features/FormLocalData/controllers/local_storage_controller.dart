import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/beneficiary_add_repository/beneficiary_add_repository.dart';
import '../../../repository/survey_add_repository/survey_add_repository.dart';
import '../../beneficiary_form/controllers/beneficiary_add_controller.dart';
import '../../beneficiary_form/models/beneficiary_model.dart';
import '../../existing_beneficiary/models/add_beneficiary_visit_model.dart';
import '../../survey_form/models/survey_model.dart';
import 'local_storage_repository.dart';

class LocalStorageController extends GetxController {
  static LocalStorageController get instance => Get.find();
  RxList<BeneficiaryModel> formDataList = RxList<BeneficiaryModel>();
  RxList<AddBeneficiaryVisitModel> visitDataList =
      RxList<AddBeneficiaryVisitModel>();
  RxList<SurveyModel> surveyDataList = RxList<SurveyModel>();
  final beneficiaryAddController = Get.put(BeneficiaryAddController());
  final LocalStorageRepository _localStorageRepo = LocalStorageRepository();
  final beneficiaryAddRepo = Get.put(BeneficiaryAddRepository());
  final surveyRepo = Get.put(SurveyAddRepository());
  RxInt formDataCount = 0.obs;
  RxInt visitDataCount = 0.obs;
  RxInt surveyDataCount = 0.obs;

  @override
  void onInit() {
    // Call the updateCounts() method whenever formDataList or visitDataList changes
    ever(formDataList, (_) {
      updateCounts();
    });

    ever(visitDataList, (_) {
      updateCounts();
    });

    super.onInit();
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
    formDataCount.value = formDataList.length;
    visitDataCount.value = visitDataList.length;
    surveyDataCount.value = surveyDataList.length;
  }

  Future<void> syncFormDataToFirebase() async {
    for (var formData in formDataList) {
      try {
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
          idImage: imageUrls[4],
          fullName: formData.fullName,
          address1: formData.address1,
          address2: formData.address2,
          town: formData.town,
          zip: formData.zip,
          phoneNumber: formData.phoneNumber,
          idNumber: formData.idNumber,
          idType: formData.idType,
        );

        // Save the updated formData to Firestore
        await beneficiaryAddRepo.addData(updatedFormData);

        // Remove synced form data from local storage
        await removeFormDataFromLocalStorage(formData);
      } catch (e) {}
    }
    updateCounts();
    // Refresh the screen to reflect the updated form data
    retrieveFormDataFromLocalStorage();
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
    String idImageUrl = await uploadImage(formData.idImage);
    downloadUrls.add(idImageUrl);

    return downloadUrls;
  }

  Future<String> uploadImage(String imagePath) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref =
        FirebaseStorage.instance.ref().child('images/$imageName.jpg');

    UploadTask uploadTask = ref.putFile(File(imagePath));
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> uploadImageToFirestore(String imagePath) async {
    final file = File(imagePath);
    final fileName = file.path.split('/').last;

    final storageRef = FirebaseStorage.instance.ref().child('files/$fileName');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> saveVisitDataToFirestore(String idNumber, String imageUrl,
      String usedRegularly, String worksProperly) async {
    final db = FirebaseFirestore.instance;
    final visitCollectionRef =
        db.collection("BeneficiaryData").doc(idNumber).collection("VisitData");

    DocumentSnapshot visit1Snapshot =
        await visitCollectionRef.doc("Visit1").get();

    if (visit1Snapshot.exists) {
      // Visit1 exists, find the next available Visit document
      int nextVisitNumber = 2;
      while (true) {
        DocumentSnapshot visitSnapshot =
            await visitCollectionRef.doc("Visit$nextVisitNumber").get();
        if (!visitSnapshot.exists) {
          // Set the data to the next available Visit document
          await visitCollectionRef.doc("Visit$nextVisitNumber").set({
            "StoveImgVisit": imageUrl,
            "usedRegularly": usedRegularly,
            "worksProperly": worksProperly,
          }).then((value) {});
          break;
        }
        nextVisitNumber++;
      }
    } else {
      // Visit1 does not exist, set the data to Visit1
      await visitCollectionRef
          .doc("Visit1")
          .set({
            "StoveImgVisit": imageUrl,
            "usedRegularly": usedRegularly,
            "worksProperly": worksProperly,
          })
          .then((value) {})
          .catchError((error) {});
    }
  }

  Future<void> syncVisitDataToFirebase() async {
    for (var visitData in visitDataList) {
      try {
        final idNumber = visitData.idNumber;
        if (idNumber.isNotEmpty) {
          final imageUrl =
              await uploadImageToFirestore(visitData.stoveImgVisit);
          await saveVisitDataToFirestore(idNumber, imageUrl,
              visitData.usedRegularly, visitData.worksProperly);

          // Remove synced visit data from local storage
          await removeVisitDataFromLocalStorage(visitData);
        }
      } catch (e) {}
    }
    updateCounts();
    retrieveVisitDataFromLocalStorage();
  }

  Future<void> removeFormDataFromLocalStorage(BeneficiaryModel formData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedFormData = prefs.getStringList('formData');
    if (savedFormData != null) {
      savedFormData.remove(jsonEncode(formData.toJson()));
      await prefs.setStringList('formData', savedFormData);
    }
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
        // Upload images to Firebase Storage and get download URLs
        List<String> imageUrls = await uploadSurveyImagesToStorage(surveyData);

        // Create a new instance of SurveyModel with updated image URLs
        SurveyModel updatedSurveyData = SurveyModel(
          id: surveyData.id,
          image: imageUrls[0],
          idImage: imageUrls[1],
          fullName: surveyData.fullName,
          address1: surveyData.address1,
          address2: surveyData.address2,
          town: surveyData.town,
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
      } catch (e) {}
    }
    updateCounts();
    // Refresh the screen to reflect the updated survey data
    retrieveFormDataFromLocalStorage();
  }

  Future<void> removeSurveyDataFromLocalStorage(SurveyModel surveyData) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSurveyData = prefs.getStringList('surveyData');
    if (savedSurveyData != null) {
      savedSurveyData.remove(jsonEncode(surveyData.toJson()));
      await prefs.setStringList('surveyData', savedSurveyData);
    }
  }

  Future<List<String>> uploadSurveyImagesToStorage(
      SurveyModel surveyData) async {
    List<String> downloadUrls = [];

    // Upload Image to Firebase Storage
    String imageUrl = await uploadImage(surveyData.image);
    downloadUrls.add(imageUrl);

    // Upload IdImage to Firebase Storage
    String idImageUrl = await uploadImage(surveyData.idImage);
    downloadUrls.add(idImageUrl);

    return downloadUrls;
  }
}
