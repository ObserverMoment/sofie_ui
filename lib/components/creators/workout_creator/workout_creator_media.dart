import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/workout_media_info.dart';
import 'package:sofie_ui/components/info_pages/workout_section_media_info.dart';
import 'package:sofie_ui/components/media/audio/audio_uploader.dart';
import 'package:sofie_ui/components/media/images/image_uploader.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

class WorkoutCreatorMedia extends StatefulWidget {
  const WorkoutCreatorMedia({Key? key}) : super(key: key);

  @override
  State<WorkoutCreatorMedia> createState() => _WorkoutCreatorMediaState();
}

class _WorkoutCreatorMediaState extends State<WorkoutCreatorMedia> {
  late List<WorkoutSection> _workoutSections;
  late Workout _workout;
  late WorkoutCreatorBloc _bloc;

  final _thumbSize = const Size(75, 75);

  void _checkForNewData() {
    if (_workout != _bloc.workout) {
      setState(() {
        _workout = Workout.fromJson(_bloc.workout.toJson());
      });
    }

    if (!listEquals(_workoutSections, _bloc.workout.workoutSections)) {
      setState(() {
        _workoutSections = [..._bloc.workout.workoutSections];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WorkoutCreatorBloc>();
    _workout = Workout.fromJson(_bloc.workout.toJson());
    _workoutSections = [..._bloc.workout.workoutSections];
    _bloc.addListener(_checkForNewData);
  }

  void _updateWorkoutData(Map<String, dynamic> data) =>
      context.read<WorkoutCreatorBloc>().updateWorkoutInfo(data);

  void _updateWorkoutSection(int sectionindex, Map<String, dynamic> data) {
    context.read<WorkoutCreatorBloc>().updateWorkoutSection(sectionindex, data);
  }

  @override
  void dispose() {
    _bloc.removeListener(_checkForNewData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  MyText(
                    'Workout',
                  ),
                  InfoPopupButton(infoWidget: WorkoutMediaInfo())
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
                        imageUri: _workout.coverImageUri,
                        onUploadSuccess: (uri) =>
                            _updateWorkoutData({'coverImageUri': uri}),
                        removeImage: (_) =>
                            _updateWorkoutData({'coverImageUri': null}),
                      ),
                      const _LabelText(
                        label: 'Cover Image',
                      )
                    ],
                  ),
                  Column(
                    children: [
                      VideoUploader(
                        displaySize: _thumbSize,
                        videoUri: _workout.introVideoUri,
                        videoThumbUri: _workout.introVideoThumbUri,
                        onUploadStart: () =>
                            _bloc.setUploadingMedia(uploading: true),
                        onUploadSuccess: (video, thumb) {
                          _updateWorkoutData({
                            'introVideoUri': video,
                            'introVideoThumbUri': thumb
                          });
                          _bloc.setUploadingMedia(uploading: false);
                        },
                        onUploadFail: () =>
                            _bloc.setUploadingMedia(uploading: false),
                        removeVideo: () => _updateWorkoutData({
                          'introVideoUri': null,
                          'introVideoThumbUri': null
                        }),
                      ),
                      const _LabelText(
                        label: 'Intro Video',
                      )
                    ],
                  ),
                  Column(
                    children: [
                      AudioUploader(
                        displaySize: _thumbSize,
                        audioUri: _workout.introAudioUri,
                        onUploadStart: () =>
                            _bloc.setUploadingMedia(uploading: true),
                        onUploadSuccess: (uri) {
                          _updateWorkoutData({
                            'introAudioUri': uri,
                          });
                          _bloc.setUploadingMedia(uploading: false);
                        },
                        onUploadFail: () =>
                            _bloc.setUploadingMedia(uploading: false),
                        removeAudio: () => _updateWorkoutData({
                          'introAudioUri': null,
                        }),
                      ),
                      const _LabelText(
                        label: 'Intro Audio',
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        ..._workoutSections
            .map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyText(
                              Utils.textNotNull(section.name)
                                  ? section.name!
                                  : 'Section ${section.sortPosition + 1}',
                            ),
                            MyText(' (${section.workoutSectionType.name})'),
                          ],
                        ),
                        const InfoPopupButton(
                            infoWidget: WorkoutSectionMediaInfo())
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            VideoUploader(
                              displaySize: _thumbSize,
                              videoUri: section.introVideoUri,
                              videoThumbUri: section.introVideoThumbUri,
                              onUploadStart: () =>
                                  _bloc.setUploadingMedia(uploading: true),
                              onUploadSuccess: (video, thumb) {
                                _updateWorkoutSection(section.sortPosition, {
                                  'introVideoUri': video,
                                  'introVideoThumbUri': thumb
                                });
                                _bloc.setUploadingMedia(uploading: false);
                              },
                              removeVideo: () => _updateWorkoutSection(
                                  section.sortPosition, {
                                'introVideoUri': null,
                                'introVideoThumbUri': null
                              }),
                            ),
                            const _LabelText(
                              label: 'Intro Video',
                            )
                          ],
                        ),
                        Column(
                          children: [
                            VideoUploader(
                              displaySize: _thumbSize,
                              videoUri: section.classVideoUri,
                              videoThumbUri: section.classVideoThumbUri,
                              onUploadStart: () =>
                                  _bloc.setUploadingMedia(uploading: true),
                              onUploadSuccess: (video, thumb) {
                                _updateWorkoutSection(section.sortPosition, {
                                  'classVideoUri': video,
                                  'classVideoThumbUri': thumb
                                });
                                _bloc.setUploadingMedia(uploading: false);
                              },
                              removeVideo: () => _updateWorkoutSection(
                                  section.sortPosition, {
                                'classVideoUri': null,
                                'classVideoThumbUri': null
                              }),
                            ),
                            const _LabelText(
                              label: 'Class Video',
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            AudioUploader(
                              displaySize: _thumbSize,
                              audioUri: section.introAudioUri,
                              onUploadStart: () =>
                                  _bloc.setUploadingMedia(uploading: true),
                              onUploadSuccess: (uri) {
                                _updateWorkoutSection(section.sortPosition, {
                                  'introAudioUri': uri,
                                });
                                _bloc.setUploadingMedia(uploading: false);
                              },
                              removeAudio: () =>
                                  _updateWorkoutSection(section.sortPosition, {
                                'introAudioUri': null,
                              }),
                            ),
                            const _LabelText(
                              label: 'Intro Audio',
                            )
                          ],
                        ),
                        Column(
                          children: [
                            AudioUploader(
                              displaySize: _thumbSize,
                              audioUri: section.classAudioUri,
                              onUploadStart: () =>
                                  _bloc.setUploadingMedia(uploading: true),
                              onUploadSuccess: (uri) {
                                _updateWorkoutSection(section.sortPosition, {
                                  'classAudioUri': uri,
                                });
                                _bloc.setUploadingMedia(uploading: false);
                              },
                              removeAudio: () =>
                                  _updateWorkoutSection(section.sortPosition, {
                                'classAudioUri': null,
                              }),
                            ),
                            const _LabelText(
                              label: 'Class Audio',
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList()
      ],
    );
  }
}

class _LabelText extends StatelessWidget {
  final String label;
  const _LabelText({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyText(
      label,
      size: FONTSIZE.one,
      lineHeight: 1.5,
    );
  }
}
