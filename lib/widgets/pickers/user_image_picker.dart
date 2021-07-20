import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker({required this.imagePickFn});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    var picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImage;
    });
    widget.imagePickFn(File(pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImage == null ? null : FileImage(File(_pickedImage!.path)),
          radius: 45,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera),
            label: Text('Add Image'))
      ],
    );
  }
}
