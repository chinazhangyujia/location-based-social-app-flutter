import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/widget/friend_request_card.dart';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatelessWidget {

  static const String router = 'FriendRequestScreen';

  @override
  Widget build(BuildContext context) {
    List<FriendRequest> requests = Provider.of<FriendRequestProvider>(context).pendingRequests;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('New Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            User sendFrom = requests[index].sendFrom;
            String requestId = requests[index].id;

            return FriendRequestCard(sendFrom, requestId);
          }
        ),
      ),
    );
  }
}
