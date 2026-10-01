import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../constants/sizes.dart';
import '../constants/text.dart';

/// The "pick a photo, then upload it online or cache it locally depending
/// on connectivity" button row repeated across every stove/ID/consent photo
/// field in the beneficiary and survey forms — same pick button, same
/// three-state upload button (spinner / check / upload icon), same
/// filename display, every time.
///
/// The caller only supplies *where the image goes* once picked:
/// [onUploadOnline] and [onUploadOffline] each receive the picked [File]
/// and return the URL/path that should be stored for it; [onUploaded] is
/// then called with that result so the caller can assign it to whichever
/// controller field it belongs to.
class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.pickButtonLabel,
    required this.onUploadOnline,
    required this.onUploadOffline,
    required this.onUploaded,
  });

  final String pickButtonLabel;
  final Future<String> Function(File file) onUploadOnline;
  final Future<String> Function(File file) onUploadOffline;
  final ValueChanged<String> onUploaded;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _imageFile;
  final _picker = ImagePicker();
  bool _isImageUploaded = false;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 65, maxWidth: 1600);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _upload(Future<String> Function(File) uploadFn) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await uploadFn(_imageFile!);
      widget.onUploaded(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      // Handle any errors that occurred during the upload process
    } finally {
      if (mounted) {
        setState(() {
          _isImageUploaded = true;
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: aSubmitButtonHeight,
                child: OutlinedButton(
                  onPressed: () => _pickImage(),
                  child: Text(
                    widget.pickButtonLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: aButtonGap),
            Expanded(
              child: SizedBox(
                height: aSubmitButtonHeight,
                child: ElevatedButton.icon(
                  onPressed: (_imageFile == null || _isUploading)
                      ? null
                      : () async {
                          final result =
                              await Connectivity().checkConnectivity();
                          if (result.contains(ConnectivityResult.mobile) ||
                              result.contains(ConnectivityResult.wifi)) {
                            await _upload(widget.onUploadOnline);
                          } else if (result.contains(ConnectivityResult.none)) {
                            await _upload(widget.onUploadOffline);
                          }
                        },
                  icon: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : (_isImageUploaded
                          ? const Icon(Icons.check)
                          : const Icon(Icons.upload)),
                  label: Text(
                    _isImageUploaded ? aUploaded : aUpload,
                    style: GoogleFonts.montserrat(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          fileName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
