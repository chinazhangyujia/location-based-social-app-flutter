import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/friend_request.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/friend_request_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/widget/friend/friend_request_card.dart';
import 'package:provider/provider.dart';

/// screen to show all friend requests from other users
/// user can choose to accept or reject friend request
class FriendRequestScreen extends StatelessWidget {

  static const String router = 'FriendRequestScreen';

  @override
  Widget build(BuildContext context) {
    final List<FriendRequest> requests = Provider.of<FriendRequestProvider>(context).pendingRequests;

    final FriendRequestProvider friendRequestProvider = Provider.of<FriendRequestProvider>(context, listen: false);
    final List<String> unnotifiedFriendRequestIds = friendRequestProvider.unnotifiedRequests.map((e) => e.id).toList();
    if (unnotifiedFriendRequestIds.isNotEmpty) {
      friendRequestProvider.markRequestsAsNotified(unnotifiedFriendRequestIds);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(FriendRequestScreenConstant.TITLE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final User sendFrom = requests[index].sendFrom;
            final String requestId = requests[index].id;

            return FriendRequestCard(sendFrom, requestId);
          }
        ),
      ),
    );
  }
}
