import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/model/comment.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/comments_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/post_detail/comment_item.dart';
import 'package:location_based_social_app/widget/post/post_item.dart';
import 'package:provider/provider.dart';

/// when clicking any post in post list page user will be direct to this page
/// in this page user can write comment
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
      Provider.of<CommentsProvider>(context, listen: false)
          .getComments(post.id);
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
    final String commentContent = textController.text.trim();
    if (commentContent.isEmpty) {
      textController.clear();
      return;
    }

    try {
      final User loginUser =
          await Provider.of<UserProvider>(context, listen: false)
              .getCurrentUser();

      if (_atUser != null) {
        await Provider.of<CommentsProvider>(context, listen: false).postComment(
            content: commentContent,
            postId: postId,
            loginUser: loginUser,
            sendTo: _atUser);
      } else {
        await Provider.of<CommentsProvider>(context, listen: false).postComment(
            content: commentContent, postId: postId, loginUser: loginUser);
      }

      textController.clear();
      setState(() {
        _atUser = null;
      });
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, PostDetailScreenConstant.FAILED_TO_COMMENT_ERROR_MESSAGE);
    }
  }

  void onClickComment(User atUser) async {
    if (atUser == null) {
      return; // shouldn't happen
    }

    User loginUser =
        Provider.of<UserProvider>(context, listen: false).loginUser;
    if (loginUser == null) {
      try {
        loginUser = await Provider.of<UserProvider>(context, listen: false)
            .getCurrentUser();
      } on HttpException catch (error) {
        renderErrorDialog(context, error.message);
      } catch (error) {
        renderErrorDialog(context, PostDetailScreenConstant.FAILED_TO_GET_CURRENT_USER_ERROR_MESSAGE);
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

  void _onClickMetaDataBarComment() {
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
    final List<Comment> comments =
        Provider.of<CommentsProvider>(context).getCommentsForPost(post.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(PostDetailScreenConstant.TITLE),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(children: [
          GestureDetector(
            onTap: () {
              onUnfocusTextField(context);
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                child: Column(
                  children: [
                    PostItem(
                      post: post,
                      disableClick: true,
                      onClickMetaDataBarComment: _onClickMetaDataBarComment,
                    ),
                    if (comments.isNotEmpty)
                      const SizedBox(
                        height: 15,
                      ),
                    if (comments.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(PostDetailScreenConstant.GET_COMMENTS_COUNT(comments.length),
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            ...comments
                                .map((e) => Column(
                                      children: [
                                        CommentItem(
                                          comment: e,
                                          onClickComment: onClickComment,
                                        ),
                                        const Divider()
                                      ],
                                    ))
                                .toList()
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
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
                padding: const EdgeInsets.only(
                    bottom: 15, top: 13, left: 10, right: 10),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 40, maxHeight: 100),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(244, 244, 244, 1)),
                    child: TextField(
                      focusNode: textFieldFocusNode,
                      cursorColor: Theme.of(context).accentColor,
                      onSubmitted: (_) {
                        onSendComment(context, post.id);
                      },
                      controller: textController,
                      style: const TextStyle(fontSize: 16),
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        prefix: _atUser != null
                            ? Text(
                                '@${_atUser.name} ',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              )
                            : null,
                        hintText: _atUser != null ? null : PostDetailScreenConstant.ADD_COMMENT_HINT,
                        hintStyle: const TextStyle(
                          fontSize: 16
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                    ),
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
