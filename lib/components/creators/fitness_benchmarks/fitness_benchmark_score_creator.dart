import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/file_uploading_progress.dart';
import 'package:sofie_ui/components/media/video/local_video_selector.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_player.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/user_input/pickers/precise_duration_picker.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class FitnessBenchmarkScoreCreator extends StatefulWidget {
  final FitnessBenchmark fitnessBenchmark;
  final FitnessBenchmarkScore? fitnessBenchmarkScore;
  const FitnessBenchmarkScoreCreator({
    Key? key,
    required this.fitnessBenchmark,
    this.fitnessBenchmarkScore,
  }) : super(key: key);
  @override
  _FitnessBenchmarkScoreCreatorState createState() =>
      _FitnessBenchmarkScoreCreatorState();
}

class _FitnessBenchmarkScoreCreatorState
    extends State<FitnessBenchmarkScoreCreator> {
  final TextEditingController _scoreController = TextEditingController();
  DateTime _completedOn = DateTime.now();

  /// If the score is a time then it is always in seconds.
  double _score = 0.0;
  String? _videoUri;
  String? _videoThumbUri;
  String? _note;

  bool _formIsDirty = false;
  bool _loading = false;
  bool _uploadingVideo = false;
  bool _processingVideo = false;
  double _uploadVideoProgress = 0.0;

  /// Picked Local Video Location
  // When Creating a score (not editing) the file is saved here and uploaded to Uploadcare only when saved.
  String? _localVideoFilePath;
  final CancelToken _videoUploadCancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    if (widget.fitnessBenchmarkScore != null) {
      final e = widget.fitnessBenchmarkScore;
      _completedOn = e!.completedOn;
      _score = e.score;
      _videoUri = e.videoUri;
      _videoThumbUri = e.videoThumbUri;
      _note = e.note;
    }

    _scoreController.text = _score.stringMyDouble();
    _scoreController.selection = TextSelection(
        baseOffset: 0, extentOffset: _scoreController.value.text.length);
    _scoreController.addListener(() {
      if (Utils.textNotNull(_scoreController.text)) {
        _setStateWrapper(() => _score = double.parse(_scoreController.text));
      } else {
        _setStateWrapper(() => _score = 0.0);
      }
    });
  }

  void _setStateWrapper(void Function() cb) {
    _formIsDirty = true;
    setState(cb);
  }

  Future<void> _saveAndClose() async {
    setState(() => _loading = true);

    /// If user has added or changed the video then it will be stored at [_localVideoFilePath].
    if (_localVideoFilePath != null) {
      await _uploadFile(File(_localVideoFilePath!));
    }

    if (widget.fitnessBenchmarkScore != null) {
      _update();
    } else {
      _create();
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() => _uploadingVideo = true);

    try {
      await GetIt.I<UploadcareService>().uploadVideo(
          file: SharedFile(file),
          onProgress: (progress) =>
              setState(() => _uploadVideoProgress = progress.value),
          onUploaded: () {
            setState(() {
              _uploadingVideo = false;
              _processingVideo = true;
            });
          },
          onComplete: (videoUri, videoThumbUri) {
            _processingVideo = false;
            _uploadVideoProgress = 0.0;

            /// Assign new uri to local vars which will be passed to the api.
            /// Api will clean up deleted files from Uploadcare as required.
            _videoUri = videoUri;
            _videoThumbUri = videoThumbUri;
          },
          onFail: (e) {
            printLog(e.toString());
            context.showErrorAlert(e.toString());
            throw Exception(e);
          });
    } catch (e) {
      printLog(e.toString());
      setState(() {
        _uploadingVideo = false;
        _processingVideo = false;
        _uploadVideoProgress = 0.0;
        _loading = false;
      });
      await context.showErrorAlert(e.toString());
    }
  }

  Future<void> _create() async {
    if (mounted) {
      final variables = CreateFitnessBenchmarkScoreArguments(
          data: CreateFitnessBenchmarkScoreInput(
              note: _note,
              completedOn: _completedOn,
              score: _score,
              videoUri: _videoUri,
              videoThumbUri: _videoThumbUri,
              fitnessBenchmark:
                  ConnectRelationInput(id: widget.fitnessBenchmark.id)));

      final result = await context.graphQLStore.mutate(
          mutation: CreateFitnessBenchmarkScoreMutation(variables: variables),
          broadcastQueryIds: [GQLOpNames.userFitnessBenchmarks]);

      setState(() => _loading = false);

      if (mounted) {
        checkOperationResult(context, result,
            onFail: () => context.showToast(
                message: "Sorry, there was a problem creating this score.",
                toastType: ToastType.destructive),
            onSuccess: context.pop);
      }
    }
  }

  Future<void> _update() async {
    if (mounted) {
      final variables = UpdateFitnessBenchmarkScoreArguments(
          data: UpdateFitnessBenchmarkScoreInput(
        id: widget.fitnessBenchmarkScore!.id,
        note: _note,
        completedOn: _completedOn,
        score: _score,
        videoUri: _videoUri,
        videoThumbUri: _videoThumbUri,
      ));

      final result = await context.graphQLStore.mutate(
          mutation: UpdateFitnessBenchmarkScoreMutation(variables: variables),
          broadcastQueryIds: [
            GQLOpNames.userFitnessBenchmarks,
          ]);

      setState(() => _loading = false);

      if (mounted) {
        checkOperationResult(context, result,
            onFail: () => context.showToast(
                message: kDefaultErrorMessage,
                toastType: ToastType.destructive),
            onSuccess: context.pop);
      }
    }
  }

  void _confirmDeleteVideo() {
    context.showConfirmDialog(
        title: 'Delete Video From This Score?',
        onConfirm: () {
          _setStateWrapper(() {
            _localVideoFilePath = null;

            /// API will handle clean up from Uploadcare.
            _videoUri = null;
            _videoThumbUri = null;
          });
        });
  }

  void _handleCancel() {
    if (_formIsDirty) {
      context.showConfirmDialog(
          title: 'Close without saving?', onConfirm: context.pop);
    } else {
      context.pop();
    }
  }

  bool get _validToSubmit =>
      Utils.textNotNull(_scoreController.text) && _formIsDirty;

  Widget _buildNumberInput() => Column(
        children: [
          MyNumberInput(
            _scoreController,
            allowDouble: true,
          ),
          const SizedBox(height: 6),
          MyText(
            widget.fitnessBenchmark.type.scoreUnit ?? '',
            weight: FontWeight.bold,
          ),
        ],
      );

  Widget _buildDurationInput() {
    final duration = Duration(milliseconds: _score.round());

    return PreciseDurationPicker(
      value: duration,
      updateDuration: (d) => _setStateWrapper(
        () => _score = d.inMilliseconds.toDouble(),
      ),
    );
  }

  @override
  void dispose() {
    /// If the user has bailed out during a file upload then make sure you cancel the upload.
    if (_uploadingVideo || _processingVideo) {
      _videoUploadCancelToken.cancel();
    }
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_handleCancel),
        middle: NavBarTitle(widget.fitnessBenchmark.name),
        trailing: _loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  LoadingIndicator(
                    size: 12,
                  ),
                ],
              )
            : _validToSubmit
                ? FadeIn(child: NavBarTertiarySaveButton(_saveAndClose))
                : null,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          if (_uploadingVideo || _processingVideo)
            GrowIn(
              child: UploadcareFileUploadingProgress(
                cancelToken: _videoUploadCancelToken,
                isProcessing: _processingVideo,
                isUploading: _uploadingVideo,
                progress: _uploadVideoProgress,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
          UserInputContainer(
            child: DateTimePickerDisplay(
              dateTime: _completedOn,
              saveDateTime: (DateTime d) {
                _setStateWrapper(() {
                  _completedOn = d;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              children: [
                H3(widget.fitnessBenchmark.type.typeHeading),
                const SizedBox(height: 12),
                if ([
                  FitnessBenchmarkScoreType.fastesttimedistance,
                  FitnessBenchmarkScoreType.fastesttimereps,
                  FitnessBenchmarkScoreType.unbrokenmaxtime,
                ].contains(widget.fitnessBenchmark.type))
                  _buildDurationInput()
                else
                  _buildNumberInput(),
              ],
            ),
          ),
          UserInputContainer(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_localVideoFilePath == null && _videoUri != null)
                VideoThumbnailPlayer(
                  videoUri: _videoUri,
                  videoThumbUri: _videoThumbUri,
                ),
              Column(
                children: [
                  LocalVideoSelector(
                    addVideoText:
                        _videoUri != null ? 'Replace Video' : 'Add Video',
                    pickedFilePath: _localVideoFilePath,
                    savePickedFilePath: (p) =>
                        _setStateWrapper(() => _localVideoFilePath = p),
                  ),
                  if (_localVideoFilePath != null || _videoUri != null)
                    TextButton(
                        text: 'Delete Video', onPressed: _confirmDeleteVideo)
                ],
              ),
            ],
          )),
          UserInputContainer(
            child: EditableTextAreaRow(
                title: 'Note',
                text: _note ?? '',
                maxDisplayLines: 6,
                onSave: (t) => _setStateWrapper(() => _note = t),
                inputValidation: (t) => true),
          ),
        ],
      ),
    );
  }
}
