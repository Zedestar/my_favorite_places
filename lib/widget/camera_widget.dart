import 'dart:io';

import 'package:favourite_places/functions/addImageToParent.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cameraring extends StatefulWidget {
  const Cameraring({super.key, required this.adderFunction});

  final AddImageToParent adderFunction;

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
    if (theImage == null) {
      return;
    }
    setState(() {
      _imageTaken = File(theImage.path);
      widget.adderFunction(_imageTaken!);
    });
  }

  @override
  Widget build(BuildContext context) {
    content = OutlinedButton.icon(
      onPressed: captureImage,
      label: Text("Camera"),
      icon: Icon(Icons.camera),
    );

    if (_imageTaken != null) {
      content = GestureDetector(
        onTap: captureImage,
        child: Image.file(
          _imageTaken!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: 250,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
