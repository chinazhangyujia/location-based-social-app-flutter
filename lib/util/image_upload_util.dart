import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:location_based_social_app/exception/http_exception.dart';

class S3Url {
  final String _uploadUrl;
  final String _downloadUrl;

  S3Url(this._uploadUrl, this._downloadUrl);

  String get uploadUrl {
    return _uploadUrl;
  }

  String get downloadUrl {
    return _downloadUrl;
  }
}

class ImageUploadUtil {

  static const Map<String, String> requestHeader = {
    'Content-type': 'application/json',
  };

  static Future<S3Url> getS3Urls(String token) async {
    String url = 'http://localhost:3000/generatePresignedUrl';

    try {
      final res = await http.post(
        url,
        headers: {...requestHeader, 'Authorization': 'Bearer $token'},
        body: json.encode({
          'fileType': '.jpg'
        })
      );

      final responseData = json.decode(res.body);

      if (!responseData['success']) {
        throw HttpException(responseData['message']);
      }

      return S3Url(responseData['uploadUrl'], responseData['downloadUrl']);

    } catch (error) {
      throw error;
    }
  }

  static Future<void> uploadToS3(String url, File image) async {
    try {
      Uint8List bytes = await image.readAsBytes();
      var response = await http.put(url, body: bytes);

      if (response.statusCode != 200) {
        throw HttpException('Failed to upload image');
      }
    } catch (error) {
      throw error;
    }
  }

}