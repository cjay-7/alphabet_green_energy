import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
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
        FormSectionCard(
          title: aPersonalDetails,
          children: [
            FormFieldPadding(
              child: TextFormField(
                controller: controller.fullName,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_outlined),
                  labelText: aFullName,
                  hintText: aFullNameHint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aFullNameValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.address1,
                decoration: InputDecoration(
                  labelText: aAddress1,
                  prefixIcon: const Icon(Icons.home),
                  hintText: aAddress1Hint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aAddress1Validator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.address2,
                decoration: InputDecoration(
                  labelText: aAddress2,
                  prefixIcon: const Icon(Icons.home_outlined),
                  hintText: aAddress2Hint,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aAddress2Validator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.town,
                decoration: InputDecoration(
                  labelText: aTown,
                  prefixIcon: const Icon(Icons.holiday_village),
                  hintText: aTown,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aTownValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.state,
                decoration: InputDecoration(
                  labelText: aStateFieldLabel,
                  prefixIcon: const Icon(Icons.terrain),
                  hintText: aStateFieldLabel,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aStateValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.zip,
                decoration: InputDecoration(
                  labelText: aZipCode,
                  prefixIcon: const Icon(Icons.numbers_outlined),
                  hintText: aZipCode,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return aPleaseEnterZipCode;
                  } else if (int.tryParse(value) == null) {
                    return aOnlyNumbersAllowed;
                  } else if (value.length != 6) {
                    return aInvalidZip;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.phoneNumber,
                decoration: InputDecoration(
                  labelText: aPhoneNo,
                  prefixIcon: const Icon(Icons.phone),
                  hintText: aPhoneNo,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return aPhoneNumberRequired;
                  } else if (int.tryParse(value) == null) {
                    return aOnlyNumbersAllowed;
                  } else if (value.length != 10) {
                    return aInvalidPhoneNumber;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
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
                          labelText: aGenderFieldLabel,
                          prefixIcon: Icon(Icons.male),
                        ),
                      ),
                      onChanged: (val) {
                        controller.gender = val as String;
                      },
                      validator: (item) {
                        if (item == null) {
                          return aGenderValidator;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            FormFieldPadding(
              child: TextFormField(
                controller: controller.totalPersons,
                decoration: InputDecoration(
                  labelText: aNumberOfPersonsLabel,
                  prefixIcon: const Icon(Icons.people),
                  hintText: aEnterNumberHint,
                ),
                keyboardType: TextInputType.phone,
                style: DefaultTextStyle.of(context).style.apply(
                    fontSizeFactor: .9,
                    color: isDark ? Colors.white70 : Colors.black54),
                validator: (value) {
                  if (value!.isEmpty) {
                    return aNumberOfPersonsRequired;
                  } else if (int.tryParse(value) == null) {
                    return aOnlyNumbersAllowed;
                  } else if (int.tryParse(value)! < 0) {
                    return aInvalidNumberOfPersons;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
