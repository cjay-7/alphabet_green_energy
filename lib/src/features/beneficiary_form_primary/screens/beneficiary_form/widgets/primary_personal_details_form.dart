import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/primary_beneficiary_add_controller.dart';

Column primaryPersonalDetailsForm(BuildContext context) {
  final controller = Get.put(PrimaryBeneficiaryAddController());

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
          ],
        ),
      ),
    ],
  );
}
