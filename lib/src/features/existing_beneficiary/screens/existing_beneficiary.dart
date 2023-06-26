import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/beneficiary_list_screen.dart';
import '../controllers/get_beneficiary_details_controller.dart';

class ExistingBeneficiary extends StatefulWidget {
  const ExistingBeneficiary({super.key});

  @override
  State<ExistingBeneficiary> createState() => _ExistingBeneficiaryState();
}

class _ExistingBeneficiaryState extends State<ExistingBeneficiary> {
  final _beneficiaryController = Get.put(BeneficiaryController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Existing Beneficiary'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Enter CookStove Serial Number:',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: _beneficiaryController.stoveID,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Enter Stove ID',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Stove ID";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _beneficiaryController.getBeneficiaryData(
                          _beneficiaryController.stoveID.text,
                          _beneficiaryController,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BeneficiaryListScreen()),
                        );
                      }
                    },
                    child: const Text('Get Beneficiary Details'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
