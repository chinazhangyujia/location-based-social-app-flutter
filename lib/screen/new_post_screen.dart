import 'dart:io';

import 'package:flutter/material.dart';
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

  bool _isPostEmpty()
  {
    return pickedImages.isEmpty && (text == null || text.trim().isEmpty);
  }

  void sendPost(BuildContext context, String authToken) async {
    if (_isPostEmpty()) {
      Navigator.of(context).pop();
      return;
    }

    try {
      final List<String> downloadUrls = [];

      if (pickedImages.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });

        for (final File file in pickedImages) {
          final S3Url s3url  = await ImageUploadUtil.getS3Urls(authToken, S3Folder.POST_IMAGE);
          await ImageUploadUtil.uploadToS3(s3url.uploadUrl, file);
          downloadUrls.add(s3url.downloadUrl);
        }
      }

      final String postContent = (text == null || text.trim().isEmpty) ? null : text.trim();
      final User loginUser = await Provider.of<UserProvider>(context, listen: false).getCurrentUser();

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
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: () {
              sendPost(context, authProvider.token);
            },
            child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 17),),
          )
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              MultilineTextField(onEdit: onChangeText, hint: 'Post something about what you see...',),
              GalleryImagePicker(pickedImages, onAddImage)
            ],
          ),
        ),
      ),
    );
  }
}

