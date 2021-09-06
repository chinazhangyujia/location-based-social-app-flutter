import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post_topics.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
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

  Future<void> _sendPost(BuildContext context, String authToken) async {
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

    final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

    final PostsProvider postsProvider =  Provider.of<PostsProvider>(context, listen: false);

    // asynchronously create post
    CreatePostUtil.createPost(pickedImages, text, authToken, topicName, userProvider, postsProvider);
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
        title: const Text('New Post'),
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
