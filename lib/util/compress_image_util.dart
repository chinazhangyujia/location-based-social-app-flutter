import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location_based_social_app/util/config.dart' as config;
import 'package:video_compress/video_compress.dart';

// 1. compress file and get Uint8List
Future<Uint8List> compressImageFileToUint8List(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: config.compressedImageQualityRatio,
    minWidth: config.compressedImageMaxWidth,
    minHeight: config.compressedImageMaxLength,
  );

  return result;
}

// 2. compress file and get file.
Future<File> compressImageFileToFile(File file, String targetPath) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: config.compressedImageQualityRatio,
    minWidth: config.compressedImageMaxWidth,
    minHeight: config.compressedImageMaxLength,
  );

  return result;
}

// 3. compress asset and get Uint8List.
Future<Uint8List> compressImageAssetToUnit8List(String assetName) async {
  final list = await FlutterImageCompress.compressAssetImage(
    assetName,
    quality: config.compressedImageQualityRatio,
    minWidth: config.compressedImageMaxWidth,
    minHeight: config.compressedImageMaxLength,
  );

  return list;
}

// 4. compress Uint8List and get another Uint8List.
Future<Uint8List> compressImageUnit8ListToUnit8List(Uint8List list) async {
  final result = await FlutterImageCompress.compressWithList(
    list,
    quality: config.compressedImageQualityRatio,
    minWidth: config.compressedImageMaxWidth,
    minHeight: config.compressedImageMaxLength,
  );

  return result;
}

Future<Uint8List> compressVideoFile(File file) async {
  final MediaInfo result = await VideoCompress.compressVideo(
    file.absolute.path,
    includeAudio: true
  );

  return result.file.readAsBytesSync();
}