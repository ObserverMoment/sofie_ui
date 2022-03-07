import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/move_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/my_studio/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/data_utils.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class MaxLoadTrackerCreatorPage extends StatefulWidget {
  const MaxLoadTrackerCreatorPage({Key? key}) : super(key: key);

  @override
  MaxLoadTrackerCreatorPageState createState() =>
      MaxLoadTrackerCreatorPageState();
}

class MaxLoadTrackerCreatorPageState extends State<MaxLoadTrackerCreatorPage> {
  bool _loading = false;

  LoadUnit _loadUnit = LoadUnit.kg;
  Move? _move;
  Equipment? _equipment;
  final _repsInputController = TextEditingController(text: '1');
  int _reps = 1;

  @override
  void initState() {
    super.initState();
    _repsInputController.addListener(() {
      setState(() {
        _reps = int.parse(_repsInputController.text);
      });
    });
  }

  Future<void> _createMaxLoadTracker() async {
    if (_move == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final variables = CreateUserMaxLoadExerciseTrackerArguments(
        data: CreateUserMaxLoadExerciseTrackerInput(
            loadUnit: _loadUnit,
            move: ConnectRelationInput(id: _move!.id),
            reps: _reps,
            equipment: _equipment != null
                ? ConnectRelationInput(id: _equipment!.id)
                : null));

    final result = await context.graphQLStore.create(
        mutation:
            CreateUserMaxLoadExerciseTrackerMutation(variables: variables),
        addRefToQueries: [GQLOpNames.userMaxLoadExerciseTrackers]);

    checkOperationResult(context, result, onSuccess: () {
      setState(() {
        _loading = true;
      });
      context.pop();
    }, onFail: () {
      setState(() {
        _loading = false;
      });
    });
  }

  void _selectMove() => context.push(
      child: MoveSelector(
          customFilter: (movesList) => movesList
              .where((m) =>
                  m.validRepTypes.contains(WorkoutMoveRepType.reps) &&
                  [...m.requiredEquipments, ...m.selectableEquipments]
                      .any((e) => e.loadAdjustable))
              .toList(),
          selectMove: (m) {
            setState(() {
              _move = m;
            });
            context.pop();
          },
          onCancel: context.pop));

  bool get _validToSave => _move != null;

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: CreateEditNavBarSimple(
        loading: _loading,
        onSave: _createMaxLoadTracker,
        title: 'Max Lift Tracker',
        validToSave: _validToSave,
        onCancel: context.pop,
      ),
      child: _move == null
          ? YourContentEmptyPlaceholder(
              message: 'Track progress over time for your lifts!',
              explainer:
                  'Specify move, equipment and number of reps. For e.g. "3 Reps of Bench Press with Barbell". Anything that you log during a workout will be automatically submitted!',
              showIcon: false,
              actions: [
                  EmptyPlaceholderAction(
                      action: _selectMove,
                      buttonIcon: CupertinoIcons.add,
                      buttonText: 'Select Move'),
                ])
          : ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: MyHeaderText(_move!.name)),
                  const SizedBox(
                    width: 16,
                  ),
                  TertiaryButton(
                      prefixIconData: CupertinoIcons.arrow_left_right,
                      text: 'Change',
                      onPressed: _selectMove)
                ],
              ),
              if (_move!.selectableEquipments.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: MyText('Select one from',
                            color: _equipment == null ? Styles.errorRed : null,
                            lineHeight: 1.4),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: DataUtils.sortEquipmentsWithBodyWeightFirst(
                                _move!.selectableEquipments)
                            .map((e) => SizedBox(
                                  height: 86,
                                  width: 86,
                                  child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _equipment = e),
                                      child: EquipmentTile(
                                          showIcon: true,
                                          equipment: e,
                                          withBorder: false,
                                          fontSize: FONTSIZE.two,
                                          isSelected: _equipment == e)),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
                child: Column(
                  children: [
                    const MyText('How Many Reps?'),
                    const SizedBox(height: 12),
                    MyNumberInput(
                      _repsInputController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: Column(
                  children: [
                    const MyText('Log lift scores in'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MySlidingSegmentedControl<LoadUnit>(
                            value: _loadUnit,
                            fontSize: 15,
                            containerPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            childPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
                            children: {
                              LoadUnit.kg: LoadUnit.kg.display,
                              LoadUnit.lb: LoadUnit.lb.display,
                            },
                            updateValue: (loadUnit) =>
                                setState(() => _loadUnit = loadUnit)),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
    );
  }
}
