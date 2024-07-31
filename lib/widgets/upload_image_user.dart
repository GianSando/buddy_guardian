import 'dart:io';
import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:buddy_guardian/utils/utils_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageUser(BuildContext context) async {
  File? image;
  try {
    final ImageSource? source = await showImageSourceDialog(context);
    if (source != null) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    }
  } catch (e) {
    showSnackbar(context, e.toString());
  }
  return image;
}

Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
  return showDialog<ImageSource?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.purpleColors,
        title: const Text('Seleccionar imagen',
            style: TextStyle(fontFamily: "CB", color: AppColors.text),
            textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              MaterialButton(
                color: AppColors.blueColors,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                splashColor: AppColors.orangeAcents,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cámara', style: styleText()),
                    const SizedBox(width: 10),
                    const Icon(Icons.camera_alt_rounded)
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              MaterialButton(
                color: AppColors.orangeAcents.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                splashColor: AppColors.blueColors,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Galería', style: styleText()),
                    const SizedBox(width: 10),
                    const Icon(Icons.image_rounded)
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

TextStyle styleText() => const TextStyle(fontFamily: "CB", fontSize: 16);
