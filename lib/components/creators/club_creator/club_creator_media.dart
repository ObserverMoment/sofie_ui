import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/media/audio/audio_uploader.dart';
import 'package:sofie_ui/components/media/images/cover_image_uploader.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/text.dart';

class ClubCreatorMedia extends StatelessWidget {
  final String? coverImageUri;
  final void Function(String uri) onImageUploaded;
  final void Function(String uri) removeImage;
  final String? introVideoUri;
  final String? introVideoThumbUri;
  final void Function(String videoUri, String thumbUri) onVideoUploaded;
  final void Function() removeVideo;
  final String? introAudioUri;
  final void Function(String uri) onAudioUploaded;
  final void Function() removeAudio;
  final void Function() onMediaUploadStart;
  final void Function() onMediaUploadFail;

  const ClubCreatorMedia(
      {Key? key,
      required this.coverImageUri,
      required this.onImageUploaded,
      required this.removeImage,
      required this.introVideoUri,
      required this.introVideoThumbUri,
      required this.introAudioUri,
      required this.onVideoUploaded,
      required this.removeVideo,
      required this.onAudioUploaded,
      required this.removeAudio,
      required this.onMediaUploadStart,
      required this.onMediaUploadFail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      children: [
        const SizedBox(height: 6),
        const MyText(
          'Cover Image',
        ),
        const SizedBox(height: 10),
        CoverImageUploader(
          imageUri: coverImageUri,
          onUploadSuccess: onImageUploaded,
          removeImage: removeImage,
          onUploadStart: onMediaUploadStart,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const MyText(
                  'Intro Video',
                ),
                const SizedBox(height: 10),
                VideoUploader(
                  videoUri: introVideoUri,
                  videoThumbUri: introVideoThumbUri,
                  onUploadSuccess: onVideoUploaded,
                  removeVideo: removeVideo,
                  onUploadFail: onMediaUploadFail,
                  onUploadStart: onMediaUploadStart,
                ),
              ],
            ),
            Column(
              children: [
                const MyText(
                  'Intro Audio',
                ),
                const SizedBox(height: 10),
                AudioUploader(
                  audioUri: introAudioUri,
                  onUploadSuccess: onAudioUploaded,
                  removeAudio: removeAudio,
                  onUploadFail: onMediaUploadFail,
                  onUploadStart: onMediaUploadStart,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
