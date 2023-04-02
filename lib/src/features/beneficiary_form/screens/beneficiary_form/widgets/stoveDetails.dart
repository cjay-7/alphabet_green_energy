import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

import '../../../../../api/firebase_api.dart';
import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

class StoveDetails extends StatefulWidget {
  const StoveDetails({Key? key}) : super(key: key);

  @override
  State<StoveDetails> createState() => _StoveDetailsState();
}

class _StoveDetailsState extends State<StoveDetails> {
  final controller = Get.put(BeneficiaryAddController());
  // UploadTask? task;
  File? image;

  @override
  Widget build(BuildContext context) {
    // final fileName = file != null ? basename(file!.path) : 'No File Selected';
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text("Stove Details",
          //       style: Theme.of(context).textTheme.headlineMedium),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(
          //     controller: controller.stoveID,
          //     decoration: InputDecoration(
          //         prefixIcon: const Icon(Icons.fireplace),
          //         labelText: "Stove ID",
          //         hintText: "Stove ID",
          //         hintStyle: Theme.of(context).textTheme.bodySmall,
          //         border: const OutlineInputBorder()),
          //     validator: (value) {
          //       if (value!.isEmpty) {
          //         return "Please enter Stove ID";
          //       }
          //       return null;
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 60,
                      child: OutlinedButton(
                        onPressed: () => selectFile(),
                        child: Text(aAddStovePicture,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .17,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => uploadFile(),
                        child: Text("Save",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                  ],
                ),
                // Text(
                //   fileName,
                //   style: const TextStyle(
                //       fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                // task != null ? buildUploadStatus(task!) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future selectFile() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;
    final path = (File(image.path));

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    if (kDebugMode) {
      print('Download-Link: $urlDownload');
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
