import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/screen/post_list/image_detail_screen.dart';

class ImageItem extends StatelessWidget {

  final List<String> photoUrls;
  final String photoUrl;
  final int initialIndex;

  const ImageItem({@required this.photoUrls, @required this.photoUrl, @required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ImageDetailScreen.router,
                    arguments: {'photoUrls': photoUrls, 'initialPageIndex': initialIndex});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  placeholder: (context, url) => Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                ),
              ),
            );
  }
}