import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post_topics.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/util/image_upload_util.dart';
import 'package:location_based_social_app/widget/create_post/gallery_image_picker.dart';
import 'package:location_based_social_app/widget/create_post/multiline_text_field.dart';
import 'package:location_based_social_app/widget/create_post/post_topic_selector.dart';
import 'package:provider/provider.dart';

/// screen to write new post
class NewPostScreen extends StatefulWidget {
  static const String router = '/NewPostScreen';

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String text = '';
  List<File> pickedImages = [];
  String topicName;
  String errorMessage;

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

  void onSelectTopic(String selectedTopicName) {
    setState(() {
      topicName = selectedTopicName;
    });
  }

  bool _isPostEmpty() {
    return pickedImages.isEmpty && (text == null || text.trim().isEmpty);
  }

  void sendPost(BuildContext context, String authToken) async {
    if (_isPostEmpty()) {
      Navigator.of(context).pop();
      return;
    }

    if (getTopicByName(topicName) == null) {
      setState(() {
        errorMessage = 'Please select a topic';
      });
      return;
    }

    try {
      final List<String> downloadUrls = [];

      if (pickedImages.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });

        for (final File file in pickedImages) {
          final S3Url s3url =
              await ImageUploadUtil.getS3Urls(authToken, S3Folder.POST_IMAGE);
          await ImageUploadUtil.uploadToS3(s3url.uploadUrl, file);
          downloadUrls.add(s3url.downloadUrl);
        }
      }

      final String postContent =
          (text == null || text.trim().isEmpty) ? null : text.trim();
      final User loginUser =
          await Provider.of<UserProvider>(context, listen: false)
              .getCurrentUser();

      await Provider.of<PostsProvider>(context, listen: false).uploadNewPost(
          postContent, downloadUrls, loginUser, getTopicByName(topicName));

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
            child: Text(
              'OK',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultilineTextField(
                      onEdit: onChangeText,
                      hint: 'Post something about what you see...',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GalleryImagePicker(pickedImages, onAddImage),
                    PostTopicSelector(
                      selectedTopic: topicName,
                      onSelectTopic: onSelectTopic,
                    ),
                    if (errorMessage != null)
                      Column(
                        children: [
                          const SizedBox(height: 10,),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Theme.of(context).errorColor, fontSize: 20),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
