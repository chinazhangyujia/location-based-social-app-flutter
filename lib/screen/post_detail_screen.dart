import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/dummy_data/dummy_data.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/comment.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/comments_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/comment_item.dart';
import 'package:location_based_social_app/widget/post_item.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {

  static const String router = '/PostDetailScreen';

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextEditingController textController = TextEditingController();

  Post post;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      post = ModalRoute.of(context).settings.arguments as Post;
      Provider.of<CommentsProvider>(context, listen: false).getComments(post.id);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onSendComment(BuildContext context, String postId) async {
    String commentContent = textController.text.trim();
    if (commentContent.isEmpty) {
      textController.clear();
      return;
    }

    try {
      User loginUser = await Provider.of<UserProvider>(context, listen: false).getCurrentUser();

      await Provider.of<CommentsProvider>(context, listen: false).postComment(
          content: commentContent, postId: postId, loginUser: loginUser);
      textController.clear();
    } on HttpException catch(error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, 'Failed to comment. Please try later');
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Comment> comments = Provider.of<CommentsProvider>(context).getCommentsForPost(post.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('detail'),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  child: Column(
                    children: [
                      PostItem(post: post, disableClick: true,),
                      if (comments.isNotEmpty) SizedBox(height: 15,),
                      if (comments.isNotEmpty) Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Comments (${comments.length})',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            SizedBox(height: 10,),
                            ...comments.map((e) => Column(
                              children: [
                                CommentItem(
                                  e
                                ),
                                Divider()
                              ],
                            )).toList()
                          ],
                        ),
                      ),
                      Container(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                ),
                padding: EdgeInsets.only(bottom: 15, top: 13, left: 10, right: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: 100
                  ),
                  child: TextField(
                    onSubmitted: (_) {
                      onSendComment(context, post.id);
                    },
                    controller: textController,
                    style: TextStyle(
                      fontSize: 19
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    decoration: new InputDecoration(
                      filled: true,
                      hintText: "... Add comment",
                      hintStyle: TextStyle(
                        fontSize: 17
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    ),
                  ),
                )
              ),
            ),
          ]
        ),
      ),
    );
  }
}
