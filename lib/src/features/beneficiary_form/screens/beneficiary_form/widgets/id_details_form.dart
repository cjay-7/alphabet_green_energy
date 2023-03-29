import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/text.dart';
import '../../../controllers/beneficiary_add_controller.dart';

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

  File? image;

  final _idList = ["Aadhar Card", "Voter Card", "Pan Card", "Ration Card"];
  String? idType = "";

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
                child: Row(
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
                        onPressed: () => pickImage(),
                        child: Text("Save",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
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
