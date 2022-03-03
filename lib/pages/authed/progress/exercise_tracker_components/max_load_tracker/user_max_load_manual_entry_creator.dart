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

class UserMaxLoadManualEntryCreator extends StatefulWidget {
  final UserMaxLoadExerciseTracker parent;
  const UserMaxLoadManualEntryCreator({
    Key? key,
    required this.parent,
  }) : super(key: key);
  @override
  _UserMaxLoadManualEntryCreatorState createState() =>
      _UserMaxLoadManualEntryCreatorState();
}

class _UserMaxLoadManualEntryCreatorState
    extends State<UserMaxLoadManualEntryCreator> {
  bool _loading = false;
  bool _uploadingVideo = false;
  bool _processingVideo = false;
  double _uploadProgress = 0.0;
  String? _uploadedVideoUri;
  String? _uploadedVideoThumbUri;
  final CancelToken _mediaUploadCancelToken = CancelToken();

  final TextEditingController _loadAmountController = TextEditingController();
  double? _loadAmount;
  DateTime _completedOn = DateTime.now();
  String? _localVideoPath;

  @override
  void initState() {
    super.initState();
    _loadAmountController.addListener(() {
      setState(() {
        _loadAmount = Utils.textNotNull(_loadAmountController.text)
            ? double.parse(_loadAmountController.text)
            : null;
      });
    });
  }

  Future<void> _createManualEntry() async {
    if (_loadAmount == null) {
      return;
    }

    /// Check for video upload.
    if (_localVideoPath != null) {
      await _uploadVideo();
    }

    setState(() => _loading = true);

    final variables = CreateUserMaxLoadTrackerManualEntryArguments(
        data: CreateUserMaxLoadTrackerManualEntryInput(
            completedOn: _completedOn,
            loadAmount: _loadAmount!,
            videoUri: _uploadedVideoUri,
            videoThumbUri: _uploadedVideoThumbUri,
            userMaxLoadExerciseTracker:
                ConnectRelationInput(id: widget.parent.id)));

    final result = await context.graphQLStore.mutate(
        mutation:
            CreateUserMaxLoadTrackerManualEntryMutation(variables: variables),
        broadcastQueryIds: [GQLOpNames.userMaxLoadExerciseTrackers]);

    setState(() => _loading = false);

    checkOperationResult(context, result, onSuccess: context.pop);
  }

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

  bool get _validToSubmit => _loadAmount != null;

  @override
  Widget build(BuildContext context) {
    final indicatorWidth = MediaQuery.of(context).size.width * 0.4;

    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: _uploadingVideo || _processingVideo,
        middle: const NavBarTitle('Submit Max Lift Score'),
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
                _loadAmountController,
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
