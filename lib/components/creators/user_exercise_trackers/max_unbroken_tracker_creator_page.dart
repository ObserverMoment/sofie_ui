import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/load_picker.dart';
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

class MaxUnbrokenTrackerCreatorPage extends StatefulWidget {
  const MaxUnbrokenTrackerCreatorPage({Key? key}) : super(key: key);

  @override
  MaxUnbrokenTrackerCreatorPageState createState() =>
      MaxUnbrokenTrackerCreatorPageState();
}

class MaxUnbrokenTrackerCreatorPageState
    extends State<MaxUnbrokenTrackerCreatorPage> {
  bool _loading = false;

  LoadUnit _loadUnit = LoadUnit.kg;
  DistanceUnit _distanceUnit = DistanceUnit.metres;
  Move? _move;
  Equipment? _equipment;
  double _loadAmount = 0;
  WorkoutMoveRepType? _repType;

  Future<void> _createMaxUnbrokenTracker() async {
    if (!_validToSave) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final variables = CreateUserMaxUnbrokenExerciseTrackerArguments(
        data: CreateUserMaxUnbrokenExerciseTrackerInput(
            loadAmount: _loadAmount,
            loadUnit: _loadUnit,
            move: ConnectRelationInput(id: _move!.id),
            equipment: _equipment != null
                ? ConnectRelationInput(id: _equipment!.id)
                : null,
            repType: _repType!,
            distanceUnit: _distanceUnit));

    final result = await context.graphQLStore.create(
        mutation:
            CreateUserMaxUnbrokenExerciseTrackerMutation(variables: variables),
        addRefToQueries: [GQLOpNames.userMaxUnbrokenExerciseTrackers]);

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
          selectMove: (m) {
            setState(() {
              _move = m;
              _repType = m.validRepTypes.contains(_repType)
                  ? _repType
                  : m.validRepTypes[0];
            });
            context.pop();
          },
          onCancel: context.pop));

  bool get _validToSave => _move != null && _repType != null;

  @override
  Widget build(BuildContext context) {
    final showLoadPicker = (_equipment != null && _equipment!.loadAdjustable) ||
        (_move != null &&
            _move!.requiredEquipments.any((e) => e.loadAdjustable));

    return MyPageScaffold(
      navigationBar: CreateEditNavBarSimple(
        loading: _loading,
        onSave: _createMaxUnbrokenTracker,
        title: 'Max Unbroken Tracker',
        validToSave: _validToSave,
        onCancel: context.pop,
      ),
      child: _move == null
          ? YourContentEmptyPlaceholder(
              message: 'Max Unbroken Scores!',
              explainer:
                  'Specify exercise, distance, time or reps, and any equipment. For e.g. "Max unbroken pull ups, max time plank hold, max unbroken double under"',
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
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Column(
                  children: [
                    const MyText('Log score as'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MySlidingSegmentedControl<WorkoutMoveRepType>(
                            value: _repType,
                            fontSize: 15,
                            containerPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            childPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
                            children: {
                              for (final repType in _move!.validRepTypes)
                                repType: repType.display
                            },
                            updateValue: (repType) =>
                                setState(() => _repType = repType)),
                      ],
                    ),
                    GrowInOut(
                        show: _repType == WorkoutMoveRepType.distance,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MySlidingSegmentedControl<DistanceUnit>(
                                  value: _distanceUnit,
                                  fontSize: 14,
                                  containerPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 2),
                                  childPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2),
                                  children: {
                                    for (final unit in DistanceUnit.values
                                        .where((v) =>
                                            v != DistanceUnit.artemisUnknown)
                                        .toList())
                                      unit: unit.display
                                  },
                                  updateValue: (distanceUnit) => setState(
                                      () => _distanceUnit = distanceUnit)),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              if (_move!.selectableEquipments.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
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
              if (showLoadPicker)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GrowIn(
                          child: LoadPickerDisplay(
                              loadAmount: _loadAmount,
                              updateLoad: (loadAmount, loadUnit) =>
                                  setState(() {
                                    _loadAmount = loadAmount;
                                    _loadUnit = loadUnit;
                                  }),
                              loadUnit: _loadUnit)),
                    ],
                  ),
                ),
            ]),
    );
  }
}
