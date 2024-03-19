import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/customInputFormatter.dart';
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
  late ConnectivityResult connectivityResult =
      ConnectivityResult.none; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    connectivityResult = await Connectivity().checkConnectivity();
    setState(() {}); // Refresh the UI after getting connectivity status
  }

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
                Text(
                    connectivityResult != ConnectivityResult.none
                        ? 'Enter CookStove Serial Number:'
                        : 'Enter Beneficiary ID Number:',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: connectivityResult != ConnectivityResult.none
                      ? _beneficiaryController.stoveID
                      : _beneficiaryController.idNumber,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: connectivityResult != ConnectivityResult.none
                        ? 'Enter Stove ID'
                        : 'Enter ID Number',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    CustomInputFormatter('AL-V2-24-')
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return connectivityResult != ConnectivityResult.none
                          ? "Please enter Stove ID"
                          : "Please enter ID Number";
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
                          connectivityResult != ConnectivityResult.none
                              ? _beneficiaryController.stoveID.text
                              : _beneficiaryController.idNumber.text,
                          _beneficiaryController,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BeneficiaryListScreen(),
                            settings: RouteSettings(
                                arguments:
                                    _beneficiaryController.idNumber.text),
                          ),
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
