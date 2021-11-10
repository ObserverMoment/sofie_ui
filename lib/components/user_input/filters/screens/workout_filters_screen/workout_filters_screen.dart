import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_body.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_equipment.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_info.dart';
import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_moves.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:provider/provider.dart';

class WorkoutFiltersScreen extends StatefulWidget {
  const WorkoutFiltersScreen({Key? key}) : super(key: key);

  @override
  _WorkoutFiltersScreenState createState() => _WorkoutFiltersScreenState();
}

class _WorkoutFiltersScreenState extends State<WorkoutFiltersScreen> {
  int _activeTabIndex = 0;

  void _updateTabIndex(int index) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final numActiveFilters =
        context.select<WorkoutFiltersBloc, int>((b) => b.numActiveFilters);

    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarChevronDownButton(context.pop),
        middle: numActiveFilters > 0
            ? FadeIn(child: NavBarTitle('$numActiveFilters active'))
            : null,
        trailing: TertiaryButton(
            disabled: numActiveFilters == 0,
            text: 'Clear All',
            onPressed: () =>
                context.read<WorkoutFiltersBloc>().clearAllFilters()),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: MyTabBarNav(
                titles: const ['Info', 'Equipment', 'Body Areas', 'Moves'],
                handleTabChange: _updateTabIndex,
                activeTabIndex: _activeTabIndex),
          ),
          Expanded(
              child: IndexedStack(
            index: _activeTabIndex,
            children: const [
              WorkoutFiltersInfo(),
              WorkoutFiltersEquipment(),
              WorkoutFiltersBody(),
              WorkoutFiltersMoves(),
            ],
          ))
        ],
      ),
    );
  }
}
