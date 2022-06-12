// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
// import 'package:sofie_ui/components/user_input/filters/screens/filters_screen_footer.dart';
// import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_body.dart';
// import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_equipment.dart';
// import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_info.dart';
// import 'package:sofie_ui/components/user_input/filters/screens/workout_filters_screen/workout_filters_moves.dart';
// import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
// import 'package:sofie_ui/services/utils.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';

// class WorkoutFiltersScreen extends StatefulWidget {
//   const WorkoutFiltersScreen({Key? key}) : super(key: key);

//   @override
//   _WorkoutFiltersScreenState createState() => _WorkoutFiltersScreenState();
// }

// class _WorkoutFiltersScreenState extends State<WorkoutFiltersScreen> {
//   int _activeTabIndex = 0;

//   void _updateTabIndex(int index) {
//     Utils.hideKeyboard(context);
//     setState(() => _activeTabIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final numActiveFilters =
//         context.select<WorkoutFiltersBloc, int>((b) => b.numActiveFilters);

//     return CupertinoPageScaffold(
//       child: SafeArea(
//         child: Column(
//           children: [
//             MySlidingSegmentedControl(
//                 value: _activeTabIndex,
//                 children: const {
//                   0: 'Info',
//                   1: 'Gear',
//                   2: 'Body',
//                   3: 'Moves',
//                 },
//                 updateValue: _updateTabIndex),
//             Expanded(
//                 child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IndexedStack(
//                 index: _activeTabIndex,
//                 children: const [
//                   WorkoutFiltersInfo(),
//                   WorkoutFiltersEquipment(),
//                   WorkoutFiltersBody(),
//                   WorkoutFiltersMoves(),
//                 ],
//               ),
//             )),
//             FiltersScreenFooter(
//               numActiveFilters: numActiveFilters,
//               clearFilters: () =>
//                   context.read<WorkoutFiltersBloc>().clearAllFilters(),
//               showResults: context.pop,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
