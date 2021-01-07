import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/chat_thread_summary.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/chat_provider.dart';
import 'package:location_based_social_app/screen/chat_screen.dart';
import 'package:location_based_social_app/widget/chat_thread_summary_item.dart';
import 'package:provider/provider.dart';

class ChatThreadsScreen extends StatefulWidget {

  static const String router = '/ChatThreadsScreen';

  @override
  _ChatThreadsScreenState createState() => _ChatThreadsScreenState();
}

class _ChatThreadsScreenState extends State<ChatThreadsScreen> {

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getAllThreadSummaries();
    super.initState();
  }

  Future<void> goToChatScreen(BuildContext context, User chatWith) async {
    try {
      await Provider.of<ChatProvider>(context, listen: false).connectToThread(
          chatWith);
      Navigator.of(context).pushNamed(ChatScreen.router, arguments: chatWith);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChatThreadSummary> chatThreadSummaries = Provider.of<ChatProvider>(context).chatThreadSummaries;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: chatThreadSummaries.length,
          itemBuilder: (context, index) => Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  goToChatScreen(context, chatThreadSummaries[index].chatWith);
                },
                child: ChatThreadSummaryItem(chatThreadSummaries[index])
              ),
              Divider()
            ],
          )
        ),
      ),
    );
  }
}
