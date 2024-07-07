import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({required this.onPickImage, super.key});
  final void Function(File image) onPickImage;
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext contex) {
    Widget content = TextButton.icon(
        onPressed: _takePicture,
        icon: const Icon(Icons.camera_alt),
        label: const Text("Take Picture"));
    if (_selectedImage != null) {
      setState(() {
        content = GestureDetector(
          onTap: _takePicture,
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      });
    }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
              width: 0.5,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
      alignment: Alignment.center,
      child: content,
    );
  }
}
