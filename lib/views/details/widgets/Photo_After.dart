import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class Photo_After extends StatefulWidget {
  final Function updateUrl;
  const Photo_After({super.key, required this.updateUrl});
  State<Photo_After> createState() => _Photo_AfterState();
}

class _Photo_AfterState extends State<Photo_After> {
  File? _deviceImage;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? PickedFile = await picker.pickImage(source: source);
      if (PickedFile != null && mounted) {
        setState(() {
          _deviceImage = File(PickedFile.path);
          widget.updateUrl(_deviceImage);
        });
      }
    } catch (e) {
      print('erreur lors de la séléction');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(
              Icons.photo_camera,
              color: Colors.orange,
            ),
            label: Text(
              'etat apres intervention',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.w700),
            ),
          ),
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
        ])
      ],
    );
  }
}
