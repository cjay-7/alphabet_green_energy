import 'package:alphabet_green_energy/src/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/text.dart';

Column personalDetailsForm(BuildContext context) {
  late String _firstName,
      _middleName,
      _surname,
      _address1,
      _address2,
      _town,
      _zip,
      _phoneNumber;

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
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                onSaved: (value) {
                  _address1 = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                onSaved: (value) {
                  _address2 = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: aZipCode,
                    prefixIcon: const Icon(Icons.numbers_outlined),
                    hintText: aZipCode,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return;
                  }
                  return null;
                },
                onSaved: (value) {
                  _zip = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: aPhoneNo,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: aPhoneNo,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: const OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return;
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10.0,
      )
    ],
  );
}
