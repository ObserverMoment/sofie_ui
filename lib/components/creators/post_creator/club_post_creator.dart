import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/club_timeline_post_card.dart';
import 'package:sofie_ui/components/cards/workout_card.dart';
import 'package:sofie_ui/components/cards/workout_plan_card.dart';
import 'package:sofie_ui/components/creators/post_creator/share_object_type_selector_button.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

/// Currently: Like a content share function. Can only share certain objects from within the app such as [Workout], [WorkoutPlan] etc.
class ClubPostCreatorPage extends StatefulWidget {
  final String clubId;
  final void Function(TimelinePostFullData createdPost)? onSuccess;
  const ClubPostCreatorPage({Key? key, required this.clubId, this.onSuccess})
      : super(key: key);

  @override
  _ClubPostCreatorPageState createState() => _ClubPostCreatorPageState();
}

class _ClubPostCreatorPageState extends State<ClubPostCreatorPage> {
  final TextEditingController _captionController = TextEditingController();

  /// Tags are text input one at at time via _tagsController
  final TextEditingController _tagInputController = TextEditingController();

  /// List of strings. Added to Activity as a comma separated list.
  /// "tag1,tag2,tag3".
  final List<String> _tags = <String>[];

  /// The selected objects id and type to share + vars to save the data to display object summary.
  /// [id] is uid from DB
  /// [type] is name such as Workout | WorkoutPlan | Challenge.
  /// Will be formed as [type:id] before being sent to getStream as [Activity.object]
  String? _selectedObjectId;
  TimelinePostType? _selectedObjectType;

  /// Only one of these should ever be not null.
  /// When saving a new one make sure you set all others null.
  WorkoutSummary? _workout;
  WorkoutPlanSummary? _workoutPlan;

  final PageController _pageController = PageController();
  int _activePageIndex = 0;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(() {
      setState(() {});
    });
    _tagInputController.addListener(() {
      setState(() {});
    });
  }

  bool get _objectSelected =>
      _selectedObjectId != null && _selectedObjectType != null;

  /// Doesn't setState...
  void _removeAllObjects() {
    _workout = null;
    _workoutPlan = null;
  }

  void _selectWorkout(WorkoutSummary w) {
    _removeAllObjects();
    _workout = w;
    _selectedObjectId = w.id;
    _selectedObjectType = TimelinePostType.workout;
    _changePage(1);
  }

  void _selectWorkoutPlan(WorkoutPlanSummary plan) {
    _removeAllObjects();
    _workoutPlan = plan;
    _selectedObjectId = plan.id;
    _selectedObjectType = TimelinePostType.workoutplan;
    _changePage(1);
  }

  void _addTag() {
    if (_tags.contains(_tagInputController.text)) {
      context.showToast(message: 'Tag already being used.');
    } else {
      setState(() {
        _tags.add(_tagInputController.text);
        _tagInputController.text = '';
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _createPost() async {
    if (!Utils.textNotNull(_captionController.text) || !_objectSelected) {
      throw Exception('Must supply a caption and and object to post.');
    }
    setState(() {
      _loading = true;
    });
    try {
      final variables = CreateClubTimelinePostArguments(
          data: CreateClubTimelinePostInput(
              clubId: widget.clubId,
              object: '${_selectedObjectType!.apiValue}:$_selectedObjectId',
              caption: _captionController.text,
              tags: _tags));

      final result = await context.graphQLStore.networkOnlyOperation<
              CreateClubTimelinePost$Mutation, CreateClubTimelinePostArguments>(
          operation: CreateClubTimelinePostMutation(variables: variables));

      setState(() {
        _loading = false;
      });

      if (result.hasErrors || result.data == null) {
        result.errors?.forEach((e) {
          printLog(e.toString());
        });
        throw Exception();
      } else {
        context.pop();
        widget.onSuccess?.call(result.data!.createClubTimelinePost);
      }
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'There was a problem creating the post.',
          toastType: ToastType.destructive);
      setState(() {
        _loading = false;
      });
    }
  }

  void _changePage(int index) {
    if (index == 0) {
      Utils.hideKeyboard(context);
    }
    _pageController.toPage(
      index,
    );
    setState(() => _activePageIndex = index);
  }

  UserSummary _getSelectedObjectCreator() {
    switch (_selectedObjectType) {
      case TimelinePostType.workout:
        return _workout!.user;
      case TimelinePostType.workoutplan:
        return _workoutPlan!.user;
      default:
        throw Exception(
            'PostCreator._getSelectedObjectCreator: No converter provided for $_selectedObjectType.');
    }
  }

  TimelinePostObjectDataObject _getSelectedObjectData() {
    switch (_selectedObjectType) {
      case TimelinePostType.workout:
        return TimelinePostObjectDataObject.fromJson(
            {..._workout!.toJson(), 'type': _selectedObjectType!.apiValue});
      case TimelinePostType.workoutplan:
        return TimelinePostObjectDataObject.fromJson(
            {..._workoutPlan!.toJson(), 'type': _selectedObjectType!.apiValue});
      default:
        throw Exception(
            'PostCreator._getSelectedObjectJson: No converter provided for $_selectedObjectType.');
    }
  }

  /// Form data required to display a preview of what the post will look like.
  TimelinePostObjectDataUser _getPosterDataForPreview() =>
      TimelinePostObjectDataUser()
        ..id = 'not_required_for_preview'
        ..displayName = 'You';

  TimelinePostObjectDataUser _getCreatorDataForPreview() =>
      TimelinePostObjectDataUser.fromJson(_getSelectedObjectCreator().toJson());

  TimelinePostFullData get _postDataForPreview => TimelinePostFullData()
    ..activityId = 'temp'
    ..postedAt = DateTime.now()
    ..caption = _captionController.text
    ..tags = _tags
    ..poster = _getPosterDataForPreview()
    ..creator = _getCreatorDataForPreview()
    ..object = _getSelectedObjectData();

  Widget get _buildLeading => AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _activePageIndex == 0
            ? NavBarCancelButton(context.pop)
            : CupertinoButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () => _changePage(0),
                child: Icon(
                  CupertinoIcons.arrow_left,
                  size: 22,
                  color: context.theme.primary,
                ),
              ),
      );

  Widget? get _buildTrailingPageOne => _objectSelected
      ? _loading
          ? const NavBarTrailingRow(
              children: [
                NavBarLoadingDots(),
              ],
            )
          : NavBarSaveButton(
              () => _changePage(1),
              text: 'Next',
            )
      : null;

  Widget? get _buildTrailingPageTwo =>
      Utils.textNotNull(_captionController.text) && _objectSelected
          ? _loading
              ? const NavBarTrailingRow(
                  children: [
                    NavBarLoadingDots(),
                  ],
                )
              : NavBarSaveButton(
                  _createPost,
                )
          : null;

  Widget _buildDisplayCardByType() {
    switch (_selectedObjectType) {
      case TimelinePostType.workout:
        return WorkoutCard(_workout!);
      case TimelinePostType.workoutplan:
        return WorkoutPlanCard(_workoutPlan!);
      default:
        throw Exception(
            'PostCreator._buildDisplayCardByType: No selector provided for $_selectedObjectType.');
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _tagInputController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
            customLeading: _buildLeading,
            middle: const NavBarTitle('Create Post'),
            trailing: _activePageIndex == 0
                ? _buildTrailingPageOne
                : _buildTrailingPageTwo),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Column(
              children: [
                if (_objectSelected)
                  GrowIn(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _buildDisplayCardByType(),
                  )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: MyText(
                      'Choose something ${_objectSelected ? "else" : ""} to share.'),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ShareObjectTypeSelectorButton(
                        title: 'Workout',
                        description:
                            'Share a workout you have created, found or are going to do!',
                        assetImageUri: 'assets/placeholder_images/workout.jpg',
                        onPressed: () => context.pushRoute(
                            PrivateWorkoutFinderRoute(
                                selectWorkout: _selectWorkout)),
                      ),
                      ShareObjectTypeSelectorButton(
                        title: 'Workout Plan',
                        description:
                            'Share a plan you have created, found or are going to do!',
                        assetImageUri: 'assets/placeholder_images/plan.jpg',
                        onPressed: () => context.pushRoute(
                            PrivateWorkoutPlanFinderRoute(
                                selectWorkoutPlan: _selectWorkoutPlan)),
                      )
                    ],
                  ),
                )
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
                MyTextAreaFormFieldRow(
                    placeholder: 'Description (required)',
                    autofocus: _captionController.text.isEmpty,
                    backgroundColor: context.theme.cardBackground,
                    keyboardType: TextInputType.text,
                    controller: _captionController),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldRow(
                          backgroundColor: context.theme.cardBackground,
                          controller: _tagInputController,
                          // Don't allow any spaces or special chracters.
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9]")),
                          ],
                          placeholder: 'Tag...',
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                          disabled: _tagInputController.text.isEmpty,
                          iconData: CupertinoIcons.add,
                          onPressed: _addTag),
                    )
                  ],
                ),
                GrowInOut(
                    show: _tags.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: _tags
                            .map((t) => CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _removeTag(t),
                                  child: MyText(
                                    '#$t',
                                    size: FONTSIZE.two,
                                  ),
                                ))
                            .toList(),
                      ),
                    )),
                const SizedBox(height: 10),
                const HorizontalLine(),
                // Preview of what the post will look like.

                if (_objectSelected)
                  SizeFadeIn(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClubTimelinePostCard(
                        isPreview: true, postData: _postDataForPreview),
                  ))
              ],
            )
          ],
        ));
  }
}
