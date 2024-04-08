// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// // Function to fetch data from API based on the entered PIN code
// Future<void> getDataFromPinCode(String pinCode) async {
//   final url = "http://www.postalpincode.in/api/pincode/$pinCode";
//
//   try {
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//
//       if (jsonResponse['Status'] == 'Error') {
//         // Show a snackbar if the PIN code is not valid
//         showSnackbar(context, "Pin Code is not valid. ");
//         setState(() {
//           pinCodeDetails = 'Pin code is not valid.';
//         });
//       } else {
//         // Parse and display details if the PIN code is valid
//         final postOfficeArray = jsonResponse['PostOffice'] as List;
//         final obj = postOfficeArray[0];
//
//         final district = obj['District'];
//         final state = obj['State'];
//         final country = obj['Country'];
//
//         setState(() {
//           pinCodeDetails =
//               'Details of pin code are:\nDistrict: $district\nState: $state\nCountry: $country';
//         });
//       }
//     } else {
//       // Show a snackbar if there is an issue fetching data
//       showSnackbar(context, "Failed to fetch data. Please try again");
//       setState(() {
//         pinCodeDetails = 'Failed to fetch data. Please try again.';
//       });
//     }
//   } catch (e) {
//     // Show a snackbar if an error occurs during the API call
//     showSnackbar(context, "Error Occurred. Please try again");
//     setState(() {
//       pinCodeDetails = 'Error occurred. Please try again.';
//     });
//   }
// }
