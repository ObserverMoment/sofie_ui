import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/workout_plan_creator_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator_media.dart';
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator_info.dart';
import 'package:sofie_ui/components/creators/workout_plan_creator/workout_plan_creator_structure.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/content_access_scope_selector.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class WorkoutPlanCreatorPage extends StatefulWidget {
  final WorkoutPlan? workoutPlan;
  const WorkoutPlanCreatorPage({Key? key, this.workoutPlan}) : super(key: key);

  @override
  State<WorkoutPlanCreatorPage> createState() => _WorkoutPlanCreatorPageState();
}

class _WorkoutPlanCreatorPageState extends State<WorkoutPlanCreatorPage> {
  WorkoutPlanCreatorBloc? _bloc;
  bool _creatingNewWorkoutPlan = false;

  @override
  void initState() {
    super.initState();
    if (widget.workoutPlan != null) {
      _initBloc(widget.workoutPlan!);
    }
  }

  void _initBloc(WorkoutPlan workoutPlan) {
    setState(() => _bloc = WorkoutPlanCreatorBloc(context, workoutPlan));
  }

  /// Create a bare bones plan in the DB and add it to the store.
  Future<void> _createWorkoutPlan(CreateWorkoutPlanInput input) async {
    setState(() {
      _creatingNewWorkoutPlan = true;
    });

    final result = await GraphQLStore.store
        .create<CreateWorkoutPlan$Mutation, CreateWorkoutPlanArguments>(
            mutation: CreateWorkoutPlanMutation(
                variables: CreateWorkoutPlanArguments(data: input)),
            processResult: (data) {
              // The WorkoutPlanSummary gets immediately added to the userWorkoutPlans query when a workout is created.
              // GraphQLStore.store.writeDataToStore(
              //     data: data.createWorkoutPlan.summary.toJson(),
              //     addRefToQueries: [GQLOpNames.userWorkoutPlans]);
            });

    checkOperationResult(result, onSuccess: () {
      // Only the [UserSummary] sub object is returned by the create resolver.
      // Add these other fields manually to avoid [fromJson] throwing an error.
      _initBloc(result.data!.createWorkoutPlan);
    });

    setState(() {
      _creatingNewWorkoutPlan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? _MainUI(bloc: _bloc!)
            : _PreCreateUI(
                createWorkoutPlan: _createWorkoutPlan,
                creatingNewWorkoutPlan: _creatingNewWorkoutPlan));
  }
}

/// Edit workoutPlan UI. We land here if the user is editing an existing plan or after they have just created a new plan via pre-create UI.
class _MainUI extends StatefulWidget {
  final WorkoutPlanCreatorBloc bloc;
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
    return ChangeNotifierProvider<WorkoutPlanCreatorBloc>.value(
      value: widget.bloc,
      builder: (context, _) {
        final bool uploadingMedia = context
            .select<WorkoutPlanCreatorBloc, bool>((b) => b.uploadingMedia);

        return MyPageScaffold(
          navigationBar: MyNavBar(
            automaticallyImplyLeading: false,
            middle: const LeadingNavBarTitle(
              'Plan',
            ),
            trailing: uploadingMedia
                ? const NavBarTrailingRow(
                    children: [
                      NavBarLoadingIndicator(),
                    ],
                  )
                : NavBarTertiarySaveButton(
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
                            value: _activeTabIndex,
                            children: const {
                              0: 'Info',
                              1: 'Structure',
                              2: 'Media'
                            },
                            updateValue: (i) =>
                                setState(() => _activeTabIndex = i)),
                      ),
              ),
              Expanded(
                  child: IndexedStack(
                index: _activeTabIndex,
                sizing: StackFit.expand,
                children: const [
                  WorkoutPlanCreatorInfo(),
                  WorkoutPlanCreatorStructure(),
                  WorkoutPlanCreatorMedia(),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}

/// Allows user to enter the basic info required to create a workout in the DB.
/// They can also abort here if they want and no workout will be created in the DB.
class _PreCreateUI extends StatefulWidget {
  final void Function(CreateWorkoutPlanInput input) createWorkoutPlan;
  final bool creatingNewWorkoutPlan;
  const _PreCreateUI(
      {Key? key,
      required this.createWorkoutPlan,
      required this.creatingNewWorkoutPlan})
      : super(key: key);

  @override
  __PreCreateUIState createState() => __PreCreateUIState();
}

class __PreCreateUIState extends State<_PreCreateUI> {
  late CreateWorkoutPlanInput _createWorkoutPlanInput;

  @override
  void initState() {
    super.initState();
    _createWorkoutPlanInput = CreateWorkoutPlanInput(
        name: 'Plan ${DateTime.now().dateString}',
        contentAccessScope: ContentAccessScope.private);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: const NavBarTitle('New Plan'),
        trailing: widget.creatingNewWorkoutPlan
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingIndicator(),
                ],
              )
            : NavBarTertiarySaveButton(
                () => widget.createWorkoutPlan(_createWorkoutPlanInput),
                text: 'Create'),
      ),
      child: ListView(children: [
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Name',
            text: _createWorkoutPlanInput.name,
            onSave: (t) => setState(() => _createWorkoutPlanInput.name = t),
            inputValidation: (t) => t.length > 2 && t.length <= 50,
            maxChars: 50,
            validationMessage: 'Required. Min 3 chars. max 50',
          ),
        ),
        ContentAccessScopeSelector(
            contentAccessScope: _createWorkoutPlanInput.contentAccessScope,
            updateContentAccessScope: (scope) => setState(
                () => _createWorkoutPlanInput.contentAccessScope = scope)),
      ]),
    );
  }
}
