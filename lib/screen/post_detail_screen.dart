import 'dart:io';

import 'package:flutter/material.dart';
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
  FocusNode textFieldFocusNode;

  User _atUser;
  Post post;
  bool _isInit = true;

  @override
  void initState() {
    textFieldFocusNode = FocusNode();
    super.initState();
  }

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
    textFieldFocusNode.dispose();
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

      if (_atUser != null) {
        await Provider.of<CommentsProvider>(context, listen: false).postComment(
            content: commentContent, postId: postId, loginUser: loginUser, sendTo: _atUser);
      }
      else {
        await Provider.of<CommentsProvider>(context, listen: false).postComment(
            content: commentContent, postId: postId, loginUser: loginUser);
      }

      textController.clear();
      setState(() {
        _atUser = null;
      });
    } on HttpException catch(error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, 'Failed to comment. Please try later');
    }
  }

  void onClickComment(User atUser) async {
    if (atUser == null) {
      return; // shouldn't happen
    }

    User loginUser = Provider.of<UserProvider>(context, listen: false).loginUser;
    if (loginUser == null) {
      try {
        loginUser = await Provider.of<UserProvider>(context, listen: false)
            .getCurrentUser();
      } on HttpException catch(error) {
        renderErrorDialog(context, error.message);
      } catch (error) {
        renderErrorDialog(context, 'Something wrong happened. Please try later');
      }
    }

    if (loginUser == null || atUser.id == loginUser.id) {
      return;
    }

    setState(() {
      _atUser = atUser;
    });
    textFieldFocusNode.requestFocus();
  }

  void onUnfocusTextField(BuildContext context) {
    FocusScope.of(context).unfocus();
    setState(() {
      _atUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Comment> comments = Provider.of<CommentsProvider>(context).getCommentsForPost(post.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('detail'),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                onUnfocusTextField(context);
              },
              behavior: HitTestBehavior.opaque,
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
                                  comment: e,
                                  onClickComment: onClickComment,
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
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                ),
                padding: EdgeInsets.only(bottom: 15, top: 13, left: 10, right: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 40,
                    maxHeight: 100
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(244, 244, 244, 1)
                    ),
                    child: TextField(
                      focusNode: textFieldFocusNode,
                      cursorColor: Theme.of(context).accentColor,
                      onSubmitted: (_) {
                        onSendComment(context, post.id);
                      },
                      controller: textController,
                      style: TextStyle(
                        fontSize: 16
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      decoration: new InputDecoration(
                        prefix: _atUser != null ? Text('@${_atUser.name} ', style: TextStyle(color: Theme.of(context).accentColor),) : null,
                        // filled: true,
                        hintText: _atUser != null ? null : "... Add comment",
                        hintStyle: TextStyle(
                          fontSize: 16
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),
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
