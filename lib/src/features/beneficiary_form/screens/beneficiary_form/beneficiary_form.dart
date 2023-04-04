import 'dart:io';

import 'package:alphabet_green_energy/src/features/beneficiary_form/controllers/beneficiary_add_controller.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/models/beneficiary_model.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/final_pictures.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/id_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/personal_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/stoveDetails.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/text.dart';

class BeneficiaryFormWidget extends StatefulWidget {
  const BeneficiaryFormWidget({super.key});

  @override
  BeneficiaryFormWidgetState createState() => BeneficiaryFormWidgetState();
}

class BeneficiaryFormWidgetState extends State<BeneficiaryFormWidget> {
  final controller = Get.put(BeneficiaryAddController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(aAddBeneficiaryAppbar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StoveDetails(),
                // const Divider(),
                // personalDetailsForm(context),
                // const Divider(),
                // const IdDetails(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                // const FinalPictures(),
                // const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          controller.stoveImg != '') {
                        _formKey.currentState!.save();
                        final beneficiary = BeneficiaryModel(
                            stoveID: controller.stoveID.text.trim(),
                            fullName: controller.fullName.text.trim(),
                            address1: controller.address1.text.trim(),
                            address2: controller.address2.text.trim(),
                            town: controller.town.text.trim(),
                            zip: controller.zip.text.trim(),
                            phoneNumber: controller.phoneNumber.text.trim(),
                            idNumber: controller.idNumber.text.trim(),
                            idType: controller.idType,
                            stoveImg: controller.stoveImg);
                        BeneficiaryAddController.instance.addData(beneficiary);
                      } else if (controller.stoveImg == '') {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            builder: (context) => SizedBox(
                                height: 150,
                                child: Center(
                                  child:
                                      Text("Please add Stove Image",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),

                                )));
                      }
                    },
                    child: Text(
                      aSave,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
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
