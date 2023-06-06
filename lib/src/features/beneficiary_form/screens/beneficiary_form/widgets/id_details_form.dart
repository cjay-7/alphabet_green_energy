import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

import 'package:path/path.dart';

class IdDetails extends StatefulWidget {
  const IdDetails({Key? key}) : super(key: key);

  @override
  State<IdDetails> createState() => _IdDetailsState();
}

class _IdDetailsState extends State<IdDetails> {
  _IdDetailsState() {
    idType = _idList[0];
  }
  final controller = Get.put(BeneficiaryAddController());

  final _idList = ["Aadhar Card", "Voter Card", "Pan Card", "Ration Card"];
  String? idType = "";

  File? _imageFile;
  UploadTask? uploadTask;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile!.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot? taskSnapshot =
        await uploadTask?.whenComplete(() => uploadTask?.snapshot);
    taskSnapshot?.ref.getDownloadURL().then(
          (value) => controller.idImg = value,
        );
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Text(aIdentificationDetails,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownSearch(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        selectedItem: idType,
                        items: _idList,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: aIdentificationType,
                            prefixIcon: Icon(Icons.add_card_rounded),
                          ),
                        ),
                        onChanged: (val) {
                          controller.idType = val as String;
                        },
                        validator: (item) {
                          if (item == null) {
                            return aIDNoValidator;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.idNumber,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_outlined),
                      labelText: aIDNo,
                      hintText: aIDNo,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return aIDNoValidator;
                    }
                    return null;
                  },
                ),
              ),
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
                            onPressed: () => pickImage(),
                            child: Text(aIDPhoto,
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .17,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () => uploadImageToFirebase(),
                            child: Text("Upload",
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      fileName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
