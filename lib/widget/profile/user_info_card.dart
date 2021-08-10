import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/screen/profile/edit_self_introduction_screen.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/util/image_upload_util.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatelessWidget {

  final User user;
  final ImagePicker imagePicker = ImagePicker();

  UserInfoCard(this.user);

  Future<void> pickImage(BuildContext context) async {

    final PickedFile imageFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 300,
        maxHeight: 300
    );

    if (imageFile == null) {
      Navigator.of(context).pop();
      return;
    }

    final File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      try {
        final String authToken = Provider.of<AuthProvider>(context, listen: false).token;

        final S3Url s3url  = await ImageUploadUtil.getS3Urls(authToken, S3Folder.USER_AVATAR);
        await ImageUploadUtil.uploadToS3(s3url.uploadUrl, croppedFile);
        await Provider.of<UserProvider>(context, listen: false).updateUserInfo(avatarUrl: s3url.downloadUrl);
      } catch (error) {
        renderErrorDialog(context, 'Failed update avatar. Please try later');
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              child: const Text('Choose from Album',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: const Text('Take Photo',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 8.0,
                            color: const Color.fromRGBO(244, 244, 244, 1),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 45,
                              child: const Text('Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl) : null,
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 7,)
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text('Self Introduction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(EditSelfIntroductionScreen.router);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10, left: 14),
            child: user.introduction != null && user.introduction.trim().isNotEmpty ? Text(
              user.introduction,
              style: const TextStyle(fontSize: 17),
            ) :
            const Text('Write something about yourself...', style: TextStyle(color: Colors.grey, fontSize: 16),),
          )
        )
      ],
    );
  }
}
