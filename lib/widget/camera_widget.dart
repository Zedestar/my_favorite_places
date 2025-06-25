import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cameraring extends StatefulWidget {
  const Cameraring({super.key});

  @override
  State<Cameraring> createState() => _CameraringState();
}

class _CameraringState extends State<Cameraring> {
  File? _imageTaken;
  Widget? content;

  void captureImage() async {
    final imagePicker = ImagePicker();
    final theImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (theImage != null) {
      return;
    }
    setState(() {
      _imageTaken = File(theImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    content = OutlinedButton.icon(
      onPressed: () {},
      label: Text("Camera"),
      icon: Icon(Icons.camera),
    );

    if (_imageTaken != null) {
      content = Image.file(_imageTaken!);
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: 250,
      width: 250,
      alignment: Alignment.center,
      child: content,
    );
  }
}
