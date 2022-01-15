import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/media_type.dart';
import 'package:location_based_social_app/widget/post/image_item.dart';
import 'package:location_based_social_app/widget/post/video_item.dart';
import 'package:video_player/video_player.dart';

/// grid to show photos in post
class SixPhotosGrid extends StatelessWidget {
  final List<String> photoUrls;
  final MediaType mediaType;

  final Map<int, int> crossAxisCount = {1: 1, 2: 3, 3: 3, 4: 3, 5: 3, 6: 3};

  SixPhotosGrid(this.photoUrls, this.mediaType);

  @override
  Widget build(BuildContext context) {
    return photoUrls.length == 1
        ? Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7, maxHeight: 300),
            child: mediaType == MediaType.VIDEO ?
              VideoItem(videoPlayerController: VideoPlayerController.network(photoUrls[0])) :
              ImageItem(photoUrls: photoUrls, photoUrl: photoUrls[0], initialIndex: 0),
          )
        : GridView.count(
            padding: const EdgeInsets.only(bottom: 0),
            primary: false,
            shrinkWrap: true,
            crossAxisCount: crossAxisCount[photoUrls.length],
            childAspectRatio: photoUrls.length == 1 ? 3 / 2 : 1,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            children: [
              ...photoUrls
                  .map((url) => ImageItem(photoUrls: photoUrls, photoUrl: url, initialIndex: photoUrls.indexOf(url)))
                  .toList()
            ],
          );
  }
}
