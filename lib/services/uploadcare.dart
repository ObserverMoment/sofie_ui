import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sofie_ui/env_config.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class VideoInfoEntity {
  final String uuid;
  final String url;
  final int duration;
  final int size;
  final int width;
  final int height;

  VideoInfoEntity(
      {required this.uuid,
      required this.url,
      required this.duration,
      required this.size,
      required this.width,
      required this.height});

  bool isPortrait() {
    if (width == 0 || height == 0) {
      throw Exception('The video either has no height or no width..');
    } else {
      return width < height;
    }
  }

  factory VideoInfoEntity.fromJson(Map<String, dynamic> json) {
    return VideoInfoEntity(
        uuid: json['uuid'] as String,
        url: json['original_file_url'] as String,
        size: json['size'] as int,
        duration: json['video_info']['duration'] as int,
        width: json['video_info']['video']['width'] as int,
        height: json['video_info']['video']['height'] as int);
  }
}

class ProcessedVideoResult {
  final String videoUri;
  // // Full cdn url of the thumbnail derived from thumbnail group id.
  // https://ucarecdn.com/30a340f1-ed48-46dc-a733-a1c9bc9a5c5d~1/nth/0/
  final String videoThumbUri;
  ProcessedVideoResult(this.videoUri, this.videoThumbUri);
}

class UploadcareService {
  final UploadcareClient client = UploadcareClient.withRegularAuth(
    publicKey: EnvironmentConfig.uploadCarePublicKey,
    privateKey: EnvironmentConfig.uploadCarePrivateKey,
    apiVersion: 'v0.6',
  );

  final _uploadApi = ApiUpload(
      options: ClientOptions(
          authorizationScheme: AuthSchemeRegular(
    publicKey: EnvironmentConfig.uploadCarePublicKey,
    privateKey: EnvironmentConfig.uploadCarePrivateKey,
    apiVersion: 'v0.6',
  )));

  static String? getFileUrl(String fileId) {
    try {
      final CdnFile cdnFile = CdnFile(fileId);
      return cdnFile.url;
    } catch (e) {
      printLog(e.toString());
      return null;
    }
  }

  Future<FileInfoEntity> getFileInfo(String fileId) async {
    final FileInfoEntity fileInfoEntity = await client.files.file(fileId);
    return fileInfoEntity;
  }

  // Just uses the simple, unsigned auth scheme.
  // Implemented because the uploadcare client package always returns a FileInfoEntity when getting info.
  // FileInfoEntity has no fields for video specific data.
  static Future<VideoInfoEntity> getVideoInfoRaw(String fileId) async {
    final dynamic res = await http.get(
      Uri.https('api.uploadcare.com', '/files/$fileId/'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.acceptHeader: 'application/vnd.uploadcare-v0.6+json',
        HttpHeaders.authorizationHeader:
            "Uploadcare.Simple ${EnvironmentConfig.uploadCarePublicKey}:${EnvironmentConfig.uploadCarePrivateKey}",
      },
    );
    final responseJson = await json.decode(res.body as String);
    return VideoInfoEntity.fromJson(responseJson as Map<String, dynamic>);
  }

  Future<void> uploadFile(
      {required SharedFile file,
      void Function(ProgressEntity progress)? onProgress,
      required void Function(String uploadedUri) onComplete,
      CancelToken? cancelToken,
      void Function()? onCancel,
      required void Function(Exception) onFail}) async {
    try {
      final String fileId = await _uploadApi.base(file,
          onProgress: onProgress, cancelToken: cancelToken);

      // Check when the file is ready for use before continuing.
      await Utils.waitWhile(() => checkFileIsReady(fileId),
          pollIntervalMs: 1000, backoffMs: 500, maxAttempts: 20);

      onComplete(fileId);
    } on CancelUploadException catch (e) {
      printLog('User cancelled upload');
      printLog(e.toString());
      if (onCancel != null) {
        onCancel();
      }
    } catch (e) {
      printLog(e.toString());
      onFail(Exception(e));
    }
  }

  Future<void> uploadVideo(
      {required SharedFile file,
      void Function(ProgressEntity)? onProgress,

      /// onUploaded runs once the original file is uploaded and before thumb and processed video is generated
      void Function()? onUploaded,
      required void Function(String videoUri, String videoThumburi) onComplete,
      CancelToken? cancelToken,
      required void Function(Exception) onFail}) async {
    try {
      // storeMode is false so that the original unprocessed video is deleted after 24 hours.
      final String originalFileId = await _uploadApi.auto(file,
          runInIsolate: true,
          onProgress: onProgress,
          cancelToken: cancelToken,
          storeMode: false);

      if (onUploaded != null) onUploaded();

      // Create a thumbnail - hack so that uploadcare fills video info correctly (Aspect ratio etc)
      // Also means you can use the thumbnail...and you get a properly encoded video.
      final ProcessedVideoResult processedUris =
          await encodeVideoAndGenerateThumb(originalFileId);

      // Check when the video is ready for use before continuing.
      await Utils.waitWhile(() => checkFileIsReady(processedUris.videoUri),
          pollIntervalMs: 2000, backoffMs: 1000, maxAttempts: 10);

      onComplete(processedUris.videoUri, processedUris.videoThumbUri);
    } on CancelUploadException catch (e) {
      printLog('User cancelled upload');
      printLog(e.toString());
    } catch (e) {
      printLog(e.toString());
      onFail(Exception(e));
    }
  }

  // Check file is ready for further processing aftre being uploading.
  Future<bool> checkFileIsReady(String cdnFileId) async {
    return (await client.files.file(cdnFileId)).isReady;
  }

  Future<ProcessedVideoResult> encodeVideoAndGenerateThumb(String uri) async {
    final VideoEncodingConvertEntity convertedFile =
        await client.videoEncoding.process({
      uri: [VideoThumbsGenerateTransformation()],
    });

    if (convertedFile.problems.isNotEmpty) {
      throw Exception(
          'There was a problem uploading your video, ${convertedFile.problems.toString()}');
    } else {
      final GroupInfoEntity _thumbsGroup =
          await client.groups.group(convertedFile.results[0].thumbnailsGroupId);

      return ProcessedVideoResult(
          convertedFile.results[0].processedFileId, _thumbsGroup.files[0].id);
    }
  }

  Future<void> deleteFiles(
      {required List<String> fileIds,
      Function()? onComplete,
      Function(dynamic)? onFail}) async {
    try {
      await client.files.remove(fileIds);
      if (onComplete != null) onComplete();
    } catch (e) {
      printLog(e.toString());
      if (onFail != null) onFail(e);
    }
  }
}
