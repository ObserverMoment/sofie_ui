import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_plan_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/workout_plan_media_info.dart';
import 'package:sofie_ui/components/media/audio/audio_uploader.dart';
import 'package:sofie_ui/components/media/images/image_uploader.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/text.dart';

class WorkoutPlanCreatorMedia extends StatelessWidget {
  Size get _thumbSize => const Size(85, 85);

  const WorkoutPlanCreatorMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coverImageUri = context.select<WorkoutPlanCreatorBloc, String?>(
        (b) => b.workoutPlan.coverImageUri);

    final introVideoUri = context.select<WorkoutPlanCreatorBloc, String?>(
        (b) => b.workoutPlan.introVideoUri);
    final introVideoThumbUri = context.select<WorkoutPlanCreatorBloc, String?>(
        (b) => b.workoutPlan.introVideoThumbUri);

    final introAudioUri = context.select<WorkoutPlanCreatorBloc, String?>(
        (b) => b.workoutPlan.introAudioUri);

    final _updateWorkoutPlanMeta =
        context.read<WorkoutPlanCreatorBloc>().updateWorkoutPlanInfo;
    final _setUploadingMedia =
        context.read<WorkoutPlanCreatorBloc>().setUploadingMedia;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                MyText(
                  'Plan Media',
                  weight: FontWeight.bold,
                ),
                InfoPopupButton(infoWidget: WorkoutPlanMediaInfo())
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ImageUploader(
                      displaySize: _thumbSize,
                      imageUri: coverImageUri,
                      onUploadSuccess: (uri) =>
                          _updateWorkoutPlanMeta({'coverImageUri': uri}),
                      removeImage: (_) =>
                          _updateWorkoutPlanMeta({'coverImageUri': null}),
                    ),
                    const SizedBox(height: 6),
                    const MyText(
                      'Cover Image',
                      size: FONTSIZE.one,
                    )
                  ],
                ),
                Column(
                  children: [
                    VideoUploader(
                      displaySize: _thumbSize,
                      videoUri: introVideoUri,
                      videoThumbUri: introVideoThumbUri,
                      onUploadStart: () => _setUploadingMedia(uploading: true),
                      onUploadSuccess: (video, thumb) {
                        _updateWorkoutPlanMeta({
                          'introVideoUri': video,
                          'introVideoThumbUri': thumb
                        });
                        _setUploadingMedia(uploading: false);
                      },
                      onUploadFail: () => _setUploadingMedia(uploading: false),
                      removeVideo: () => _updateWorkoutPlanMeta(
                          {'introVideoUri': null, 'introVideoThumbUri': null}),
                    ),
                    const SizedBox(height: 6),
                    const MyText(
                      'Intro Video',
                      size: FONTSIZE.one,
                    )
                  ],
                ),
                Column(
                  children: [
                    AudioUploader(
                      displaySize: _thumbSize,
                      audioUri: introAudioUri,
                      onUploadStart: () => _setUploadingMedia(uploading: true),
                      onUploadSuccess: (uri) {
                        _updateWorkoutPlanMeta({
                          'introAudioUri': uri,
                        });
                        _setUploadingMedia(uploading: false);
                      },
                      onUploadFail: () => _setUploadingMedia(uploading: false),
                      removeAudio: () => _updateWorkoutPlanMeta({
                        'introAudioUri': null,
                      }),
                    ),
                    const SizedBox(height: 6),
                    const MyText(
                      'Intro Audio',
                      size: FONTSIZE.one,
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
