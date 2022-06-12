// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
// import 'package:implicitly_animated_reorderable_list/transitions.dart';
// import 'package:provider/provider.dart';
// import 'package:sofie_ui/blocs/workout_creator_bloc.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/add_workout_section.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_section_creator/workout_section_creator.dart';
// import 'package:sofie_ui/components/creators/workout_creator/workout_structure_creator/workout_structure_workout_section_card.dart';
// import 'package:sofie_ui/components/fab_page.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';

// class WorkoutCreatorStructure extends StatelessWidget {
//   const WorkoutCreatorStructure({Key? key}) : super(key: key);

//   Future<void> _openCreateSection(BuildContext context, WorkoutCreatorBloc bloc,
//       int nextSortPosition) async {
//     await context.push(
//         fullscreenDialog: true,
//         child: AddWorkoutSection(
//           sortPosition: nextSortPosition,
//           addWorkoutSection: bloc.createWorkoutSection,
//         ));
//   }

//   void _openEditSection(
//       BuildContext context, WorkoutCreatorBloc bloc, int sectionIndex) {
//     // https://stackoverflow.com/questions/57598029/how-to-pass-provider-with-navigator
//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//         builder: (context) => ChangeNotifierProvider<WorkoutCreatorBloc>.value(
//           value: bloc,
//           child: WorkoutSectionCreator(
//               key: Key(sectionIndex.toString()), sectionIndex: sectionIndex),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// Using [watch] rather than [select] Almost all updates will required this widget to rebuild so we are not worrying about select filtering on the rebuilds.
//     final bloc = context.watch<WorkoutCreatorBloc>();
//     final sortedworkoutSections =
//         bloc.workout.workoutSections.sortedBy<num>((ws) => ws.sortPosition);

//     return FABPage(
//       rowButtons: [
//         FloatingButton(
//             text: 'Add Section',
//             icon: CupertinoIcons.add,
//             onTap: () =>
//                 _openCreateSection(context, bloc, sortedworkoutSections.length))
//       ],
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 10.0,
//         ),
//         child: sortedworkoutSections.isEmpty
//             ? Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   children: const [
//                     Opacity(
//                         opacity: 0.5,
//                         child: Icon(
//                           CupertinoIcons.square_list,
//                           size: 50,
//                         )),
//                     SizedBox(height: 12),
//                     MyText(
//                       'No sections defined yet...',
//                       subtext: true,
//                     ),
//                   ],
//                 ),
//               )
//             : ImplicitlyAnimatedList<WorkoutSection>(
//                 padding: const EdgeInsets.only(
//                     left: 4, top: 4, right: 4, bottom: 60),
//                 items: sortedworkoutSections,
//                 shrinkWrap: true,
//                 areItemsTheSame: (a, b) => a.id == b.id,
//                 itemBuilder: (context, animation, item, index) {
//                   return SizeFadeTransition(
//                     sizeFraction: 0.7,
//                     curve: Curves.easeInOut,
//                     animation: animation,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: GestureDetector(
//                         onTap: () => _openEditSection(context, bloc, index),
//                         child: WorkoutStructureWorkoutSectionCard(
//                           key: Key(item.id),
//                           workoutSection: item,
//                           index: index,
//                           canReorder: sortedworkoutSections.length > 1,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
