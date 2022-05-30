import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/tags_editor.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/workout_session_creator_bloc.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

enum WorkoutSessionType {
  amrap,
  resistance,
  cardio,
  interval,
  fortime,
  mobility
}

/// Edit workout UI. We land here if the user is editing an existing workout or after they have just created a new workout and have submitted required fields.
class WorkoutSessionEdit extends StatelessWidget {
  final WorkoutSessionCreatorBloc bloc;
  const WorkoutSessionEdit({Key? key, required this.bloc}) : super(key: key);

  Widget _buildSectionCardByType(dynamic section) {
    switch (section.runtimeType) {
      case ResistanceSession:
        return Card(child: MyText('Resistance'));
      case CardioSession:
        return Card(child: MyText('Cardio'));
      case AmrapSession:
        return Card(child: MyText('Amrap'));
      case ForTimeSession:
        return Card(child: MyText('ForTime'));
      case IntervalSession:
        return Card(child: MyText('Interval'));
      case MobilitySession:
        return Card(child: MyText('Mobility'));
      default:
        throw new Exception(
            'WorkoutSessionEdit._buildSectionCardByType: No builder defined for type: ${section.runtimeType}');
    }
  }

  void _openSectionTypeSelector(BuildContext context) {
    openBottomSheetMenu(
        context: context,
        child: BottomSheetMenu(
            header: const BottomSheetMenuHeader(name: 'Select Session Type'),
            items: [
              BottomSheetMenuItem(text: 'Cardio', onPressed: () {}),
              BottomSheetMenuItem(text: 'Resistance', onPressed: () => {}),
              BottomSheetMenuItem(text: 'Interval', onPressed: () => {}),
              BottomSheetMenuItem(text: 'Mobility', onPressed: () => {}),
              BottomSheetMenuItem(text: 'AMRAP', onPressed: () => {}),
              BottomSheetMenuItem(text: 'For Time', onPressed: () => {}),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final workoutSessionId = bloc.workoutSessionId;
    final workoutSessionByIdQuery = WorkoutSessionByIdQuery(
        variables: WorkoutSessionByIdArguments(id: workoutSessionId));

    return QueryObserver<WorkoutSessionById$Query, WorkoutSessionByIdArguments>(
        key: Key(
            'WorkoutSessionEdit - ${workoutSessionByIdQuery.operationName}-$workoutSessionId'),
        query: workoutSessionByIdQuery,
        parameterizeQuery: true,
        builder: (data) {
          final workoutSession = data.workoutSessionById!;

          final allSections = [
            ...workoutSession.resistanceSessions,
            ...workoutSession.cardioSessions,
            ...workoutSession.amrapSessions,
            ...workoutSession.forTimeSessions,
            ...workoutSession.intervalSessions,
            ...workoutSession.mobilitySessions
          ];

          final sortedSectionCards = workoutSession.sessionOrder
              .map((id) => _buildSectionCardByType(
                  allSections.firstWhere((s) => (s as ObjWithId).id == id)))
              .toList();

          return MyPageScaffold(
            navigationBar: MyNavBar(
              withoutLeading: true,
              middle: const LeadingNavBarTitle(
                'Workout Session',
              ),
              trailing: NavBarTrailingRow(
                children: [
                  NavBarCancelButton(
                    () => print('check exit without saving'),
                    color: Styles.errorRed,
                  ),
                  NavBarSaveButton(
                    context.pop,
                  ),
                ],
              ),
            ),
            child: FABPage(
              rowButtons: [
                FloatingButton(
                    icon: CupertinoIcons.add,
                    text: 'Add Section',
                    onTap: () => _openSectionTypeSelector(context))
              ],
              child: ListView(
                children: [
                  UserInputContainer(
                    child: EditableTextFieldRow(
                      title: 'Name',
                      text: workoutSession.name,
                      onSave: (text) =>
                          bloc.updateWorkoutSession({'name': text}),
                      inputValidation: (t) => t.length > 2 && t.length <= 50,
                      maxChars: 50,
                      validationMessage: 'Required. Min 3 chars. max 50',
                    ),
                  ),
                  UserInputContainer(
                    child: EditableTextAreaRow(
                      title: 'Description',
                      text: workoutSession.description ?? '',
                      onSave: (text) =>
                          bloc.updateWorkoutSession({'description': text}),
                      inputValidation: (t) => true,
                    ),
                  ),
                  UserInputContainer(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TagsEditor(
                            tags: workoutSession.tags,
                            updateTags: (tags) =>
                                bloc.updateWorkoutSession({'tags': tags}),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ImageUploader(
                          emptyText: 'Add Cover Image',
                          displaySize: const Size(140, 140),
                          imageUri: workoutSession.coverImageUri,
                          emptyThumbIcon: CupertinoIcons.photo,
                          onUploadSuccess: (coverImageUri) => bloc
                              .updateWorkoutSession(
                                  {'coverImageUri': coverImageUri}),
                          removeImage: (_) => bloc
                              .updateWorkoutSession({'coverImageUri': null}),
                        ),
                      ],
                    ),
                  ),
                  ...sortedSectionCards
                ],
              ),
            ),
          );
        });
  }
}

class ObjWithId {
  final String id;
  ObjWithId(this.id);
}
