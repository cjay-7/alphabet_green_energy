import 'dart:io';

import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/id_details_form.dart';
import 'package:alphabet_green_energy/src/features/beneficiary_form/screens/beneficiary_form/widgets/personal_details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/text.dart';

class BeneficiaryFormWidget extends StatefulWidget {
  const BeneficiaryFormWidget({super.key});

  @override
  _BeneficiaryFormWidgetState createState() => _BeneficiaryFormWidgetState();
}

class _BeneficiaryFormWidgetState extends State<BeneficiaryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      SnackBar(
        content: Text("Failed to pick image: $e"),
      );
    }
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: OutlinedButton(
                        onPressed: () => pickImage(),
                        child: Text(aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: OutlinedButton(
                        onPressed: () => pickImage(),
                        child: Text(aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: OutlinedButton(
                        onPressed: () => pickImage(),
                        child: Text(aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                personalDetailsForm(context),
                const idDetails(),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Do something with the form data
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
