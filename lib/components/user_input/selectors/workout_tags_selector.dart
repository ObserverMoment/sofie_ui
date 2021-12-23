import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/tag_managers/workout_tags_manager.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class WorkoutTagsSelectorRow extends StatelessWidget {
  final List<WorkoutTag> selectedWorkoutTags;
  final void Function(List<WorkoutTag> tags) updateSelectedWorkoutTags;
  final int? max;
  const WorkoutTagsSelectorRow(
      {Key? key,
      required this.selectedWorkoutTags,
      required this.updateSelectedWorkoutTags,
      this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInputContainer(
        child: CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPressed: () => context.push(
          child: WorkoutTagsSelector(
        selectedWorkoutTags: selectedWorkoutTags,
        updateSelectedWorkoutTags: updateSelectedWorkoutTags,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  MyText(
                    'Tags',
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Icon(
                    CupertinoIcons.tag,
                    size: 18,
                  ),
                ],
              ),
              Row(
                children: [
                  MyText(
                    selectedWorkoutTags.isEmpty ? 'Add' : 'Edit',
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    selectedWorkoutTags.isEmpty
                        ? CupertinoIcons.add
                        : CupertinoIcons.pencil,
                    size: 18,
                  )
                ],
              )
            ],
          ),
          GrowInOut(
              show: selectedWorkoutTags.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 2),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: selectedWorkoutTags
                      .map((g) => FadeIn(
                              child: Tag(
                            tag: g.tag,
                          )))
                      .toList(),
                ),
              ))
        ],
      ),
    ));
  }
}

/// Also lets you create a new tag and then select it via [WorkoutTagsManager].
class WorkoutTagsSelector extends StatefulWidget {
  final List<WorkoutTag> selectedWorkoutTags;
  final void Function(List<WorkoutTag> updated) updateSelectedWorkoutTags;
  const WorkoutTagsSelector(
      {Key? key,
      required this.selectedWorkoutTags,
      required this.updateSelectedWorkoutTags})
      : super(key: key);

  @override
  _WorkoutTagsSelectorState createState() => _WorkoutTagsSelectorState();
}

class _WorkoutTagsSelectorState extends State<WorkoutTagsSelector> {
  List<WorkoutTag> _activeSelectedWorkoutTags = [];

  @override
  void initState() {
    super.initState();
    _activeSelectedWorkoutTags = [...widget.selectedWorkoutTags];
  }

  void _updateSelected(WorkoutTag tapped) {
    setState(() {
      _activeSelectedWorkoutTags =
          _activeSelectedWorkoutTags.toggleItem<WorkoutTag>(tapped);
    });
    widget.updateSelectedWorkoutTags(_activeSelectedWorkoutTags);
  }

  void _openCreateNewTag() {
    context.push(
        child: WorkoutTagsManager(
      onCreateNewTag: (tag) => _updateSelected(tag),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const MyText(
                'Done',
                weight: FontWeight.bold,
              ),
              onPressed: () => Navigator.pop(context)),
          middle: const LeadingNavBarTitle('Workout Tags'),
        ),
        child: QueryObserver<UserWorkoutTags$Query, json.JsonSerializable>(
            key: Key(
                'WorkoutTagsSelector - ${UserWorkoutTagsQuery().operationName}'),
            query: UserWorkoutTagsQuery(),
            fetchPolicy: QueryFetchPolicy.storeFirst,
            builder: (data) {
              final workoutTags = data.userWorkoutTags.reversed.toList();
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        workoutTags.isEmpty
                            ? const MyText('No tags created yet...')
                            : const MyText(
                                'Click to select / deselect.',
                                size: FONTSIZE.two,
                              ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: workoutTags
                              .map((tag) => GestureDetector(
                                    onTap: () => _updateSelected(tag),
                                    child: FadeIn(
                                      child: _SelectableWorkoutTag(
                                        tag: tag,
                                        isSelected: _activeSelectedWorkoutTags
                                            .contains(tag),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        CreateTextIconButton(
                            text: 'New Tag', onPressed: _openCreateNewTag),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

class _SelectableWorkoutTag extends StatelessWidget {
  final WorkoutTag tag;
  final bool isSelected;
  const _SelectableWorkoutTag({required this.tag, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? Styles.primaryAccent : null,
          border: Border.all(
              width: 2,
              color: isSelected
                  ? Styles.primaryAccent
                  : context.theme.primary.withOpacity(0.65))),
      child: MyText(
        tag.tag,
        color: isSelected ? Styles.white : null,
      ),
    );
  }
}
