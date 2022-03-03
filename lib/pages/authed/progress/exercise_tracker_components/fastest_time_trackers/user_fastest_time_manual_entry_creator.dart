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
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class UserFastestTimeManualEntryCreator extends StatefulWidget {
  final UserFastestTimeExerciseTracker parent;
  const UserFastestTimeManualEntryCreator({
    Key? key,
    required this.parent,
  }) : super(key: key);
  @override
  _UserFastestTimeManualEntryCreatorState createState() =>
      _UserFastestTimeManualEntryCreatorState();
}

class _UserFastestTimeManualEntryCreatorState
    extends State<UserFastestTimeManualEntryCreator> {
  bool _loading = false;
  bool _uploadingVideo = false;
  bool _processingVideo = false;
  double _uploadProgress = 0.0;
  String? _uploadedVideoUri;
  String? _uploadedVideoThumbUri;
  final CancelToken _mediaUploadCancelToken = CancelToken();

  final TextEditingController _timeTakenMsController = TextEditingController();
  int? _timetakenMs;
  DateTime _completedOn = DateTime.now();
  String? _localVideoPath;

  @override
  void initState() {
    super.initState();
    _timeTakenMsController.addListener(() {
      setState(() {
        _timetakenMs = Utils.textNotNull(_timeTakenMsController.text)
            ? int.parse(_timeTakenMsController.text)
            : null;
      });
    });
  }

  Future<void> _createManualEntry() async {
    if (_timetakenMs == null) {
      return;
    }

    /// Check for video upload.
    if (_localVideoPath != null) {
      await _uploadVideo();
    }

    setState(() => _loading = true);

    final variables = CreateUserFastestTimeTrackerManualEntryArguments(
        data: CreateUserFastestTimeTrackerManualEntryInput(
            completedOn: _completedOn,
            videoUri: _uploadedVideoUri,
            videoThumbUri: _uploadedVideoThumbUri,
            userFastestTimeExerciseTracker:
                ConnectRelationInput(id: widget.parent.id),
            timeTakenMs: _timetakenMs!));

    final result = await context.graphQLStore.mutate(
        mutation: CreateUserFastestTimeTrackerManualEntryMutation(
            variables: variables),
        broadcastQueryIds: [GQLOpNames.userFastestTimeExerciseTrackers]);

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

  bool get _validToSubmit => _timetakenMs != null;

  @override
  void dispose() {
    _timeTakenMsController.dispose();

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
        middle: const NavBarTitle('Submit Fastest Time'),
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
                'What did you lift?',
              ),
              const SizedBox(height: 8),
              MyNumberInput(
                _timeTakenMsController,
                allowDouble: true,
                autoFocus: true,
              ),
              const SizedBox(height: 6),
              MyText(
                widget.parent.loadUnit.display,
                size: FONTSIZE.four,
                weight: FontWeight.bold,
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
