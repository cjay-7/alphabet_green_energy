import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

class FinalPictures extends StatefulWidget {
  const FinalPictures({Key? key}) : super(key: key);

  @override
  State<FinalPictures> createState() => _FinalPicturesState();
}

class _FinalPicturesState extends State<FinalPictures> {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(" Add pictures of stove handed to the beneficiary",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(aIDPhoto,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .17,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Save",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
