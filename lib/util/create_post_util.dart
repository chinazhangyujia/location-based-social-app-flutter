import 'dart:io';

import 'package:location_based_social_app/model/post_topics.dart';
import 'package:location_based_social_app/model/user.dart';
import 'package:location_based_social_app/provider/posts_provider.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/image_upload_util.dart';

class CreatePostUtil {
  /**
   * asynchronous task to create new post
   */
  static Future<void> createPost(List<File> pickedImages, 
                                 String text, 
                                 String authToken, 
                                 String topicName, 
                                 UserProvider userProvider,
                                 PostsProvider postsProvider) async {
    try {
        final List<String> downloadUrls = [];

        if (pickedImages.isNotEmpty) {
        
          for (final File file in pickedImages) {
            final S3Url s3url =
                await ImageUploadUtil.getS3Urls(authToken, S3Folder.POST_IMAGE);
            await ImageUploadUtil.uploadToS3(s3url.uploadUrl, file);
            downloadUrls.add(s3url.downloadUrl);
          }
        }

        final String postContent =
            (text == null || text.trim().isEmpty) ? null : text.trim();
        final User loginUser =
            await userProvider.getCurrentUser();

        await postsProvider.uploadNewPost(
            postContent, downloadUrls, loginUser, getTopicByName(topicName));
    }
    on HttpException {

    }
  }
}

