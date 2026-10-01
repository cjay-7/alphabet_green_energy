import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/customInputFormatter.dart';
import '../../../../common_widgets/form_field_padding.dart';
import '../../../../common_widgets/form_section_card.dart';
import '../../../../common_widgets/image_upload_field.dart';
import '../../../../constants/text.dart';
import '../../../../utils/location_tagged_upload_mixin.dart';
import '../../../beneficiary_form/controllers/beneficiary_add_controller.dart';

class StoveDetails extends StatefulWidget {
  const StoveDetails({super.key});

  @override
  State<StoveDetails> createState() => _StoveDetailsState();
}

class _StoveDetailsState extends State<StoveDetails>
    with LocationTaggedUploadMixin {
  final controller = Get.put(BeneficiaryAddController());

  Future<String> _uploadToLocalStorage(File file) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating upload delay
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: aStoveDetails,
      children: [
        FormFieldPadding(
          child: TextFormField(
            controller: controller.stoveID,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.fireplace),
              labelText: aEnterStoveID,
              hintText: aStoveIDHint,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
              CustomInputFormatter('AL-V2-24-')
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return aStoveIDRequired;
              } else if (value.length != 20 || !value.startsWith("AL-V2-24-")) {
                return aInvalidStoveID;
              }
              return null;
            },
          ),
        ),
        FormFieldPadding(
          child: ImageUploadField(
            pickButtonLabel: aStovePictureWithId,
            onUploadOnline: uploadWithLocationTag,
            onUploadOffline: _uploadToLocalStorage,
            onUploaded: (result) => controller.stoveImg = result,
          ),
        ),
      ],
    );
  }
}
