import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/workout_session_creator_bloc.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class WorkoutSessionCreatorPage extends StatefulWidget {
  final WorkoutSession? workoutSession;
  const WorkoutSessionCreatorPage({Key? key, this.workoutSession})
      : super(key: key);

  @override
  State<WorkoutSessionCreatorPage> createState() =>
      _WorkoutSessionCreatorPageState();
}

class _WorkoutSessionCreatorPageState extends State<WorkoutSessionCreatorPage> {
  WorkoutSessionCreatorBloc? _bloc;
  bool _creatingNewWorkoutSession = false;

  get kStandardAnimationDuration => null;

  @override
  void initState() {
    super.initState();
    if (widget.workoutSession != null) {
      _initBloc(widget.workoutSession!);
    }
  }

  void _initBloc(WorkoutSession workoutSession) {
    setState(() => _bloc = WorkoutSessionCreatorBloc(workoutSession));
  }

  /// Create a bare bones workout in the DB and add it to the store.
  Future<void> _createWorkoutSession(CreateWorkoutSessionInput input) async {
    setState(() {
      _creatingNewWorkoutSession = true;
    });

    final result = await GraphQLStore.store
        .create<CreateWorkoutSession$Mutation, CreateWorkoutSessionArguments>(
            mutation: CreateWorkoutSessionMutation(
              variables: CreateWorkoutSessionArguments(data: input),
            ),

            /// TODO.
            addRefToQueries: []);

    checkOperationResult(result, onSuccess: () {
      _initBloc(result.data!.createWorkoutSession);
    });

    setState(() {
      _creatingNewWorkoutSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? _MainUI(bloc: _bloc!)
            : _PreCreateUI(
                createWorkoutSession: _createWorkoutSession,
                creatingNewWorkoutSession: _creatingNewWorkoutSession));
  }
}

/// Edit workout UI. We land here if the user is editing an existing workout or after they have just created a new workout and have submitted required fields.
class _MainUI extends StatefulWidget {
  final WorkoutSessionCreatorBloc bloc;
  const _MainUI({Key? key, required this.bloc}) : super(key: key);

  @override
  __MainUIState createState() => __MainUIState();
}

class __MainUIState extends State<_MainUI> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkoutSessionCreatorBloc>.value(
      value: widget.bloc,
      builder: (context, _) {
        return MyPageScaffold(
          navigationBar: MyNavBar(
            withoutLeading: true,
            middle: const LeadingNavBarTitle(
              'Workout',
            ),

            /// TODO
            trailing: false
                ? const NavBarTrailingRow(
                    children: [
                      NavBarLoadingIndicator(),
                    ],
                  )
                : NavBarTertiarySaveButton(
                    context.pop,
                    text: 'Done',
                  ),
          ),
          child: Column(
            children: [
              // AnimatedSwitcher(
              //   duration: kStandardAnimationDuration,
              //   child: uploadingMedia
              //       ? Container(
              //           height: 44,
              //           alignment: Alignment.centerLeft,
              //           child: Row(
              //             children: const [
              //               SizedBox(width: 16),
              //               MyText('Uploading media, please wait...'),
              //             ],
              //           ))
              //       : Container(
              //           padding: const EdgeInsets.symmetric(horizontal: 8),
              //           width: double.infinity,
              //           child: MySlidingSegmentedControl<int>(
              //               children: const {
              //                 0: 'Info',
              //                 1: 'Structure',
              //                 2: 'Media'
              //               },
              //               updateValue: (i) =>
              //                   setState(() => _activeTabIndex = i),
              //               value: _activeTabIndex),
              //         ),
              // ),
              // Expanded(
              //   child: IndexedStack(
              //     index: _activeTabIndex,
              //     sizing: StackFit.expand,
              //     children: const [
              //       // WorkoutCreatorInfo(),
              //       // WorkoutCreatorStructure(),
              //       // WorkoutCreatorMedia()
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

/// Allows user to enter the basic info required to create a workoutSession in the DB.
/// They can also abort here if they want and nothing will be created in the DB.
class _PreCreateUI extends StatefulWidget {
  final void Function(CreateWorkoutSessionInput input) createWorkoutSession;
  final bool creatingNewWorkoutSession;
  const _PreCreateUI(
      {Key? key,
      required this.createWorkoutSession,
      required this.creatingNewWorkoutSession})
      : super(key: key);

  @override
  __PreCreateUIState createState() => __PreCreateUIState();
}

class __PreCreateUIState extends State<_PreCreateUI> {
  late CreateWorkoutSessionInput _createWorkoutSessionInput;

  @override
  void initState() {
    super.initState();
    _createWorkoutSessionInput = CreateWorkoutSessionInput(
      name: 'Session ${DateTime.now().dateString}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarTitle('New Workout'),
        trailing: widget.creatingNewWorkoutSession
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingIndicator(),
                ],
              )
            : NavBarTertiarySaveButton(
                () => widget.createWorkoutSession(_createWorkoutSessionInput),
                text: 'Create'),
      ),
      child: ListView(children: [
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Name',
            text: _createWorkoutSessionInput.name,
            onSave: (t) => setState(() => _createWorkoutSessionInput.name = t),
            inputValidation: (t) => t.length > 2 && t.length <= 50,
            maxChars: 50,
            validationMessage: 'Required. Min 3 chars. max 50',
          ),
        ),
      ]),
    );
  }
}
