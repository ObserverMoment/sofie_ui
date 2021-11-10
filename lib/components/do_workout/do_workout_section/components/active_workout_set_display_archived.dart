// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/workout/workout_set_minimal_display.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';

// /// Based on the current state for [sectionIndex] section, which set is the user doing, or about to do.
// /// See future sets via [offset]. "Next Set" offset would be 1.
// class ActiveSetDisplay extends StatelessWidget {
//   final int sectionIndex;
//   final int offset;
//   final WorkoutSectionType workoutSectionType;
//   const ActiveSetDisplay(
//       {Key? key,
//       required this.sectionIndex,
//       required this.offset,
//       required this.workoutSectionType})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final workoutSet = context.select<DoWorkoutBloc, WorkoutSet?>(
//         (b) => b.getNowAndNextSetsForSection(sectionIndex, offset));

//     return FadeIn(
//       key: Key(workoutSet?.id ?? 'finished'),
//       child: workoutSet != null
//           ? WorkoutSetMinimalDisplay(
//               backgroundColor: context.theme.cardBackground.withOpacity(0.6),
//               workoutSet: workoutSet,
//               workoutSectionType: workoutSectionType,
//               elevation: 0,
//             )
//           : const ContentBox(child: MyHeaderText('Finish')),
//     );
//   }
// }
