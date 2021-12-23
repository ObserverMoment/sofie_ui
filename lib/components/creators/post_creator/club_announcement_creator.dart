import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_uploader.dart';
import 'package:sofie_ui/components/media/images/image_uploader.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Club Announcement (either new or updated) is returned to the calling widget (The [ClubPostCreator]) via [onComplete].
class ClubAnnouncementCreator extends StatefulWidget {
  final ClubAnnouncement? announcement;
  final String clubId;
  final void Function(ClubAnnouncement announcement) onComplete;
  const ClubAnnouncementCreator(
      {Key? key,
      this.announcement,
      required this.clubId,
      required this.onComplete})
      : super(key: key);

  @override
  _ClubAnnouncementCreatorState createState() =>
      _ClubAnnouncementCreatorState();
}

class _ClubAnnouncementCreatorState extends State<ClubAnnouncementCreator> {
  late bool _isCreate;
  bool _loading = false;

  //// Fields for when user is creating
  /// _[controller] is used when creating only.
  final TextEditingController _controller = TextEditingController();
  String? _imageUri;
  String? _videoUri;
  String? _videoThumbUri;
  String? _audioUri;

  /// For when user is updating
  ClubAnnouncement? _activeAnnouncement;

  @override
  void initState() {
    super.initState();
    _isCreate = widget.announcement == null;

    if (_isCreate) {
      _controller.addListener(() {
        setState(() {});
      });
    } else {
      _activeAnnouncement =
          ClubAnnouncement.fromJson(widget.announcement!.toJson());
    }
  }

  void _onUploadMediaStart() {
    setState(() {
      _loading = true;
    });
  }

  //// Create Ops ////
  /// There is no ClubAnnouncement in the DB so this is all happening on the client ///
  void _onImageUpload(String imageUri) {
    setState(() {
      _imageUri = imageUri;
      _loading = false;
    });
  }

  void _onVideoUpload(String videoUri, String videoThumbUri) {
    setState(() {
      _videoUri = videoUri;
      _videoThumbUri = videoThumbUri;
      _loading = false;
    });
  }

  void _onAudioUpload(String audioUri) {
    setState(() {
      _audioUri = audioUri;
      _loading = false;
    });
  }

  Future<void> _deleteImage() async {
    if (_imageUri != null) {
      setState(() {
        _loading = true;
      });
      await UploadcareService().deleteFiles(fileIds: [_imageUri!]);
      setState(() {
        _imageUri = null;
        _loading = false;
      });
    }
  }

  Future<void> _deleteVideo() async {
    if (_videoUri != null) {
      setState(() {
        _loading = true;
      });
      await UploadcareService()
          .deleteFiles(fileIds: [_videoUri!, _videoThumbUri!]);
      setState(() {
        _videoUri = null;
        _videoThumbUri = null;
        _loading = false;
      });
    }
  }

  Future<void> _deleteAudio() async {
    if (_audioUri != null) {
      setState(() {
        _loading = true;
      });
      await UploadcareService().deleteFiles(fileIds: [_audioUri!]);
      setState(() {
        _audioUri = null;
        _loading = false;
      });
    }
  }

  Future<void> _saveClubAnnouncementToDB() async {
    if (_controller.text.length > 2) {
      setState(() {
        _loading = true;
      });
      final variables = CreateClubAnnouncementArguments(
          data: CreateClubAnnouncementInput(
        description: _controller.text,
        imageUri: _imageUri,
        audioUri: _audioUri,
        videoUri: _videoUri,
        videoThumbUri: _videoThumbUri,
        club: ConnectRelationInput(id: widget.clubId),
      ));

      setState(() {
        _loading = false;
      });

      final result = await context.graphQLStore.networkOnlyOperation(
          operation: CreateClubAnnouncementMutation(variables: variables));

      checkOperationResult(context, result,
          onFail: () => context.showToast(
              message: 'Sorry, there was a problem creating the announcement',
              toastType: ToastType.destructive),
          onSuccess: () {
            widget.onComplete(result.data!.createClubAnnouncement);
            context.pop();
          });
    }
  }

  void _confirmCloseWithoutSave() {
    context.showConfirmDialog(
        title: 'Close Without Saving',
        message:
            'Nothing will be saved and any media uploaded will be removed.',
        onConfirm: _handleCancel);
  }

  /// Clear up any media the user has uploaded before cancelling.
  Future<void> _handleCancel() async {
    final fileIdsForDeletion = [_imageUri, _audioUri, _videoUri, _videoThumbUri]
        .whereType<String>()
        .toList();

    if (fileIdsForDeletion.isNotEmpty) {
      await UploadcareService().deleteFiles(fileIds: fileIdsForDeletion);
    }

    context.pop();
  }

  ///// Methods for update ops only ////
  /// Updates ClubAnnouncement via the API ////
  /// Media clear up is handled by the API.
  Future<void> _updateClubAnnouncement(Map<String, dynamic> data) async {
    if (_activeAnnouncement == null) {
      throw Exception(
          '_activeAnnouncement has not be initialized! This is required when updating.');
    }

    setState(() {
      _loading = true;
    });

    final variables = UpdateClubAnnouncementArguments(
        data: UpdateClubAnnouncementInput(
      id: _activeAnnouncement!.id,
      description: _controller.text,
      imageUri: _imageUri,
      audioUri: _audioUri,
      videoUri: _videoUri,
      videoThumbUri: _videoThumbUri,
    ));

    setState(() {
      _loading = false;
    });

    final result = await context.graphQLStore.networkOnlyOperation(
        operation: UpdateClubAnnouncementMutation(variables: variables));

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem updating the announcement',
            toastType: ToastType.destructive),
        onSuccess: () {
          setState(() {
            _activeAnnouncement = result.data!.updateClubAnnouncement;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          middle: const LeadingNavBarTitle('Announcement'),
          trailing: _loading
              ? const NavBarTrailingRow(children: [NavBarLoadingDots()])
              : _isCreate
                  ? NavBarCancelButton(_confirmCloseWithoutSave)
                  : NavBarTextButton(context.pop, 'Done'),
        ),
        child: _isCreate
            ? _CreateUI(
                loading: _loading,
                controller: _controller,
                deleteAudio: _deleteAudio,
                deleteImage: _deleteImage,
                deleteVideo: _deleteVideo,
                audioUri: _audioUri,
                imageUri: _imageUri,
                videoUri: _videoUri,
                videoThumbUri: _videoThumbUri,
                onAudioUpload: _onAudioUpload,
                onImageUpload: _onImageUpload,
                onVideoUpload: _onVideoUpload,
                saveClubAnnouncementToDB: _saveClubAnnouncementToDB,
                onUploadMediaStart: _onUploadMediaStart)
            : _UpdateUI(
                announcement: _activeAnnouncement!,
                updateClubAnnouncement: _updateClubAnnouncement,
                onUploadMediaStart: _onUploadMediaStart));
  }
}

class _CreateUI extends StatelessWidget {
  final bool loading;
  final TextEditingController controller;
  final String? imageUri;
  final String? videoUri;
  final String? videoThumbUri;
  final String? audioUri;
  final void Function(String imageUri) onImageUpload;
  final VoidCallback deleteImage;
  final void Function(String videoUri, String videoThumbUri) onVideoUpload;
  final VoidCallback deleteVideo;
  final void Function(String audioUri) onAudioUpload;
  final VoidCallback deleteAudio;
  final VoidCallback saveClubAnnouncementToDB;
  final VoidCallback onUploadMediaStart;
  const _CreateUI(
      {Key? key,
      required this.controller,
      this.imageUri,
      this.videoUri,
      this.videoThumbUri,
      this.audioUri,
      required this.onImageUpload,
      required this.onVideoUpload,
      required this.onAudioUpload,
      required this.deleteImage,
      required this.deleteVideo,
      required this.deleteAudio,
      required this.saveClubAnnouncementToDB,
      required this.loading,
      required this.onUploadMediaStart})
      : super(key: key);

  bool get _validToSubmit => controller.text.length > 2;

  Size get _thumbnailSize =>
      _hasMedia ? const Size(140, 140) : const Size(80, 80);

  bool get _hasMedia => Utils.anyNotNull([imageUri, videoUri, audioUri]);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextAreaFormFieldRow(
                backgroundColor: context.theme.cardBackground,
                placeholder: 'Message (required)',
                keyboardType: TextInputType.text,
                validator: () => controller.text.length > 2,
                controller: controller),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: MyText('Minimum 3 characters'),
            )
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child:
              MyHeaderText(_hasMedia ? 'Media Selected' : 'Media (Optional)'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!_hasMedia || imageUri != null)
                FadeInUp(
                  child: ImageUploader(
                      onUploadStart: onUploadMediaStart,
                      imageUri: imageUri,
                      displaySize: _thumbnailSize,
                      onUploadSuccess: onImageUpload,
                      removeImage: (_) => deleteImage()),
                ),
              if (!_hasMedia) const MyText(' OR '),
              if (!_hasMedia || videoUri != null)
                FadeInUp(
                  child: VideoUploader(
                      onUploadStart: onUploadMediaStart,
                      videoUri: videoUri,
                      videoThumbUri: videoThumbUri,
                      displaySize: _thumbnailSize,
                      onUploadSuccess: onVideoUpload,
                      removeVideo: deleteVideo),
                ),
              if (!_hasMedia) const MyText(' OR '),
              if (!_hasMedia || audioUri != null)
                FadeInUp(
                  child: AudioUploader(
                      onUploadStart: onUploadMediaStart,
                      audioUri: audioUri,
                      displaySize: _thumbnailSize,
                      onUploadSuccess: onAudioUpload,
                      removeAudio: deleteAudio),
                ),
            ],
          ),
        ),
        if (_validToSubmit)
          FadeInUp(
              child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: PrimaryButton(
                loading: loading,
                text: 'Save and Continue',
                onPressed: saveClubAnnouncementToDB),
          ))
      ],
    );
  }
}

class _UpdateUI extends StatelessWidget {
  final ClubAnnouncement announcement;
  final void Function(Map<String, dynamic> data) updateClubAnnouncement;
  final VoidCallback onUploadMediaStart;
  const _UpdateUI(
      {Key? key,
      required this.announcement,
      required this.updateClubAnnouncement,
      required this.onUploadMediaStart})
      : super(key: key);

  bool get _hasMedia => Utils.anyNotNull(
      [announcement.imageUri, announcement.videoUri, announcement.audioUri]);

  Size get _thumbnailSize =>
      _hasMedia ? const Size(140, 140) : const Size(80, 80);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      children: [
        UserInputContainer(
          child: EditableTextAreaRow(
              isRequired: true,
              maxInputLines: 8,
              title: 'Message',
              validationMessage: 'Min 3 characters',
              onSave: (t) => updateClubAnnouncement({'description': t}),
              inputValidation: (t) => t.length > 3),
        ),
        const SizedBox(height: 20),
        MyHeaderText(_hasMedia ? 'Media Selected' : 'Media (Optional)'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!_hasMedia || announcement.imageUri != null)
                FadeInUp(
                  child: ImageUploader(
                      imageUri: announcement.imageUri,
                      displaySize: _thumbnailSize,
                      onUploadStart: onUploadMediaStart,
                      onUploadSuccess: (imageUri) =>
                          updateClubAnnouncement({'imageUri': imageUri}),
                      removeImage: (_) =>
                          updateClubAnnouncement({'imageUri': null})),
                ),
              if (!_hasMedia) const MyText(' OR '),
              if (!_hasMedia || announcement.videoUri != null)
                FadeInUp(
                  child: VideoUploader(
                      onUploadStart: onUploadMediaStart,
                      videoUri: announcement.videoUri,
                      videoThumbUri: announcement.videoThumbUri,
                      displaySize: _thumbnailSize,
                      onUploadSuccess: (videoUri, videoThumbUri) =>
                          updateClubAnnouncement({
                            'videoUri': videoUri,
                            'videoThumbUri': videoThumbUri
                          }),
                      removeVideo: () => updateClubAnnouncement(
                          {'videoUri': null, 'videoThumbUri': null})),
                ),
              if (!_hasMedia) const MyText(' OR '),
              if (!_hasMedia || announcement.audioUri != null)
                FadeInUp(
                  child: AudioUploader(
                      onUploadStart: onUploadMediaStart,
                      audioUri: announcement.audioUri,
                      displaySize: _thumbnailSize,
                      onUploadSuccess: (audioUri) =>
                          updateClubAnnouncement({'audioUri': audioUri}),
                      removeAudio: () =>
                          updateClubAnnouncement({'audioUri': null})),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
