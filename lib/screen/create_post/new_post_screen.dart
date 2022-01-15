import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/media_type.dart';
import 'package:location_based_social_app/model/post_topics.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/util/create_post_util.dart';
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
  List<File> pickedMedias = [];
  MediaType pickerMode = MediaType.IMAGE;
  String topicName;
  String errorMessage;

  bool _isLoading = false;

  void onAddMedia(File media) {
    setState(() {
      pickedMedias.add(media);
    });
  }

  void onDeleteMedia(int index) {
    setState(() {
      pickedMedias.removeAt(index);
    });
  }

  void clearAllMedias() {
    setState(() {
      pickedMedias.clear();
    });
  }

  void onChangePickerMode(MediaType selectedPickerMode) {
    setState(() {
      pickerMode = selectedPickerMode;
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
    return pickedMedias.isEmpty && (text == null || text.trim().isEmpty);
  }

  Future<void> _sendPost(BuildContext context, String authToken) async {
    if (_isPostEmpty()) {
      Navigator.of(context).pop();
      return;
    }

    if (getTopicByName(topicName) == null) {
      setState(() {
        errorMessage = NewPostScreenConstant.TOPIC_MISSING_ERROR_MESSAGE;
      });
      return;
    }

    final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

    final PostsProvider postsProvider =  Provider.of<PostsProvider>(context, listen: false);

    // asynchronously create post
    CreatePostUtil.createPost(pickedMedias, pickerMode, text, authToken, topicName, userProvider, postsProvider);
    Navigator.of(context).pop();
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
        title: const Text(NewPostScreenConstant.TITLE),
        actions: [
          TextButton(
            onPressed: () {
              _sendPost(context, authProvider.token);
            },
            child: Text(
              'OK',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultilineTextField(
                      onEdit: onChangeText,
                      hint: NewPostScreenConstant.POST_TEXT_HINT,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GalleryImagePicker(
                      pickedMedias: pickedMedias, 
                      onAddMedia: onAddMedia, 
                      onDeleteMedia: onDeleteMedia, 
                      clearAllMedias: clearAllMedias, 
                      pickerMode: pickerMode, 
                      onChangePickerMode: onChangePickerMode
                    ),
                    const SizedBox(height: 20,),
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
