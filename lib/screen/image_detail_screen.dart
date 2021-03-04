import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  static const String router = 'ImageDetailScreen';

  @override
  Widget build(BuildContext context) {
    String imageUrl = ModalRoute.of(context).settings.arguments as String;

    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
