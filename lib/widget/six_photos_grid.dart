import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location_based_social_app/screen/image_detail_screen.dart';

class SixPhotosGrid extends StatelessWidget {
  final List<String> photoUrls;

  final Map<int, int> crossAxisCount = {1: 1, 2: 3, 3: 3, 4: 3, 5: 3, 6: 3};

  SixPhotosGrid(this.photoUrls);

  @override
  Widget build(BuildContext context) {
    return photoUrls.length == 1
        ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CachedNetworkImage(
                  imageUrl: photoUrls[0],
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
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ImageDetailScreen.router,
                    arguments: photoUrls[0]);
              },
            ),
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
                  .map((url) => GestureDetector(
                        child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ImageDetailScreen.router,
                              arguments: url);
                        },
                      ))
                  .toList()
            ],
          );
  }
}
