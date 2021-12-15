// import 'package:flutter/cupertino.dart';
// import 'package:json_annotation/json_annotation.dart' as json;
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/indicators.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/tags.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
// import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
// import 'package:sofie_ui/components/user_input/tag_managers/progress_journal_goal_tags_manager.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/model/enum.dart';
// import 'package:sofie_ui/services/default_object_factory.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';

// class JournalGoalCreator extends StatefulWidget {
//   final JournalGoal? journalGoal;
//   const JournalGoalCreator({Key? key, this.journalGoal}) : super(key: key);

//   @override
//   _JournalGoalCreatorState createState() => _JournalGoalCreatorState();
// }

// class _JournalGoalCreatorState extends State<JournalGoalCreator> {
//   late JournalGoal _activeJournalGoal;
//   late bool _isEditing;
//   bool _isLoading = false;
//   bool _formIsDirty = false;

//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.journalGoal != null;
//     _activeJournalGoal = _isEditing
//         ? JournalGoal.fromJson(widget.journalGoal!.toJson())
//         : DefaultObjectfactory.defaultJournalGoal();
//   }

//   void _updateName(String name) => setState(() {
//         _formIsDirty = true;
//         _activeJournalGoal.name = name;
//       });

//   void _updateDescription(String description) => setState(() {
//         _formIsDirty = true;
//         _activeJournalGoal.description = description;
//       });

//   void _updateDeadline(DateTime deadline) => setState(() {
//         _formIsDirty = true;
//         _activeJournalGoal.deadline = deadline;
//       });

//   void _updateCompletedDate(DateTime completedDate) => setState(() {
//         _formIsDirty = true;
//         _activeJournalGoal.completedDate = completedDate;
//       });

//   void _toggleSelectTag(JournalGoalTag tag) => setState(() {
//         _formIsDirty = true;
//         _activeJournalGoal.journalGoalTags =
//             _activeJournalGoal.journalGoalTags.toggleItem<JournalGoalTag>(tag);
//       });

//   Future<void> _handleSave(BuildContext context) async {
//     if (_isEditing) {
//       if (_formIsDirty) {
//         setState(() => _isLoading = true);

//         final variables = UpdateJournalGoalArguments(
//             data: UpdateJournalGoalInput.fromJson(_activeJournalGoal.toJson()));

//         final result = await context.graphQLStore.mutate(
//             mutation: UpdateJournalGoalMutation(variables: variables),
//             broadcastQueryIds: [
//               ProgressJournalByIdQuery(
//                       variables: ProgressJournalByIdArguments(
//                           id: widget.parentJournalId))
//                   .operationName,
//               UserProgressJournalsQuery().operationName
//             ]);

//         setState(() => _isLoading = false);

//         if (result.hasErrors || result.data == null) {
//           context.showToast(
//               message: 'Sorry, there was a problem updating this goal',
//               toastType: ToastType.destructive);
//         } else {
//           context.pop();
//         }
//       } else {
//         context.pop();
//       }
//     } else {
//       /// Creating
//       setState(() => _isLoading = true);

//       final variables = CreateJournalGoalArguments(
//           data: CreateJournalGoalInput(
//               name: _activeJournalGoal.name,
//               description: _activeJournalGoal.description,
//               deadline: _activeJournalGoal.deadline,
//               journalGoalTags: _activeJournalGoal.journalGoalTags
//                   .map((tag) => ConnectRelationInput(id: tag.id))
//                   .toList(),
//               progressJournal:
//                   ConnectRelationInput(id: widget.parentJournalId)));

//       final result = await context.graphQLStore
//           .mutate(mutation: CreateJournalGoalMutation(variables: variables));

//       setState(() => _isLoading = false);

//       if (result.hasErrors || result.data == null) {
//         context.showToast(
//             message: 'Sorry, there was a problem creating this goal',
//             toastType: ToastType.destructive);
//       } else {
//         _writeCreatedGoalToStore(result.data!.createJournalGoal);
//         context.pop();
//       }
//     }
//   }

//   /// We need to update the goal within the journal and then re-write the updated journal to the store.
//   /// We can then broadcast new data to query observers so that UI updates.
//   void _writeCreatedGoalToStore(JournalGoal goal) {
//     final parentJournalData = context.graphQLStore.readDenomalized(
//       '$kProgressJournalTypename:${widget.parentJournalId}',
//     );

//     final parentJournal = ProgressJournal.fromJson(parentJournalData);
//     parentJournal.journalGoals.add(goal);

//     context.graphQLStore.writeDataToStore(
//       data: parentJournal.toJson(),
//       broadcastQueryIds: [
//         ProgressJournalByIdQuery(
//                 variables:
//                     ProgressJournalByIdArguments(id: widget.parentJournalId))
//             .operationName,
//         UserProgressJournalsQuery().operationName
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: MyNavBar(
//           customLeading: NavBarCancelButton(context.pop),
//           middle: NavBarTitle(_isEditing ? 'Update Goal' : 'Add Goal'),
//           trailing: AnimatedSwitcher(
//             duration: kStandardAnimationDuration,
//             child: _isLoading
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       LoadingDots(size: 12),
//                     ],
//                   )
//                 : NavBarSaveButton(() => _handleSave(context)),
//           )),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               UserInputContainer(
//                 child: EditableTextFieldRow(
//                     title: 'Name',
//                     text: _activeJournalGoal.name,
//                     onSave: _updateName,
//                     validationMessage: 'Min 3, max 30 characters',
//                     maxChars: 30,
//                     inputValidation: (t) => t.length > 3 && t.length < 31),
//               ),
//               UserInputContainer(
//                 child: EditableTextAreaRow(
//                     title: 'Description',
//                     text: _activeJournalGoal.description ?? '',
//                     onSave: _updateDescription,
//                     maxDisplayLines: 10,
//                     inputValidation: (t) => true),
//               ),
//               UserInputContainer(
//                 child: DateTimePickerDisplay(
//                   dateTime: _activeJournalGoal.deadline,
//                   saveDateTime: _updateDeadline,
//                   showTime: false,
//                   title: 'Deadline',
//                 ),
//               ),
//               // Allow adjusting of the completed date - but only once it has been marked completed.
//               // You can not currently unmark as complete from this page.
//               if (_activeJournalGoal.completedDate != null)
//                 UserInputContainer(
//                   child: DateTimePickerDisplay(
//                     dateTime: _activeJournalGoal.completedDate,
//                     saveDateTime: _updateCompletedDate,
//                     title: 'Completed On',
//                     showTime: false,
//                   ),
//                 ),
//               UserInputContainer(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         MyText(
//                           'Tags',
//                         ),
//                         InfoPopupButton(infoWidget: MyText('Info about tags'))
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0, bottom: 8),
//                       child: MyText(
//                         _activeJournalGoal.journalGoalTags.isEmpty
//                             ? 'No tags selected'
//                             : '${_activeJournalGoal.journalGoalTags.length} tags selected',
//                       ),
//                     ),
//                     QueryObserver<JournalGoalTags$Query, json.JsonSerializable>(
//                         key: Key(
//                             'JournalGoalCreator - ${JournalGoalTagsQuery().operationName}'),
//                         query: JournalGoalTagsQuery(),
//                         builder: (data) {
//                           final tags = data.journalGoalTags.reversed.toList();
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               alignment: WrapAlignment.center,
//                               children: tags
//                                   .map((tag) => SelectableTag(
//                                         text: tag.tag,
//                                         selectedColor:
//                                             HexColor.fromHex(tag.hexColor),
//                                         onPressed: () => _toggleSelectTag(tag),
//                                         isSelected: _activeJournalGoal
//                                             .journalGoalTags
//                                             .contains(tag),
//                                       ))
//                                   .toList(),
//                             ),
//                           );
//                         }),
//                   ],
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CreateTextIconButton(
//                     text: 'Create New Tag',
//                     onPressed: () =>
//                         context.push(child: const JournalGoalTagsManager())),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
