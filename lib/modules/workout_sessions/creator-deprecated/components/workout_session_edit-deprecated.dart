// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/fab_page.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/media/images/image_uploader.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
// import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
// import 'package:sofie_ui/components/user_input/tags_editor.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/model/enum.dart';
// import 'package:sofie_ui/modules/workout_session/creator/resistance/display/resistance_session_summary_display.dart';
// import 'package:sofie_ui/modules/workout_session/creator/resistance/edit/resistance_session_edit.dart';
// import 'package:sofie_ui/modules/workout_session/creator/blocs/workout_session_bloc.dart';
// import 'package:sofie_ui/services/store/query_observer.dart';

// enum WorkoutSessionType {
//   amrap,
//   resistance,
//   cardio,
//   interval,
//   fortime,
//   mobility
// }

// /// Edit workout UI. We land here if the user is editing an existing workout or after they have just created a new workout and have submitted required fields.
// class WorkoutSessionEdit extends StatelessWidget {
//   final WorkoutSessionBloc bloc;
//   const WorkoutSessionEdit({Key? key, required this.bloc}) : super(key: key);

//   Widget _buildSectionCardByType(
//       BuildContext context, WorkoutSession workoutSession, dynamic section) {
//     switch (section.runtimeType) {
//       case ResistanceSession:
//         return GestureDetector(
//             onTap: () => context.push(
//                     child: ResistanceSessionEdit(
//                   resistanceSession: section,
//                   workoutSessionId: bloc.workoutSessionId,
//                 )),
//             child: ResistanceSessionSummaryDisplay(
//                 resistanceSession: section,
//                 workoutSession: workoutSession,
//                 workoutSessionBloc: bloc));
//       case CardioSession:
//         return Card(child: MyText('Cardio'));
//       case AmrapSession:
//         return Card(child: MyText('Amrap'));
//       case ForTimeSession:
//         return Card(child: MyText('ForTime'));
//       case IntervalSession:
//         return Card(child: MyText('Interval'));
//       case MobilitySession:
//         return Card(child: MyText('Mobility'));
//       default:
//         throw Exception(
//             'WorkoutSessionEdit._buildSectionCardByType: No builder defined for type: ${section.runtimeType}');
//     }
//   }

//   void _showErrorToast(BuildContext context) => context.showToast(
//       message: kDefaultErrorMessage, toastType: ToastType.destructive);

//   void _openSectionTypeSelector(
//       BuildContext context, WorkoutSession workoutSession) {
//     openBottomSheetMenu(
//         context: context,
//         child: BottomSheetMenu(
//             header: const BottomSheetMenuHeader(name: 'Select Session Type'),
//             items: [
//               BottomSheetMenuItem(text: 'Cardio', onPressed: () {}),
//               BottomSheetMenuItem(
//                   text: 'Resistance',
//                   onPressed: () => bloc.createResistanceSession(
//                       workoutSession: workoutSession,
//                       onFail: () => _showErrorToast(context),
//                       onSuccess: (created) => context.push(
//                               child: ResistanceSessionEdit(
//                             resistanceSession: created,
//                             workoutSessionId: bloc.workoutSessionId,
//                           )))),
//               BottomSheetMenuItem(text: 'Interval', onPressed: () => {}),
//               BottomSheetMenuItem(text: 'Mobility', onPressed: () => {}),
//               BottomSheetMenuItem(text: 'AMRAP', onPressed: () => {}),
//               BottomSheetMenuItem(text: 'For Time', onPressed: () => {}),
//             ]));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final workoutSessionId = bloc.workoutSessionId;
//     final workoutSessionByIdQuery = WorkoutSessionByIdQuery(
//         variables: WorkoutSessionByIdArguments(id: workoutSessionId));

//     return QueryObserver<WorkoutSessionById$Query, WorkoutSessionByIdArguments>(
//         key: Key(
//             'WorkoutSessionEdit - ${workoutSessionByIdQuery.operationName}-$workoutSessionId'),
//         query: workoutSessionByIdQuery,
//         parameterizeQuery: true,
//         builder: (data) {
//           final workoutSession = data.workoutSessionById!;

//           final allSectionsAndIds = [
//             ...workoutSession.resistanceSessions.map((s) => ([s.id, s])),
//             ...workoutSession.cardioSessions.map((s) => ([s.id, s])),
//             ...workoutSession.amrapSessions.map((s) => ([s.id, s])),
//             ...workoutSession.forTimeSessions.map((s) => ([s.id, s])),
//             ...workoutSession.intervalSessions.map((s) => ([s.id, s])),
//             ...workoutSession.mobilitySessions.map((s) => ([s.id, s])),
//           ];

//           final sortedSectionCards = workoutSession.childrenOrder
//               .map((id) => _buildSectionCardByType(context, workoutSession,
//                   allSectionsAndIds.firstWhere((s) => s[0] == id)[1]))
//               .toList();

//           return MyPageScaffold(
//             navigationBar: MyNavBar(
//               withoutLeading: true,
//               middle: const LeadingNavBarTitle(
//                 'Workout Session',
//               ),
//               trailing: NavBarSaveButton(
//                 context.pop,
//               ),
//             ),
//             child: FABPage(
//               rowButtons: [
//                 FloatingButton(
//                     icon: CupertinoIcons.add,
//                     text: 'Add Section',
//                     onTap: () =>
//                         _openSectionTypeSelector(context, workoutSession))
//               ],
//               child: FABPageList(
//                 children: [
//                   UserInputContainer(
//                     child: EditableTextFieldRow(
//                       title: 'Name',
//                       text: workoutSession.name,
//                       onSave: (text) => bloc.updateWorkoutSession(
//                           workoutSession: workoutSession, data: {'name': text}),
//                       inputValidation: (t) => t.length > 2 && t.length <= 50,
//                       maxChars: 50,
//                       validationMessage: 'Required. Min 3 chars. max 50',
//                     ),
//                   ),
//                   UserInputContainer(
//                     child: EditableTextAreaRow(
//                       title: 'Description',
//                       text: workoutSession.description ?? '',
//                       onSave: (text) => bloc.updateWorkoutSession(
//                           workoutSession: workoutSession,
//                           data: {'description': text}),
//                       inputValidation: (t) => true,
//                     ),
//                   ),
//                   UserInputContainer(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: TagsEditor(
//                             tags: workoutSession.tags,
//                             updateTags: (tags) => bloc.updateWorkoutSession(
//                                 workoutSession: workoutSession,
//                                 data: {'tags': tags}),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         ImageUploader(
//                           emptyText: 'Add Cover Image',
//                           displaySize: const Size(140, 140),
//                           imageUri: workoutSession.coverImageUri,
//                           emptyThumbIcon: CupertinoIcons.photo,
//                           onUploadSuccess: (coverImageUri) => bloc
//                               .updateWorkoutSession(
//                                   workoutSession: workoutSession,
//                                   data: {'coverImageUri': coverImageUri}),
//                           removeImage: (_) => bloc.updateWorkoutSession(
//                               workoutSession: workoutSession,
//                               data: {'coverImageUri': null}),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ...sortedSectionCards
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
