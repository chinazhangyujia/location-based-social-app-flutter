import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryImagePicker extends StatelessWidget {
  final List<File> pickedImages;
  final Function onAddImage;

  final ImagePicker imagePicker = ImagePicker();

  GalleryImagePicker(this.pickedImages, this.onAddImage);

  Future<void> pickImage(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (pickedImages.length >= 6) {
      return;
    }

    PickedFile pickedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxWidth: 500
    );

    if (pickedImages == null) {
      return;
    }

    onAddImage(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      primary: false,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      children: [
        ...pickedImages.map((image) => Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        )).toList(),
        if (pickedImages.length < 6) GestureDetector(
          onTap: () {pickImage(context);},
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }
}

