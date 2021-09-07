import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// When clicking an image, we show the clicked image in full screen
class ImageDetailScreen extends StatelessWidget {
  static const String router = 'ImageDetailScreen';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> parameters =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final List<String> imageUrls = parameters['photoUrls'] as List<String>;
    final int initialPageIndex = parameters['initialPageIndex'] as int;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CarouselSlider(
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: initialPageIndex),
            items: imageUrls.map((url) {
              return CachedNetworkImage(
                imageUrl: url,
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
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
