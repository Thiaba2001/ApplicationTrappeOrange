import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PhotoFormImagePicker extends StatefulWidget {
  const PhotoFormImagePicker({super.key, required this.updateUrl});
  final Function updateUrl;
  @override
  State<PhotoFormImagePicker> createState() => _PhotoFormImagePickerState();
}

class _PhotoFormImagePickerState extends State<PhotoFormImagePicker> {
  File? _deviceImage;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {});
        _deviceImage = File(pickedFile.path);
        widget.updateUrl(_deviceImage);
      }
    } catch (e) {
      print('erreur lors de la sélection de l\'image');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(
                Icons.photo_camera,
                color: Colors.orange,
              ),
              label: Text(
                'etat avant Intervention',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.w700),
              )),
          TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(
                Icons.photo,
                color: Colors.orange,
              ),
              label: Text(
                'Galerie',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.w700),
              )),
          Expanded(
            child: _deviceImage != null
                ? Image.file(
                    _deviceImage!,
                    fit: BoxFit.cover,
                  )
                : const Text('Aucune image'),
          )
        ],
      ),
    ]);
  }
}
