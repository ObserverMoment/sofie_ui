// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/components/body_areas/body_area_selectors.dart';
// import 'package:sofie_ui/components/user_input/filters/blocs/workout_filters_bloc.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';

// class WorkoutFiltersBody extends StatefulWidget {
//   const WorkoutFiltersBody({Key? key}) : super(key: key);

//   @override
//   _WorkoutFiltersBodyState createState() => _WorkoutFiltersBodyState();
// }

// class _WorkoutFiltersBodyState extends State<WorkoutFiltersBody> {
//   final kBodyGraphicHeight = 420.0;

//   @override
//   Widget build(BuildContext context) {
//     final targetedBodyAreas =
//         context.select<WorkoutFiltersBloc, List<BodyArea>>(
//             (b) => b.filters.targetedBodyAreas);

//     return BodyAreaSelectorFrontBackPaged(
//       bodyGraphicHeight: kBodyGraphicHeight,
//       handleTapBodyArea: (b) =>
//           context.read<WorkoutFiltersBloc>().updateFilters({
//         'targetedBodyAreas':
//             targetedBodyAreas.toggleItem(b).map((b) => b.toJson()).toList()
//       }),
//       selectedBodyAreas: targetedBodyAreas,
//     );
//   }
// }
