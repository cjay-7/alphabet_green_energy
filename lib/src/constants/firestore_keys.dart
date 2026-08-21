// Firestore collection names and document field keys, centralized so the
// same literal isn't hand-typed independently in every model/repository.
//
// These values mirror the existing Firestore schema exactly — changing any
// value here would change what's read from / written to a live database.

class FirestoreCollections {
  static const beneficiaryData = "BeneficiaryData";
  static const primaryBeneficiaryData = "PrimaryBeneficiaryData";
  static const surveyData = "SurveyData";
  static const users = "Users";
  static const visitData = "VisitData";
  static const errorLogs = "error_logs";
}

class BeneficiaryFields {
  static const stoveID = "StoveID";
  static const stoveImg = "StoveImg";
  static const fullName = "FullName";
  static const address1 = "Address1";
  static const address2 = "Address2";
  static const zip = "Zip";
  static const state = "State";
  static const district = "District";
  static const town = "Town";
  static const phoneNumber = "PhoneNumber";
  static const idNumber = "IdNumber";
  static const idType = "IdType";
  static const image1 = "Image1";
  static const image2 = "Image2";
  static const image3 = "Image3";
  static const idImageFront = "IdImageFront";
  static const idImageBack = "IdImageBack";
  static const consentImg = "ConsentImg";
  static const currentDate = "currentDate";
  static const surveyorName = "surveyorName";
}

class PrimaryBeneficiaryFields {
  static const stoveID = "StoveID";
  static const stoveImg = "StoveImg";
  static const fullName = "FullName";
  static const phoneNumber = "PhoneNumber";
  static const idNumber = "IdNumber";
  static const image1 = "Image1";
  static const idImageFront = "IdImageFront";
  static const idImageBack = "IdImageBack";
  static const currentDate = "currentDate";
  static const surveyorName = "surveyorName";
}

class SurveyFields {
  static const fullName = "FullName";
  static const address1 = "Address1";
  static const address2 = "Address2";
  static const town = "Town";
  static const state = "State";
  static const zip = "Zip";
  static const phoneNumber = "PhoneNumber";
  static const gender = "Gender";
  static const totalPersons = "TotalPersons";
  static const image = "Image";
  static const idType = "IdType";
  static const idNumber = "IdNumber";
  static const idImageFront = "IdImageFront";
  static const idImageBack = "IdImageBack";
  static const fuelType1 = "FuelType1";
  static const fuelType1amount = "FuelType1amount";
  static const fuelType2 = "FuelType2";
  static const fuelType2amount = "FuelType2amount";
  static const currentDate = "currentDate";
  static const surveyorName = "surveyorName";
}

class UserFields {
  static const fullName = "FullName";
  static const email = "EMail";
  static const phone = "Phone";
}

class VisitFields {
  static const stoveImgVisit = "StoveImgVisit";
  static const usedRegularly = "usedRegularly";
  static const worksProperly = "worksProperly";
  static const idNumber = "idNumber";
}
