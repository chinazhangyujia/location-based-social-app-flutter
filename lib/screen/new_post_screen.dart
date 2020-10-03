import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
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

  TextEditingController controller = TextEditingController();
  List<File> pickedImages = [];

  bool _isLoading = false;

  void onAddImage(File image) {
    setState(() {
      pickedImages.add(image);
    });
  }

  String _validatePost()
  {
    if (pickedImages.isEmpty && (controller.text == null || controller.text.trim().isEmpty)) {
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

      String postContent = (controller.text == null || controller.text.trim().isEmpty) ? null : controller.text.trim();
      await Provider.of<PostsProvider>(context, listen: false).uploadNewPost(postContent, downloadUrls);

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
  void dispose() {
    controller.dispose();
    super.dispose();
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
              MultilineTextField(controller),
              GalleryImagePicker(pickedImages, onAddImage)
            ],
          ),
        ),
      ),
    );
  }
}

