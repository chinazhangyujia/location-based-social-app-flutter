import 'package:flutter/material.dart';

class SixPhotosGrid extends StatelessWidget {

  final List<String> photoUrls;

  SixPhotosGrid(this.photoUrls);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        children: [
          ...photoUrls.map((url) => Container(
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          )).toList()
        ],
      ),
    );
  }
}
