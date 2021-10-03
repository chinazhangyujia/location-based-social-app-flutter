import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DemoCard extends StatelessWidget {
  final String imageUrl;
  final String content;

  const DemoCard({
    @required this.imageUrl,
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
          child: Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Container(
                  width: 180,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10)
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.fill,
                      alignment: Alignment.topRight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5), 
                  child: Text(content, style: const TextStyle(color: Colors.white, fontSize: 12),),
                )
              ],
            ),
          ),
        );
  }
}