import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:location_based_social_app/util/constant.dart';

/// When clicking an image, we show the clicked image in full screen
class ImageDetailScreen extends StatefulWidget {
  static const String router = 'ImageDetailScreen';

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool _isInit = true;
  int _currentImageIndex;
  List<String> _imageUrls;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final Map<String, dynamic> parameters =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _imageUrls = parameters['photoUrls'] as List<String>;
      _currentImageIndex = parameters['initialPageIndex'] as int;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveNetworkImage(String imageUrl) async {
    bool isSuccess = await GallerySaver.saveImage(imageUrl);
    if (isSuccess) {
      _showSnackbar(context);
    }
  }

  void _showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        height: 30,
        child: const Text(
          ImageDetailScreenConstant.IMAGE_DOWNLOADED,
          style: TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 2),
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showBottomModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: double.infinity,
        height: 150,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _saveNetworkImage(_imageUrls[_currentImageIndex]);
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                child: const Text(ImageDetailScreenConstant.DOWNLOAD_IMAGE,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 8.0,
              color: Colors.white
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Text(ImageDetailScreenConstant.CANCEL,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onLongPress: () {
        _showBottomModel(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) => Center(
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: _currentImageIndex,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: _imageUrls.map((url) {
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
      ),
    );
  }
}
