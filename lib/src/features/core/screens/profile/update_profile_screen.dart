import 'dart:io';

import 'package:alphabet_green_energy/src/common_widgets/phone_number_field.dart';
import 'package:alphabet_green_energy/src/constants/colors.dart';
import 'package:alphabet_green_energy/src/features/core/controllers/profile_controller.dart';
import 'package:alphabet_green_energy/src/features/core/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../utils/safe_snackbar.dart';
import 'change_password_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _picker = ImagePicker();
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  late String _phoneNo;

  @override
  void initState() {
    super.initState();
    final user = controller.userData.value;
    _fullNameController.text = user?.fullName ?? '';
    _phoneNo = user?.phoneNo ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final current = controller.userData.value;
    setState(() {
      _isSaving = true;
    });

    final updated = UserModel(
      id: current?.id,
      fullName: _fullNameController.text.trim(),
      email: current?.email ?? '',
      phoneNo: _phoneNo,
      profileImageUrl: current?.profileImageUrl ?? '',
    );
    final success = await controller.updateUserData(updated);

    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });
    if (success) {
      Get.back();
    }
  }

  Future<void> _changePhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(aTakePhoto),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(aChooseFromGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    // A profile photo only ever needs to render at avatar size — no reason
    // to pay the same quality/maxWidth as a stove/ID evidence photo.
    final pickedFile = await _picker.pickImage(
        source: source, imageQuality: 70, maxWidth: 512);
    if (pickedFile == null) return;

    final uid = AuthenticationRepository.instance.firebaseUser.value?.uid;
    final current = controller.userData.value;
    if (uid == null || current == null) return;

    setState(() {
      _isUploadingPhoto = true;
    });

    try {
      // Deterministic path (keyed by uid, not a generated filename) so a
      // changed photo overwrites the old one in Storage instead of leaving
      // every previous avatar behind.
      final ref =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      await ref.putFile(File(pickedFile.path));
      final url = await ref.getDownloadURL();

      final updated = UserModel(
        id: current.id,
        fullName: current.fullName,
        email: current.email,
        phoneNo: current.phoneNo,
        profileImageUrl: url,
      );
      await controller.updateUserData(updated);
    } catch (e) {
      if (!mounted) return;
      showSnackbarSafely("Error", "Failed to upload photo: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.userData.value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: Text(aEditProfile,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.apply(color: aPrimaryColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDefaultSize),
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    GestureDetector(
                      onTap: _isUploadingPhoto ? null : _changePhoto,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _isUploadingPhoto
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : (user.profileImageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: user.profileImageUrl,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              const Icon(Icons.person,
                                                  size: 100),
                                        )
                                      : const Icon(Icons.person, size: 100)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: aAccentColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 18, color: aDarkColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _fullNameController,
                            decoration: const InputDecoration(
                                label: Text(aFullName),
                                prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return aFullNameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: aFormHeight - 20),
                          TextFormField(
                            initialValue: user.email,
                            enabled: false,
                            decoration: const InputDecoration(
                                label: Text(aEmail),
                                prefixIcon: Icon(Icons.mail_outline),
                                helperText: aEmailNotEditable),
                          ),
                          const SizedBox(height: aFormHeight - 20),
                          PhoneNumberField(
                            initialValue: _phoneNo,
                            onChanged: (value) => _phoneNo = value,
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: aFormHeight),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _save,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text(aSave),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Get.to(() => const ChangePasswordScreen()),
                              child: const Text(aChangePassword),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
