import 'package:flutter/material.dart';

class SixPhotosGrid extends StatelessWidget {

  final List<String> photoUrls;

  final Map<int, int> crossAxisCount = {
    1: 1,
    2: 3,
    3: 3,
    4: 2,
    5: 3,
    6: 3
  };

  SixPhotosGrid(this.photoUrls);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(bottom: 0),
      primary: false,
      shrinkWrap: true,
      crossAxisCount: crossAxisCount[photoUrls.length],
      childAspectRatio: photoUrls.length == 1 ? 3 / 2 : 1,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [
        ...photoUrls.map((url) => Container(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        )).toList()
      ],
    );
  }
}
