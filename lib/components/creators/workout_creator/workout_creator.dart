import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_media.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_info.dart';
import 'package:sofie_ui/components/creators/workout_creator/workout_creator_structure/workout_creator_structure.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/content_access_scope_selector.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutCreatorPage extends StatefulWidget {
  /// For use when editing or duplicating a workout.
  final Workout? workout;
  const WorkoutCreatorPage({Key? key, this.workout}) : super(key: key);

  @override
  _WorkoutCreatorPageState createState() => _WorkoutCreatorPageState();
}

class _WorkoutCreatorPageState extends State<WorkoutCreatorPage> {
  WorkoutCreatorBloc? _bloc;
  bool _creatingNewWorkout = false;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _initBloc(widget.workout!);
    }
  }

  void _initBloc(Workout workout) {
    setState(() => _bloc = WorkoutCreatorBloc(context, workout));
  }

  /// Create a bare bones workout in the DB and add it to the store.
  Future<void> _createWorkout(CreateWorkoutInput input) async {
    setState(() {
      _creatingNewWorkout = true;
    });

    final result = await context.graphQLStore
        .create<CreateWorkout$Mutation, CreateWorkoutArguments>(
      mutation:
          CreateWorkoutMutation(variables: CreateWorkoutArguments(data: input)),
      processResult: (data) {
        // The WorkoutSummary gets immediately added to the userWorkouts query when a workout is created.
        context.graphQLStore.writeDataToStore(
            data: data.createWorkout.summary.toJson(),
            addRefToQueries: [GQLOpNames.userWorkouts]);
      },
    );

    checkOperationResult(context, result, onSuccess: () {
      _initBloc(result.data!.createWorkout);
    });

    setState(() {
      _creatingNewWorkout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? _MainUI(bloc: _bloc!)
            : _PreCreateUI(
                createWorkout: _createWorkout,
                creatingNewWorkout: _creatingNewWorkout));
  }
}

/// Allows user to enter the basic info required to create a workout in the DB.
/// They can also abort here if they want and no workout will be created in the DB.
class _PreCreateUI extends StatefulWidget {
  final void Function(CreateWorkoutInput input) createWorkout;
  final bool creatingNewWorkout;
  const _PreCreateUI(
      {Key? key, required this.createWorkout, required this.creatingNewWorkout})
      : super(key: key);

  @override
  __PreCreateUIState createState() => __PreCreateUIState();
}

class __PreCreateUIState extends State<_PreCreateUI> {
  late CreateWorkoutInput _createWorkoutInput;

  @override
  void initState() {
    super.initState();
    _createWorkoutInput = CreateWorkoutInput(
        name: 'Workout ${DateTime.now().dateString}',
        contentAccessScope: ContentAccessScope.private);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarTitle('New Workout'),
        trailing: widget.creatingNewWorkout
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingIndicator(),
                ],
              )
            : NavBarSaveButton(() => widget.createWorkout(_createWorkoutInput),
                text: 'Create'),
      ),
      child: ListView(children: [
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Name',
            text: _createWorkoutInput.name,
            onSave: (t) => setState(() => _createWorkoutInput.name = t),
            inputValidation: (t) => t.length > 2 && t.length <= 50,
            maxChars: 50,
            validationMessage: 'Required. Min 3 chars. max 50',
          ),
        ),
        ContentAccessScopeSelector(
            contentAccessScope: _createWorkoutInput.contentAccessScope,
            updateContentAccessScope: (scope) =>
                setState(() => _createWorkoutInput.contentAccessScope = scope)),
      ]),
    );
  }
}

/// Edit workout UI. We land here if the user is editing an existing workout or after they have just created a new workout and have submitted required fields.
class _MainUI extends StatefulWidget {
  final WorkoutCreatorBloc bloc;
  const _MainUI({Key? key, required this.bloc}) : super(key: key);

  @override
  __MainUIState createState() => __MainUIState();
}

class __MainUIState extends State<_MainUI> {
  int _activeTabIndex = 0;

  void _saveAndClose() {
    final success = widget.bloc.saveAllChanges();

    if (success) {
      context.pop();
    } else {
      context.showErrorAlert(
        'Sorry, there was an issue saving!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkoutCreatorBloc>.value(
      value: widget.bloc,
      builder: (context, _) {
        final bool uploadingMedia =
            context.select<WorkoutCreatorBloc, bool>((b) => b.uploadingMedia);
        final bool creatingSection =
            context.select<WorkoutCreatorBloc, bool>((b) => b.creatingSection);
        final bool creatingSet =
            context.select<WorkoutCreatorBloc, bool>((b) => b.creatingSet);
        final bool creatingMove =
            context.select<WorkoutCreatorBloc, bool>((b) => b.creatingMove);

        return MyPageScaffold(
          navigationBar: MyNavBar(
            withoutLeading: true,
            middle: const LeadingNavBarTitle(
              'Workout',
            ),
            trailing:
                uploadingMedia || creatingSection || creatingSet || creatingMove
                    ? const NavBarTrailingRow(
                        children: [
                          NavBarLoadingIndicator(),
                        ],
                      )
                    : NavBarSaveButton(
                        _saveAndClose,
                        text: 'Done',
                      ),
          ),
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: uploadingMedia
                    ? Container(
                        height: 44,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            SizedBox(width: 16),
                            MyText('Uploading media, please wait...'),
                          ],
                        ))
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        child: MySlidingSegmentedControl<int>(
                            children: const {
                              0: 'Info',
                              1: 'Structure',
                              2: 'Media'
                            },
                            updateValue: (i) =>
                                setState(() => _activeTabIndex = i),
                            value: _activeTabIndex),
                      ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _activeTabIndex,
                  sizing: StackFit.expand,
                  children: const [
                    WorkoutCreatorInfo(),
                    WorkoutCreatorStructure(),
                    WorkoutCreatorMedia()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
