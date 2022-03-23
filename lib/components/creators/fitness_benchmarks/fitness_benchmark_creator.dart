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
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/core_data_repo.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class FitnessBenchmarkCreator extends StatefulWidget {
  final FitnessBenchmark? fitnessBenchmark;
  const FitnessBenchmarkCreator({
    Key? key,
    this.fitnessBenchmark,
  }) : super(key: key);
  @override
  _FitnessBenchmarkCreatorState createState() =>
      _FitnessBenchmarkCreatorState();
}

class _FitnessBenchmarkCreatorState extends State<FitnessBenchmarkCreator> {
  FitnessBenchmarkScoreType? _type;
  String? _name;
  String? _description;
  String? _instructions;
  String? _instructionalVideoUri;
  String? _instructionalVideoThumbUri;
  FitnessBenchmarkCategory? _category;

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
    if (widget.fitnessBenchmark != null) {
      final b = widget.fitnessBenchmark!;
      _type = b.type;
      _name = b.name;
      _description = b.description;
      _instructions = b.instructions;
      _instructionalVideoUri = b.instructionalVideoUri;
      _instructionalVideoThumbUri = b.instructionalVideoThumbUri;
      _category = b.fitnessBenchmarkCategory;
    }
  }

  void _setStateWrapper(void Function() cb) {
    _formIsDirty = true;
    setState(cb);
  }

  Future<void> _saveAndClose() async {
    if (_validToSubmit) {
      setState(() => _loading = true);

      /// If user has added or changed the video then it will be stored at [_localVideoFilePath].
      if (_localVideoFilePath != null) {
        await _uploadFile(File(_localVideoFilePath!));
      }

      if (widget.fitnessBenchmark != null) {
        _update();
      } else {
        _create();
      }
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
            _instructionalVideoUri = videoUri;
            _instructionalVideoThumbUri = videoThumbUri;
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
      final variables = CreateFitnessBenchmarkArguments(
          data: CreateFitnessBenchmarkInput(
              description: _description,
              fitnessBenchmarkCategory: ConnectRelationInput(id: _category!.id),
              instructions: _instructions,
              instructionalVideoUri: _instructionalVideoUri,
              instructionalVideoThumbUri: _instructionalVideoThumbUri,
              name: _name!,
              scope: FitnessBenchmarkScope.custom,
              type: _type!));

      final result = await context.graphQLStore.create(
          mutation: CreateFitnessBenchmarkMutation(variables: variables),
          addRefToQueries: [GQLOpNames.userFitnessBenchmarks]);

      setState(() => _loading = false);

      if (mounted) {
        checkOperationResult(context, result, onSuccess: context.pop);
      }
    }
  }

  Future<void> _update() async {
    if (mounted) {
      final variables = UpdateFitnessBenchmarkArguments(
          data: UpdateFitnessBenchmarkInput(
              id: widget.fitnessBenchmark!.id,
              description: _description,
              fitnessBenchmarkCategory: ConnectRelationInput(id: _category!.id),
              instructions: _instructions,
              instructionalVideoUri: _instructionalVideoUri,
              instructionalVideoThumbUri: _instructionalVideoThumbUri,
              name: _name!,
              type: _type!));

      final result = await context.graphQLStore.mutate(
          mutation: UpdateFitnessBenchmarkMutation(variables: variables),
          broadcastQueryIds: [
            GQLOpNames.userFitnessBenchmarks,
          ]);

      setState(() => _loading = false);

      if (mounted) {
        checkOperationResult(context, result, onSuccess: context.pop);
      }
    }
  }

  void _confirmDeleteVideo() {
    context.showConfirmDialog(
        title: 'Delete Instructional Video?',
        onConfirm: () {
          _setStateWrapper(() {
            _localVideoFilePath = null;

            /// API will handle clean up from Uploadcare.
            _instructionalVideoUri = null;
            _instructionalVideoThumbUri = null;
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
      _category != null &&
      Utils.textNotNull(_name) &&
      _type != null &&
      _formIsDirty;

  @override
  void dispose() {
    /// If the user has bailed out during a file upload then make sure you cancel the upload.
    if (_uploadingVideo || _processingVideo) {
      _videoUploadCancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final benchmarkCategories = CoreDataRepo.fitnessBenchmarkCategories;

    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_handleCancel),
        middle: NavBarTitle(widget.fitnessBenchmark != null
            ? 'Edit Benchmark'
            : 'Create Benchmark'),
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
            child: EditableTextFieldRow(
              title: 'Name',
              isRequired: _name == null,
              text: _name ?? '',
              onSave: (t) => _setStateWrapper(() => _name = t),
              inputValidation: (t) => t.length > 2 && t.length <= 30,
              maxChars: 30,
              validationMessage: 'Required. Min 3 chars. max 30',
            ),
          ),
          UserInputContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MyHeaderText(
                'Category (Required)',
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: benchmarkCategories
                    .map((cat) => SelectableBox(
                        isSelected: _category == cat,
                        onPressed: () =>
                            _setStateWrapper(() => _category = cat),
                        text: cat.name))
                    .toList(),
              ),
            ],
          )),
          UserInputContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MyHeaderText(
                'Score Type (Required)',
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: FitnessBenchmarkScoreType.values
                    .where((v) => v != FitnessBenchmarkScoreType.artemisUnknown)
                    .map((type) => SelectableBox(
                        isSelected: _type == type,
                        onPressed: () => _setStateWrapper(() => _type = type),
                        text: type.display))
                    .toList(),
              ),
            ],
          )),
          UserInputContainer(
            child: EditableTextAreaRow(
              title: 'Description',
              text: _description ?? '',
              onSave: (t) => _setStateWrapper(() => _description = t),
              inputValidation: (t) => true,
            ),
          ),
          UserInputContainer(
            child: EditableTextAreaRow(
              title: 'Instructions',
              text: _instructions ?? '',
              onSave: (t) => _setStateWrapper(() => _instructions = t),
              inputValidation: (t) => true,
            ),
          ),
          UserInputContainer(
              child: Column(
            children: [
              const MyHeaderText(
                'Instructional Video',
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_localVideoFilePath == null &&
                      _instructionalVideoUri != null)
                    VideoThumbnailPlayer(
                      videoUri: _instructionalVideoUri,
                      videoThumbUri: _instructionalVideoThumbUri,
                    ),
                  Column(
                    children: [
                      LocalVideoSelector(
                        addVideoText: _instructionalVideoUri != null
                            ? 'Replace Video'
                            : 'Add Video',
                        pickedFilePath: _localVideoFilePath,
                        savePickedFilePath: (p) =>
                            _setStateWrapper(() => _localVideoFilePath = p),
                      ),
                      if (_localVideoFilePath != null ||
                          _instructionalVideoUri != null)
                        TextButton(
                            text: 'Delete Video',
                            onPressed: _confirmDeleteVideo)
                    ],
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
