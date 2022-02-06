import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/post_creator/post_media_pickers.dart';
import 'package:sofie_ui/components/creators/post_creator/share_object_type_selector_button.dart';
import 'package:sofie_ui/components/icons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:dio/src/cancel_token.dart';

class ClubFeedPostCreatorPage extends StatefulWidget {
  final String clubId;
  final VoidCallback onSuccess;
  const ClubFeedPostCreatorPage(
      {Key? key, required this.clubId, required this.onSuccess})
      : super(key: key);

  @override
  _ClubFeedPostCreatorPageState createState() =>
      _ClubFeedPostCreatorPageState();
}

class _ClubFeedPostCreatorPageState extends State<ClubFeedPostCreatorPage> {
  late StreamFeedClient _streamFeedClient;

  /// A stream User ref. Make sure format is correct by using [StreamUser.ref].
  /// [context.streamFeedClient.currentUser!.ref].
  /// Format of stream user ref is: [SU:a379ea36-8a96-4bc6-82ae-c1b716c85b86]
  late String _actor;

  CreateStreamFeedActivityInput? _activity;
  FeedPostType? _feedPostType;

  final TextEditingController _articleUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();

  File? _image;
  File? _audio;
  File? _video;
  final CancelToken _cancelToken = CancelToken();

  /// Must be between 0.0 and 1.0.
  double _mediaUploadProgress = 0.0;

  /// [true] while uploading media.
  bool _uploadingMedia = false;

  /// [true] while creating activity after uploading any media.
  bool _loading = false;

  /// If user cancels during media upload this will set [true] and the post creation will be aborted.
  bool _userHasCancelled = false;

  @override
  void initState() {
    super.initState();

    _streamFeedClient = context.streamFeedClient;

    _actor = _streamFeedClient.currentUser!.ref;

    _articleUrlController.addListener(() {
      setState(() {
        if (_activity?.extraData != null) {
          _activity!.extraData.articleUrl = _articleUrlController.text;
        }
      });
    });

    _titleController.addListener(() {
      setState(() {
        if (_activity?.extraData != null) {
          _activity!.extraData.title = _titleController.text;
        }
      });
    });

    _captionController.addListener(() {
      setState(() {
        if (_activity?.extraData != null) {
          _activity!.extraData.caption = _captionController.text;
        }
      });
    });

    _tagInputController.addListener(() {
      setState(() {});
    });
  }

  void _confirmReset() {
    context.showConfirmDeleteDialog(
        verb: 'Reset',
        itemType: 'Post',
        onConfirm: () {
          Utils.hideKeyboard(context);
          setState(() {
            _activity = null;
            _captionController.text = '';
            _tagInputController.text = '';
          });
        });
  }

  void _setUploading(bool uploading) =>
      setState(() => _uploadingMedia = uploading);

  void _updateProgress(int count, int total) => setState(() {
        _mediaUploadProgress = (count / total).clamp(0.0, 1.0);
      });

  void _initActivity({
    required FeedPostType type,

    /// For shared content types.
    String? creatorId,

    /// For non shared content types (announcement, article, video) the [objectId] should be a timestamp.
    required String objectId,
    String? title,
    String? articleUrl,
    String? imageUrl,
    String? videoUrl,
    String? audioUrl,
  }) {
    _feedPostType = type;

    /// Default the title of the post to be the object name.
    _titleController.text = title ?? '';

    _activity = CreateStreamFeedActivityInput(
        actor: _actor,
        verb: kDefaultFeedPostVerb,
        object: '${kFeedPostTypeToStreamName[type]}:$objectId',
        extraData: CreateStreamFeedActivityExtraDataInput(
          creator:
              creatorId != null ? _streamFeedClient.user(creatorId).ref : null,
          title: title,
          tags: [],
          articleUrl: articleUrl,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          audioUrl: audioUrl,
        ));
    setState(() {});
  }

  /// Methods for the different post types.
  void _createAnnouncement() {
    _initActivity(
      type: FeedPostType.announcement,
      objectId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  void _createArticle() {
    _initActivity(
      type: FeedPostType.article,
      objectId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  void _selectWorkout(WorkoutSummary workout) {
    _initActivity(
      creatorId: workout.user.id,
      objectId: workout.id,
      title: workout.name,
      type: FeedPostType.workout,
      imageUrl: workout.coverImageUri != null
          ? UploadcareService.getFileUrl(workout.coverImageUri!)
          : null,
    );
  }

  void _selectWorkoutPlan(WorkoutPlanSummary plan) {
    _initActivity(
      creatorId: plan.user.id,
      objectId: plan.id,
      title: plan.name,
      type: FeedPostType.workoutPlan,
      imageUrl: plan.coverImageUri != null
          ? UploadcareService.getFileUrl(plan.coverImageUri!)
          : null,
    );
  }

  void _selectWorkoutLog(LoggedWorkout log) {
    _initActivity(
      objectId: log.id,
      title: log.name,
      type: FeedPostType.loggedWorkout,
    );
  }

  void _addTag(String tag) {
    if (_activity?.extraData != null) {
      /// Don't add a tag that is already there.
      if (!_activity!.extraData.tags.contains(tag)) {
        setState(() {
          _tagInputController.text = '';
          _activity!.extraData.tags.add(tag);
        });
      }
    }
  }

  void _removeTag(String tag) {
    if (_activity?.extraData != null) {
      setState(() {
        _activity!.extraData.tags.remove(tag);
      });
    }
  }

  /// Uploads any attached media to Stream servers then creates and sends a new Acticity.
  Future<void> _createPost() async {
    if (_activity != null && _feedPostType != null) {
      setState(() {
        _loading = true;
      });

      /// Close keyboard so media uploading indicator can display at bottom of screen if needed.
      Utils.hideKeyboard(context);

      /// If the user has selected some media. Upload it first, get back the url then add it to the extra data.
      /// Only one of these three should ever be uploaded.
      /// Priority goes Video > Audio > Image.
      if (_video != null) {
        _setUploading(true);
        _activity!.extraData.videoUrl = await _streamFeedClient.files.upload(
            AttachmentFile(path: _video!.path),
            cancelToken: _cancelToken,
            onSendProgress: _updateProgress);
      } else if (_audio != null) {
        _setUploading(true);
        _activity!.extraData.audioUrl = await _streamFeedClient.files.upload(
            AttachmentFile(path: _audio!.path),
            cancelToken: _cancelToken,
            onSendProgress: _updateProgress);
      } else if (_image != null) {
        _setUploading(true);
        _activity!.extraData.imageUrl = await _streamFeedClient.images.upload(
            AttachmentFile(path: _image!.path),
            cancelToken: _cancelToken,
            onSendProgress: _updateProgress);
      }

      _setUploading(false);

      if (_userHasCancelled) {
        /// Once we have aborted cancellation. Reset the flag.
        setState(() {
          _userHasCancelled = false;
        });
      } else {
        final extraData = _activity!.extraData;

        try {
          final variables = CreateClubMembersFeedPostArguments(
              clubId: widget.clubId,
              data: CreateStreamFeedActivityInput(
                  actor: _actor,
                  extraData: CreateStreamFeedActivityExtraDataInput(
                    title: extraData.title,
                    creator: extraData.creator,
                    caption: extraData.caption,
                    articleUrl: extraData.articleUrl,
                    audioUrl: extraData.audioUrl,
                    imageUrl: extraData.imageUrl,
                    videoUrl: extraData.videoUrl,
                    tags: extraData.tags,
                  ),
                  object: _activity!.object,
                  verb: _activity!.verb));

          final result = await context.graphQLStore.networkOnlyOperation<
                  CreateClubMembersFeedPost$Mutation,
                  CreateClubMembersFeedPostArguments>(
              operation:
                  CreateClubMembersFeedPostMutation(variables: variables));

          checkOperationResult(context, result,
              onSuccess: () {
                context.pop();
                widget.onSuccess();
              },
              onFail: () => context.showToast(
                  message: 'There was a problem creating the post.',
                  toastType: ToastType.destructive));
        } catch (e) {
          printLog(e.toString());
          context.showToast(
              message: 'There was a problem creating the post.',
              toastType: ToastType.destructive);
        } finally {
          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        }
      }
    }
  }

  void _cancelCreatePost() {
    _userHasCancelled = true;
    _cancelToken.cancel();
    setState(() {});
  }

  bool _validToSubmit() {
    if (_feedPostType == FeedPostType.article) {
      return Utils.textNotNull(_titleController.text) &&
          Utils.textNotNull(_articleUrlController.text);
    } else {
      return Utils.textNotNull(_titleController.text);
    }
  }

  @override
  void dispose() {
    _articleUrlController.dispose();
    _titleController.dispose();
    _captionController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          middle: const NavBarTitle('New Post'),
          trailing: _loading
              ? const NavBarActivityIndicator()
              : (_activity != null)
                  ? FadeInUp(
                      child: NavBarTrailingRow(children: [
                        NavBarCancelButton(
                          _confirmReset,
                          text: 'Reset',
                          color: Styles.errorRed,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 4),
                          child: IconButton(
                              disabled: !_validToSubmit(),
                              iconData: CupertinoIcons.paperplane,
                              onPressed: _createPost),
                        )
                      ]),
                    )
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: _activity != null && _feedPostType != null
                ? Stack(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          if (_feedPostType == FeedPostType.article)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: MyTextAreaFormFieldRow(
                                  placeholder: 'Link to article (required)...',
                                  autofocus: true,
                                  backgroundColor: context.theme.cardBackground,
                                  keyboardType: TextInputType.text,
                                  controller: _articleUrlController),
                            ),
                          FeedPostInputs(
                            extraData: _activity!.extraData,
                            addTag: _addTag,
                            titleController: _titleController,
                            captionController: _captionController,
                            tagInputController: _tagInputController,
                            removeTag: _removeTag,
                          ),
                          const SizedBox(height: 10),
                          MediaPickers(
                            feedPostType: _feedPostType!,
                            onAudioFilePickedRemoved: (picked) =>
                                setState(() => _audio = picked),
                            audio: _audio,
                            onImageFilePickedRemoved: (picked) =>
                                setState(() => _image = picked),
                            image: _image,
                            onVideoFilePickedRemoved: (picked) =>
                                setState(() => _video = picked),
                            video: _video,
                          ),
                        ],
                      ),
                      if (_uploadingMedia)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FadeInUp(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ContentBox(
                              borderRadius: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const MyText(
                                    'UPLOADING',
                                    size: FONTSIZE.one,
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  LinearProgressIndicator(
                                      progress: _mediaUploadProgress,
                                      width: MediaQuery.of(context).size.width *
                                          0.4),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  TextButton(
                                      padding: EdgeInsets.zero,
                                      text: 'Cancel',
                                      destructive: true,
                                      onPressed: () => _cancelCreatePost)
                                ],
                              ),
                            ),
                          )),
                        )
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      ShareObjectTypeSelectorButton(
                        title: 'Announcement',
                        description:
                            'Keep your members updated on what is going on.',
                        assetImageUri:
                            'assets/placeholder_images/announcement.jpg',
                        onPressed: _createAnnouncement,
                      ),
                      ShareObjectTypeSelectorButton(
                        title: 'Article',
                        description:
                            'Share an article you have written or have found useful.',
                        assetImageUri: 'assets/placeholder_images/article.jpg',
                        onPressed: _createArticle,
                      ),
                      ShareObjectTypeSelectorButton(
                        title: 'Workout',
                        description:
                            'Share a workout you have created, found or are going to do.',
                        assetImageUri: 'assets/placeholder_images/workout.jpg',
                        onPressed: () => context.navigateTo(YourWorkoutsRoute(
                            pageTitle: 'Select Workout',
                            showCreateButton: true,
                            selectWorkout: _selectWorkout)),
                      ),
                      ShareObjectTypeSelectorButton(
                          title: 'Workout Plan',
                          description:
                              'Share a plan you have created, found or are going to do.',
                          assetImageUri: 'assets/placeholder_images/plan.jpg',
                          onPressed: () => context.navigateTo(
                                YourPlansRoute(
                                    selectPlan: _selectWorkoutPlan,
                                    showCreateButton: true,
                                    pageTitle: 'Select Plan'),
                              )),
                      ShareObjectTypeSelectorButton(
                          title: 'Workout Log',
                          description: 'Share a log you have done.',
                          assetImageUri:
                              'assets/placeholder_images/workout-log.jpg',
                          onPressed: () => context.navigateTo(
                                LoggedWorkoutsRoute(
                                  selectLoggedWorkout: _selectWorkoutLog,
                                  pageTitle: 'Select Log',
                                ),
                              ))
                    ],
                  ),
          ),
        ));
  }
}

class FeedPostInputs extends StatelessWidget {
  final CreateStreamFeedActivityExtraDataInput extraData;
  final TextEditingController titleController;
  final TextEditingController captionController;
  final TextEditingController tagInputController;
  final void Function(String tag) addTag;
  final void Function(String tag) removeTag;
  const FeedPostInputs(
      {Key? key,
      required this.extraData,
      required this.captionController,
      required this.addTag,
      required this.removeTag,
      required this.tagInputController,
      required this.titleController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextAreaFormFieldRow(
            placeholder: 'Title (required)...',
            autofocus: true,
            backgroundColor: context.theme.cardBackground,
            keyboardType: TextInputType.text,
            controller: titleController),
        const SizedBox(height: 16),
        MyTextAreaFormFieldRow(
            placeholder: 'Message...',
            backgroundColor: context.theme.cardBackground,
            keyboardType: TextInputType.text,
            controller: captionController),
        const SizedBox(height: 16),
        FeedPostTagsInput(
          tags: extraData.tags,
          tagInputController: tagInputController,
          addTag: addTag,
          removeTag: removeTag,
        ),
      ],
    );
  }
}

class FeedPostTagsInput extends StatelessWidget {
  final List<String> tags;
  final TextEditingController tagInputController;
  final void Function(String tag) addTag;
  final void Function(String tag) removeTag;
  const FeedPostTagsInput(
      {Key? key,
      required this.tags,
      required this.addTag,
      required this.removeTag,
      required this.tagInputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldRow(
                  backgroundColor: context.theme.cardBackground,
                  controller: tagInputController,
                  // Don't allow any spaces or special chracters.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  ],
                  placeholder: 'Tag...',
                  keyboardType: TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  disabled: tagInputController.text.isEmpty,
                  iconData: CupertinoIcons.plus_square,
                  size: 50,
                  onPressed: () => addTag(tagInputController.text)),
            )
          ],
        ),
        GrowInOut(
            show: tags.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: tags
                    .map((t) => CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => removeTag(t),
                          child: MyText(
                            '#$t',
                            weight: FontWeight.bold,
                            color: Styles.primaryAccent,
                          ),
                        ))
                    .toList(),
              ),
            )),
      ],
    );
  }
}
