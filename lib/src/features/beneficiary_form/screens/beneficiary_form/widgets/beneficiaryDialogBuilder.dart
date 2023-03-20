import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/text.dart';
import '../beneficiary_form.dart';

class BeneficiaryDialog {
  static Future<void> beneficiaryDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter CookStove Serial Number:',
              style: Theme.of(context).textTheme.headlineSmall),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  labelText: "CookStove Serial No:",
                  hintText: "Serial Number",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const BeneficiaryFormWidget());
                  },
                  child: Text(
                    aNext.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
