import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
import '../../../../common_widgets/image_upload_field.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../utils/location_tagged_upload_mixin.dart';
import '../../controllers/beneficiary_add_controller.dart';

class IdDetails extends StatefulWidget {
  const IdDetails({super.key});

  @override
  State<IdDetails> createState() => _IdDetailsState();
}

class _IdDetailsState extends State<IdDetails> with LocationTaggedUploadMixin {
  final controller = Get.put(BeneficiaryAddController());
  _IdDetailsState() {
    idType = _idList[0];
  }
  final _idList = aIdTypeOptions;
  String? idType = "";

  Future<String> _uploadToLocalStorage(File file) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating upload delay
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionCard(
          title: aIdentificationDetails,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormFieldPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: aFieldPadding),
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
            FormFieldPadding(
              child: TextFormField(
                controller: controller.idNumber,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_outlined),
                  labelText: aIDNo,
                  hintText: aIDNo,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return aIDNoValidator;
                  }
                  return null;
                },
              ),
            ),
            FormFieldPadding(
              child: ImageUploadField(
                pickButtonLabel: aIDPhotoFront,
                onUploadOnline: uploadWithLocationTag,
                onUploadOffline: _uploadToLocalStorage,
                onUploaded: (result) => controller.idImgFront = result,
              ),
            ),
            FormFieldPadding(
              child: ImageUploadField(
                pickButtonLabel: aIDPhotoBack,
                onUploadOnline: uploadWithLocationTag,
                onUploadOffline: _uploadToLocalStorage,
                onUploaded: (result) => controller.idImgBack = result,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
