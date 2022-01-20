import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/feed_post_card.dart';
import 'package:sofie_ui/components/creators/post_creator/share_object_type_selector_button.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class FeedPostCreatorPage extends StatefulWidget {
  const FeedPostCreatorPage({Key? key}) : super(key: key);

  @override
  _FeedPostCreatorPageState createState() => _FeedPostCreatorPageState();
}

class _FeedPostCreatorPageState extends State<FeedPostCreatorPage> {
  late AuthedUser _authedUser;

  /// If postType == PostType.user then we post to feed [kUserFeedName]
  late FlatFeed _feed;

  /// A stream User ref. Make sure format is correct by using [StreamUser.ref].
  /// [context.streamFeedClient.currentUser!.ref].
  late String _actor;

  Activity? _activity;
  // While editing handle this input separately so we can keep it as a typed class rather than a Map.
  ActivityExtraData? _extraData;

  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _authedUser = GetIt.I<AuthBloc>().authedUser!;

    _feed = context.streamFeedClient.flatFeed(kUserFeedName, _authedUser.id);

    _actor = context.streamFeedClient.currentUser!.ref;

    _captionController.addListener(() {
      setState(() {
        if (_extraData != null) {
          _extraData!.caption = _captionController.text;
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
            _extraData = null;
            _captionController.text = '';
            _tagInputController.text = '';
          });
        });
  }

  void _initActivity({
    required FeedPostType type,
    String? creatorId,
    String? creatorName,
    required String objectId,
    required String objectName,
    String? imageUri, // Will be Uploadcare Uuid.
  }) {
    _extraData = ActivityExtraData(
      posterId: _authedUser.id,
      posterName: _authedUser.displayName,
      creatorId: creatorId,
      creatorName: creatorName,
      objectId: objectId,
      objectName: objectName,
      tags: [],
      imageUrl:
          imageUri != null ? UploadcareService.getFileUrl(imageUri) : null,
    );

    _activity = Activity(
      actor: _actor,
      verb: kDefaultFeedPostVerb,
      object: kFeedPostTypeToStreamName[type],
    );
    setState(() {});
  }

  void _selectWorkout(WorkoutSummary workout) {
    _initActivity(
      creatorId: workout.user.id,
      creatorName: workout.user.displayName,
      objectId: workout.id,
      objectName: workout.name,
      type: FeedPostType.workout,
      imageUri: workout.coverImageUri,
    );
  }

  void _selectWorkoutPlan(WorkoutPlanSummary plan) {
    _initActivity(
      creatorId: plan.user.id,
      creatorName: plan.user.displayName,
      objectId: plan.id,
      objectName: plan.name,
      type: FeedPostType.workoutPlan,
      imageUri: plan.coverImageUri,
    );
  }

  void _selectWorkoutLog(LoggedWorkout log) {
    _initActivity(
      objectId: log.id,
      objectName: log.name,
      type: FeedPostType.loggedWorkout,
    );
  }

  void _addTag(String tag) {
    setState(() {
      _tagInputController.text = '';
      _extraData!.tags.add(tag);
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _extraData!.tags.remove(tag);
    });
  }

  Future<void> _createPost() async {
    if (_activity != null && _extraData != null) {
      setState(() {
        _loading = true;
      });

      final activity = Activity(
        actor: _activity!.actor,
        object: _activity!.object,
        verb: _activity!.verb,
        extraData: _extraData!.toJson,
      );

      try {
        await _feed.addActivity(activity);

        context.pop();
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

  @override
  void dispose() {
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
              ? const CupertinoActivityIndicator(
                  radius: 14,
                )
              : (_activity != null && _extraData != null)
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
            child: _activity != null && _extraData != null
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      FeedPostInputs(
                        extraData: _extraData!,
                        addTag: _addTag,
                        captionController: _captionController,
                        tagInputController: _tagInputController,
                        removeTag: _removeTag,
                      ),
                      const SizedBox(height: 10),
                      const HorizontalLine(
                        verticalPadding: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FeedPostCard(
                            isPreview: true,
                            activity: EnrichedActivity(
                                time: DateTime.now(),
                                object: _activity!.object),
                            activityExtraData: _extraData!),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ShareObjectTypeSelectorButton(
                        title: 'Workout',
                        description:
                            'Share a workout you have created, found or are going to do!',
                        assetImageUri: 'assets/placeholder_images/workout.jpg',
                        onPressed: () => context.navigateTo(YourWorkoutsRoute(
                            pageTitle: 'Select Workout',
                            showCreateButton: true,
                            selectWorkout: _selectWorkout)),
                      ),
                      ShareObjectTypeSelectorButton(
                          title: 'Workout Plan',
                          description:
                              'Share a plan you have created, found or are going to do!',
                          assetImageUri: 'assets/placeholder_images/plan.jpg',
                          onPressed: () => context.navigateTo(
                                YourPlansRoute(
                                    selectPlan: _selectWorkoutPlan,
                                    showCreateButton: true,
                                    pageTitle: 'Select Plan'),
                              )),
                      ShareObjectTypeSelectorButton(
                          title: 'Workout Log',
                          description: 'Share a log you have done!',
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
  final ActivityExtraData extraData;
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
      required this.tagInputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextAreaFormFieldRow(
            placeholder: 'Write a caption...',
            autofocus: captionController.text.isEmpty,
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
                  placeholder: 'Add a tag...',
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
