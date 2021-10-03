import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/demo_card_info.dart';
import 'package:location_based_social_app/widget/authentication/demo_card.dart';

/// Horizental scoll view for DemoCard
class DemoGallery extends StatelessWidget {

static const List<DemoCardInfo> demoCardsInfo = [
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.amazonaws.com/post_image/71e716f7-7f50-4278-b84a-60124ba63f40.jpg", shortContent: "Autumn in Needham"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.amazonaws.com/post_image/f82f7bfa-1edc-4070-9e4d-24b32018d6cf.jpg", shortContent: "Lighthouse in Provincetown"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.amazonaws.com/post_image/f62517c5-2ab1-48b9-91d8-9892482f6a0c.jpg", shortContent: "Lake near my home"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.us-east-2.amazonaws.com/post_image/cff8ddbe-5278-4b95-a4ef-a5f4f3406b77.jpg", shortContent: "Sea view on CA－1"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.us-east-2.amazonaws.com/post_image/b0c0a403-5fcf-4d0b-9728-9bef8ee32aa3.jpg", shortContent: "Mountain stream"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.us-east-2.amazonaws.com/post_image/28768fe2-0eb1-487e-88e5-1e34215df105.jpg", shortContent: "Sunset in Shenandoah"),
  DemoCardInfo(imageUrl: "https://location-based-social-app-images.s3.us-east-2.amazonaws.com/post_image/bdeb1303-c3b8-4924-bef6-ef9ce5c2e929.jpg", shortContent: "Night view in JC"),
];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: DemoCard(imageUrl: demoCardsInfo[index].imageUrl, content: demoCardsInfo[index].shortContent,),
        );
      }
    );
  }
}