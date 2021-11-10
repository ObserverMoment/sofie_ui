import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/user_input/tag_managers/progress_journal_goal_tags_manager.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/default_object_factory.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ProgressJournalGoalCreator extends StatefulWidget {
  final String parentJournalId;
  final ProgressJournalGoal? progressJournalGoal;
  const ProgressJournalGoalCreator(
      {Key? key, this.progressJournalGoal, required this.parentJournalId})
      : super(key: key);

  @override
  _ProgressJournalGoalCreatorState createState() =>
      _ProgressJournalGoalCreatorState();
}

class _ProgressJournalGoalCreatorState
    extends State<ProgressJournalGoalCreator> {
  late ProgressJournalGoal _activeProgressJournalGoal;
  late bool _isEditing;
  bool _isLoading = false;
  bool _formIsDirty = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.progressJournalGoal != null;
    _activeProgressJournalGoal = _isEditing
        ? ProgressJournalGoal.fromJson(widget.progressJournalGoal!.toJson())
        : DefaultObjectfactory.defaultProgressJournalGoal();
  }

  void _updateName(String name) => setState(() {
        _formIsDirty = true;
        _activeProgressJournalGoal.name = name;
      });

  void _updateDescription(String description) => setState(() {
        _formIsDirty = true;
        _activeProgressJournalGoal.description = description;
      });

  void _updateDeadline(DateTime deadline) => setState(() {
        _formIsDirty = true;
        _activeProgressJournalGoal.deadline = deadline;
      });

  void _updateCompletedDate(DateTime completedDate) => setState(() {
        _formIsDirty = true;
        _activeProgressJournalGoal.completedDate = completedDate;
      });

  void _toggleSelectTag(ProgressJournalGoalTag tag) => setState(() {
        _formIsDirty = true;
        _activeProgressJournalGoal.progressJournalGoalTags =
            _activeProgressJournalGoal.progressJournalGoalTags
                .toggleItem<ProgressJournalGoalTag>(tag);
      });

  Future<void> _handleSave(BuildContext context) async {
    if (_isEditing) {
      if (_formIsDirty) {
        setState(() => _isLoading = true);

        final variables = UpdateProgressJournalGoalArguments(
            data: UpdateProgressJournalGoalInput.fromJson(
                _activeProgressJournalGoal.toJson()));

        final result = await context.graphQLStore.mutate(
            mutation: UpdateProgressJournalGoalMutation(variables: variables),
            broadcastQueryIds: [
              ProgressJournalByIdQuery(
                      variables: ProgressJournalByIdArguments(
                          id: widget.parentJournalId))
                  .operationName,
              UserProgressJournalsQuery().operationName
            ]);

        setState(() => _isLoading = false);

        if (result.hasErrors || result.data == null) {
          context.showToast(
              message: 'Sorry, there was a problem updating this goal',
              toastType: ToastType.destructive);
        } else {
          context.pop();
        }
      } else {
        context.pop();
      }
    } else {
      /// Creating
      setState(() => _isLoading = true);

      final variables = CreateProgressJournalGoalArguments(
          data: CreateProgressJournalGoalInput(
              name: _activeProgressJournalGoal.name,
              description: _activeProgressJournalGoal.description,
              deadline: _activeProgressJournalGoal.deadline,
              progressJournalGoalTags: _activeProgressJournalGoal
                  .progressJournalGoalTags
                  .map((tag) => ConnectRelationInput(id: tag.id))
                  .toList(),
              progressJournal:
                  ConnectRelationInput(id: widget.parentJournalId)));

      final result = await context.graphQLStore.mutate(
          mutation: CreateProgressJournalGoalMutation(variables: variables));

      setState(() => _isLoading = false);

      if (result.hasErrors || result.data == null) {
        context.showToast(
            message: 'Sorry, there was a problem creating this goal',
            toastType: ToastType.destructive);
      } else {
        _writeCreatedGoalToStore(result.data!.createProgressJournalGoal);
        context.pop();
      }
    }
  }

  /// We need to update the goal within the journal and then re-write the updated journal to the store.
  /// We can then broadcast new data to query observers so that UI updates.
  void _writeCreatedGoalToStore(ProgressJournalGoal goal) {
    final parentJournalData = context.graphQLStore.readDenomalized(
      '$kProgressJournalTypename:${widget.parentJournalId}',
    );

    final parentJournal = ProgressJournal.fromJson(parentJournalData);
    parentJournal.progressJournalGoals.add(goal);

    context.graphQLStore.writeDataToStore(
      data: parentJournal.toJson(),
      broadcastQueryIds: [
        ProgressJournalByIdQuery(
                variables:
                    ProgressJournalByIdArguments(id: widget.parentJournalId))
            .operationName,
        UserProgressJournalsQuery().operationName
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          middle: NavBarTitle(_isEditing ? 'Update Goal' : 'Add Goal'),
          trailing: AnimatedSwitcher(
            duration: kStandardAnimationDuration,
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      LoadingDots(size: 12),
                    ],
                  )
                : NavBarSaveButton(() => _handleSave(context)),
          )),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              UserInputContainer(
                child: EditableTextFieldRow(
                    title: 'Name',
                    text: _activeProgressJournalGoal.name,
                    onSave: _updateName,
                    validationMessage: 'Min 3, max 30 characters',
                    maxChars: 30,
                    inputValidation: (t) => t.length > 3 && t.length < 31),
              ),
              UserInputContainer(
                child: EditableTextAreaRow(
                    title: 'Description',
                    text: _activeProgressJournalGoal.description ?? '',
                    onSave: _updateDescription,
                    maxDisplayLines: 10,
                    inputValidation: (t) => true),
              ),
              UserInputContainer(
                child: DateTimePickerDisplay(
                  dateTime: _activeProgressJournalGoal.deadline,
                  saveDateTime: _updateDeadline,
                  showTime: false,
                  title: 'Deadline',
                ),
              ),
              // Allow adjusting of the completed date - but only once it has been marked completed.
              // You can not currently unmark as complete from this page.
              if (_activeProgressJournalGoal.completedDate != null)
                UserInputContainer(
                  child: DateTimePickerDisplay(
                    dateTime: _activeProgressJournalGoal.completedDate,
                    saveDateTime: _updateCompletedDate,
                    title: 'Completed On',
                    showTime: false,
                  ),
                ),
              UserInputContainer(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        MyText(
                          'Tags',
                        ),
                        InfoPopupButton(infoWidget: MyText('Info about tags'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                      child: MyText(
                        _activeProgressJournalGoal
                                .progressJournalGoalTags.isEmpty
                            ? 'No tags selected'
                            : '${_activeProgressJournalGoal.progressJournalGoalTags.length} tags selected',
                      ),
                    ),
                    QueryObserver<ProgressJournalGoalTags$Query,
                            json.JsonSerializable>(
                        key: Key(
                            'ProgressJournalGoalCreator - ${ProgressJournalGoalTagsQuery().operationName}'),
                        query: ProgressJournalGoalTagsQuery(),
                        builder: (data) {
                          final tags =
                              data.progressJournalGoalTags.reversed.toList();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: tags
                                  .map((tag) => SelectableTag(
                                        text: tag.tag,
                                        selectedColor:
                                            HexColor.fromHex(tag.hexColor),
                                        onPressed: () => _toggleSelectTag(tag),
                                        isSelected: _activeProgressJournalGoal
                                            .progressJournalGoalTags
                                            .contains(tag),
                                      ))
                                  .toList(),
                            ),
                          );
                        }),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateTextIconButton(
                    text: 'Create New Tag',
                    onPressed: () => context.push(
                        child: const ProgressJournalGoalTagsManager())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
