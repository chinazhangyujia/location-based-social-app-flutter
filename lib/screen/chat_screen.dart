import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/chat_message.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/chat_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/widget/chat_message_item.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String router = '/ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  ScrollController _scrollController;
  TextEditingController _textController;
  FocusNode textFieldFocusNode;

  bool _isInit = true;
  bool _loading = false;
  User _chatWith;
  ChatProvider _chatProvider;

  @override
  void initState() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    textFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _chatProvider = Provider.of<ChatProvider>(context, listen: false);
      _chatWith = ModalRoute.of(context).settings.arguments as User;
      await _chatProvider.getMessagesForThread(chatWith: _chatWith, refresh: true);
      _isInit = false;

      _scrollController.addListener(() {
        if (!_loading && _scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          setState(() {
            _loading = true;
          });

          _chatProvider.getMessagesForThread(chatWith: _chatWith)
              .then((_) {
            setState(() {
              _loading = false;
            });
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _chatProvider.closeSockets();
    _textController.dispose();
    _scrollController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> sendMessage(BuildContext context) async {
    User loginUser = Provider.of<UserProvider>(context, listen: false).loginUser;
    if (loginUser == null) {
      loginUser = await Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    }

    _chatProvider.sendMessage(loginUser, _chatWith, _textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {

    final List<ChatMessage> chatMessages = Provider.of<ChatProvider>(context).messagesForOpeningThread;

    return Scaffold(
      appBar: AppBar(
        title: Text(_chatWith.name),
        elevation: 0.5,
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(10.0),
                itemCount: chatMessages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(
                      height: 70,
                    );
                  }
                  else {
                    return ChatMessageItem(
                    alignment: chatMessages[index - 1].sendTo.id == _chatWith.id
                    ? ChatMessageAlignment.end
                        : ChatMessageAlignment.start,
                    message: chatMessages[index - 1].content,
                    sendAt: chatMessages[index - 1].sendTime,
                    );
                  }
                },
                reverse: true,
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
                          sendMessage(context);
                        },
                        controller: _textController,
                        style: TextStyle(
                            fontSize: 16
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        decoration: new InputDecoration(
                          hintText: "Type a message...",
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
            )
          ],
        ),
      ),
    );
  }
}
