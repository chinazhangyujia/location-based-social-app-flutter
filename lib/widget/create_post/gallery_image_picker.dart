import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_based_social_app/util/config.dart';

/// Pick image from gallery for new post
/// Before release we should change it to taking photo only
/// Currently we use gallery only for test since simulator doesn't support taking photo
class GalleryImagePicker extends StatelessWidget {
  final List<File> pickedImages;
  final void Function(File) onAddImage;
  final void Function(int) onDeleteImage;

  final ImagePicker imagePicker = ImagePicker();

  GalleryImagePicker(this.pickedImages, this.onAddImage, this.onDeleteImage);

  Future<void> pickImage(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (pickedImages.length >= 6) {
      return;
    }

    final PickedFile pickedImage = await imagePicker.getImage(
      source: mode == Mode.DEV ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedImage == null) {
      return;
    }

    onAddImage(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      children: [
        ...pickedImages
            .asMap()
            .map((index, image) => MapEntry(
                index,
                Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          onDeleteImage(index);
                        },
                        child: Icon(
                          Icons.close_sharp,
                          color: Colors.grey.shade400,
                        ),
                      ))
                ])))
            .values
            .toList(),
        if (pickedImages.length < 6)
          GestureDetector(
            onTap: () {
              pickImage(context);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.add),
            ),
          )
      ],
    );
  }
}
