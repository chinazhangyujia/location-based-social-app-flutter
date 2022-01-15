import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_based_social_app/model/media_type.dart';
import 'package:location_based_social_app/util/config.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:location_based_social_app/widget/post/video_item.dart';
import 'package:video_player/video_player.dart';

/// Pick image from gallery for new post
/// Before release we should change it to taking photo only
/// Currently we use gallery only for test since simulator doesn't support taking photo
/// 

class GalleryImagePicker extends StatelessWidget {
  final List<File> pickedMedias;
  final void Function(File) onAddMedia;
  final void Function(int) onDeleteMedia;
  final void Function() clearAllMedias;
  final MediaType pickerMode;
  final void Function(MediaType) onChangePickerMode;

  ImagePicker imagePicker = ImagePicker();

  GalleryImagePicker({
    @required this.pickedMedias, 
    @required this.onAddMedia, 
    @required this.onDeleteMedia, 
    @required this.clearAllMedias,
    @required this.pickerMode, 
    @required this.onChangePickerMode});

  Future<void> pickImage(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (pickedMedias.length >= 6) {
      return;
    }

    final PickedFile pickedImage = await imagePicker.getImage(
      source: mode == Mode.DEV ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedImage == null) {
      return;
    }

    onAddMedia(File(pickedImage.path));
  }

  Future<void> pickVideo(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (pickedMedias.length >= 6) {
      return;
    }

    final PickedFile pickedVideo = await imagePicker.getVideo(
      source: mode == Mode.DEV ? ImageSource.gallery : ImageSource.camera,
      maxDuration: const Duration(seconds: 3)
    );

    if (pickedVideo == null) {
      return;
    }

    onAddMedia(File(pickedVideo.path));
  }

  List<Widget> _getSelectedMedia() {

    return pickedMedias
              .asMap()
              .map((index, media) => MapEntry(
                  index,
                  Stack(children: <Widget>[
                    Container(
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: pickerMode == MediaType.IMAGE ? Image.file(
                            media,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ) : VideoItem(videoPlayerController: VideoPlayerController.file(media)),
                      ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            onDeleteMedia(index);
                          },
                          child: Icon(
                            Icons.close_sharp,
                            color: Colors.grey.shade400,
                          ),
                        ))
                  ])))
              .values
              .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.only(bottom: 10),
          child: LiteRollingSwitch(
            value: false,
            textOn: 'Video',
            textOff: 'Image',
            colorOn: Colors.orange,
            colorOff: Colors.green,
            iconOn: Icons.video_call,
            iconOff: Icons.image,
            onChanged: (bool imageModeSelected) {
              final MediaType selectedMode = imageModeSelected ? MediaType.VIDEO : MediaType.IMAGE;
              if (selectedMode != pickerMode) {
                onChangePickerMode(selectedMode);
                clearAllMedias();
              }
            },
          ),
        ),
        if (pickedMedias.isEmpty)  GestureDetector(
          onTap: () {
            pickerMode == MediaType.IMAGE ? pickImage(context) : pickVideo(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: pickerMode == MediaType.IMAGE ? const Icon(Icons.camera_alt_outlined) : const Icon(Icons.video_call),
          ),
        ),
        ..._getSelectedMedia()
      ],
    );
  }
}
