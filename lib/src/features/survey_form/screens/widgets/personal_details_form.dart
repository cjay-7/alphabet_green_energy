import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/text.dart';
import '../../controllers/survey_add_controller.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final controller = Get.put(SurveyAddController());
  _PersonalDetailsState() {
    gender = _genderList[0];
  }

  final _genderList = ["Male", "Female", "Prefer not to answer"];
  String? gender = "";

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(aPersonalDetails,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.fullName,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_outlined),
                      labelText: aFullName,
                      hintText: aFullNameHint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aFullNameValidator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.address1,
                  decoration: InputDecoration(
                      labelText: aAddress1,
                      prefixIcon: const Icon(Icons.home),
                      hintText: aAddress1Hint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aAddress1Validator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.address2,
                  decoration: InputDecoration(
                      labelText: aAddress2,
                      prefixIcon: const Icon(Icons.home_outlined),
                      hintText: aAddress2Hint,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aAddress2Validator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.town,
                  decoration: InputDecoration(
                      labelText: aTown,
                      prefixIcon: const Icon(Icons.holiday_village),
                      hintText: aTown,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aTownValidator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.state,
                  decoration: InputDecoration(
                      labelText: "State",
                      prefixIcon: const Icon(Icons.terrain),
                      hintText: "State",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aTownValidator;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.zip,
                  decoration: InputDecoration(
                      labelText: aZipCode,
                      prefixIcon: const Icon(Icons.numbers_outlined),
                      hintText: aZipCode,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Zip Code";
                    } else if (int.tryParse(value) == null) {
                      return 'Only numbers are allowed';
                    } else if (value.length != 6) {
                      return "Please enter valid Zip";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.phoneNumber,
                  decoration: InputDecoration(
                      labelText: aPhoneNo,
                      prefixIcon: const Icon(Icons.phone),
                      hintText: aPhoneNo,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Phone Number";
                    } else if (int.tryParse(value) == null) {
                      return 'Only numbers are allowed';
                    } else if (value.length != 10) {
                      return "Please enter valid Number";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownSearch(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        selectedItem: gender,
                        items: _genderList,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Gender",
                            prefixIcon: Icon(Icons.male),
                          ),
                        ),
                        onChanged: (val) {
                          controller.gender = val as String;
                        },
                        validator: (item) {
                          if (item == null) {
                            return aIDNoValidator;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.totalPersons,
                  decoration: InputDecoration(
                      labelText: "Number of Persons living in house",
                      prefixIcon: const Icon(Icons.people),
                      hintText: "Enter Number",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  style: DefaultTextStyle.of(context).style.apply(
                      fontSizeFactor: .9,
                      color: isDark ? Colors.white70 : Colors.black54),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Phone Number";
                    } else if (int.tryParse(value) == null) {
                      return 'Only numbers are allowed';
                    } else if (int.tryParse(value)! < 0) {
                      return "Please enter valid Number";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
