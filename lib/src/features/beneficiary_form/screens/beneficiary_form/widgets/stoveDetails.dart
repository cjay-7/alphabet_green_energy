import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

class StoveDetails extends StatefulWidget {
  const StoveDetails({Key? key}) : super(key: key);

  @override
  State<StoveDetails> createState() => _StoveDetailsState();
}

class _StoveDetailsState extends State<StoveDetails> {
  final controller = Get.put(BeneficiaryAddController());
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
    return Container(
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
            child: Text("Stove Details",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.stoveID,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fireplace),
                  labelText: "Stove ID",
                  hintText: "Stove ID",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  border: const OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter Stove ID";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () => pickImage(),
                    child: Text(aAddStovePicture,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .17,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => pickImage(),
                    child: Text("Save",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
