import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/util/image_upload_util.dart';
import 'package:location_based_social_app/widget/gallery_image_picker.dart';
import 'package:location_based_social_app/widget/multiline_text_field.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  static const String router = '/NewPostScreen';

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  String text = '';
  List<File> pickedImages = [];

  bool _isLoading = false;

  void onAddImage(File image) {
    setState(() {
      pickedImages.add(image);
    });
  }

  void onChangeText(String value) {
    setState(() {
      text = value;
    });
  }

  String _validatePost()
  {
    if (pickedImages.isEmpty && (text == null || text.trim().isEmpty)) {
      return 'Please write something';
    }
    return null;
  }

  void sendPost(BuildContext context, String authToken) async {
    String errorMessage = _validatePost();
    if (errorMessage != null) {
      renderErrorDialog(context, errorMessage);
      return;
    }

    try {
      List<String> downloadUrls = [];

      if (pickedImages.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });

        for (File file in pickedImages) {
          S3Url s3url  = await ImageUploadUtil.getS3Urls(authToken);
          await ImageUploadUtil.uploadToS3(s3url.uploadUrl, file);
          downloadUrls.add(s3url.downloadUrl);
        }
      }

      String postContent = (text == null || text.trim().isEmpty) ? null : text.trim();
      User loginUser = await Provider.of<UserProvider>(context, listen: false).getCurrentUser();

      await Provider.of<PostsProvider>(context, listen: false).uploadNewPost(postContent, downloadUrls, loginUser);

      Navigator.of(context).pop();

    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, 'Failed to post. Please try later');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('New Post'),
        actions: [
          FlatButton(
            child: Text('Send', style: TextStyle(color: Colors.white, fontSize: 17),),
            onPressed: () {
              sendPost(context, authProvider.token);
            },
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              MultilineTextField(onChangeText),
              GalleryImagePicker(pickedImages, onAddImage)
            ],
          ),
        ),
      ),
    );
  }
}

