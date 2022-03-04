import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/file_uploading_progress.dart';
import 'package:sofie_ui/components/media/video/local_video_selector.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/user_input/pickers/duration_picker.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class UserMaxUnbrokenManualEntryCreator extends StatefulWidget {
  final UserMaxUnbrokenExerciseTracker parent;
  const UserMaxUnbrokenManualEntryCreator({
    Key? key,
    required this.parent,
  }) : super(key: key);
  @override
  _UserMaxUnbrokenManualEntryCreatorState createState() =>
      _UserMaxUnbrokenManualEntryCreatorState();
}

class _UserMaxUnbrokenManualEntryCreatorState
    extends State<UserMaxUnbrokenManualEntryCreator> {
  bool _loading = false;
  bool _uploadingVideo = false;
  bool _processingVideo = false;
  double _uploadProgress = 0.0;
  String? _uploadedVideoUri;
  String? _uploadedVideoThumbUri;
  final CancelToken _mediaUploadCancelToken = CancelToken();

  int? _score;
  DateTime _completedOn = DateTime.now();
  String? _localVideoPath;

  final TextEditingController _repsCalsScoreController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _repsCalsScoreController.addListener(() {
      setState(() {
        _score = Utils.textNotNull(_repsCalsScoreController.text)
            ? int.parse(_repsCalsScoreController.text)
            : null;
      });
    });
  }

  Future<void> _createManualEntry() async {
    if (_score == null) {
      return;
    }

    /// Check for video upload.
    if (_localVideoPath != null) {
      await _uploadVideo();
    }

    setState(() => _loading = true);

    final variables = CreateUserMaxUnbrokenTrackerManualEntryArguments(
        data: CreateUserMaxUnbrokenTrackerManualEntryInput(
            completedOn: _completedOn,
            videoUri: _uploadedVideoUri,
            videoThumbUri: _uploadedVideoThumbUri,
            userMaxUnbrokenExerciseTracker:
                ConnectRelationInput(id: widget.parent.id),
            score: _score!));

    final result = await context.graphQLStore.mutate(
        mutation: CreateUserMaxUnbrokenTrackerManualEntryMutation(
            variables: variables),
        broadcastQueryIds: [GQLOpNames.userMaxUnbrokenExerciseTrackers]);

    setState(() => _loading = false);

    checkOperationResult(context, result, onSuccess: context.pop);
  }

  /// TODO: Can extract - is the same across all manual entry tracker creators.
  Future<void> _uploadVideo() async {
    if (_localVideoPath == null) {
      return;
    }

    setState(() => _uploadingVideo = true);

    try {
      await GetIt.I<UploadcareService>().uploadVideo(
          file: SharedFile(File(_localVideoPath!)),
          onProgress: (progress) =>
              setState(() => _uploadProgress = progress.value),
          onUploaded: () {
            setState(() {
              _uploadingVideo = false;
              _processingVideo = true;
            });
          },
          onComplete: (videoUri, videoThumbUri) {
            /// Replace this with the returned URI from uploadcare.
            _uploadedVideoUri = videoUri;
            _uploadedVideoThumbUri = videoThumbUri;
          },
          onFail: (e) {
            throw Exception(e);
          });
    } catch (e) {
      printLog(e.toString());
      await context.showErrorAlert(e.toString());
    }
  }

  bool get _validToSubmit => _score != null;

  Widget _buildScoreInput() {
    switch (widget.parent.repType) {
      case WorkoutMoveRepType.reps:
      case WorkoutMoveRepType.calories:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyNumberInput(
              _repsCalsScoreController,
              allowDouble: true,
              autoFocus: true,
            ),
            const SizedBox(height: 8),
            MyText(
              widget.parent.repType.display.toUpperCase(),
              size: FONTSIZE.four,
            ),
          ],
        );
      case WorkoutMoveRepType.time:
        return DurationPickerDisplay(
          updateDuration: (d) => setState(() => _score = d.inMilliseconds),
          duration: _score != null ? Duration(milliseconds: _score!) : null,
          iconSize: 28,
          fontSize: FONTSIZE.eight,
        );
      case WorkoutMoveRepType.distance:
        return Column(children: [
          MyNumberInput(
            _repsCalsScoreController,
            allowDouble: true,
            autoFocus: true,
          ),
          const SizedBox(height: 8),
          MyText(
            widget.parent.distanceUnit.display.toUpperCase(),
            size: FONTSIZE.four,
          ),
        ]);

      default:
        throw Exception(
            'UserMaxUnbrokenManualEntryCreator._buildScoreInput: No builder specified for ${widget.parent.repType}');
    }
  }

  @override
  void dispose() {
    _repsCalsScoreController.dispose();

    /// If user bails out then cancel the upload.
    if (!_mediaUploadCancelToken.isCanceled) {
      _mediaUploadCancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorWidth = MediaQuery.of(context).size.width * 0.4;

    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: _uploadingVideo || _processingVideo,
        middle: const NavBarTitle('Submit Unbroken Time'),
        trailing: _loading || _uploadingVideo || _processingVideo
            ? const NavBarLoadingIndicator()
            : _validToSubmit
                ? FadeIn(child: NavBarTertiarySaveButton(_createManualEntry))
                : null,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          GrowInOut(
              show: _uploadingVideo || _processingVideo,
              child: UserInputContainer(
                  child: UploadcareFileUploadingProgress(
                cancelToken: _mediaUploadCancelToken,
                isProcessing: _processingVideo,
                isUploading: _uploadingVideo,
                progress: _uploadProgress,
                width: indicatorWidth,
              ))),
          UserInputContainer(
            child: DateTimePickerDisplay(
              dateTime: _completedOn,
              saveDateTime: (d) => setState(() => _completedOn = d),
            ),
          ),
          UserInputContainer(
              child: Column(
            children: [
              const MyText(
                'Unbroken for',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _buildScoreInput(),
              ),
            ],
          )),
          UserInputContainer(
              child: LocalVideoSelector(
                  title: 'Upload a Video (Optional)',
                  pickedFilePath: _localVideoPath,
                  savePickedFilePath: (p) =>
                      setState(() => _localVideoPath = p)))
        ],
      ),
    );
  }
}
