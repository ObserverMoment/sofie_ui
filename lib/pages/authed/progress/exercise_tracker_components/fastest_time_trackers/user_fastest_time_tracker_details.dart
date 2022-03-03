import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_setup_manager.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.graphql.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/exercise_trackers_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/fastest_time_trackers/user_fastest_time_manual_entry_creator.dart';
import 'package:sofie_ui/pages/authed/progress/exercise_tracker_components/max_load_tracker/user_max_load_manual_entry_creator.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class UserFastestTimeTrackerDetails extends StatelessWidget {
  final String trackerId;
  const UserFastestTimeTrackerDetails({Key? key, required this.trackerId})
      : super(key: key);

  Future<void> _confirmDeleteTracker(
      BuildContext context, UserFastestTimeExerciseTracker tracker) async {
    context.showConfirmDeleteDialog(
        message:
            'Deleting this tracker will also delete all manual entries that you have previously submitted. This cannot be undone. OK?',
        itemType: 'Score Tracker',
        onConfirm: () async {
          final result = await context.graphQLStore.delete(
              mutation: DeleteUserFastestTimeExerciseTrackerMutation(
                  variables: DeleteUserFastestTimeExerciseTrackerArguments(
                      id: tracker.id)),
              objectId: tracker.id,
              typename: kUserFastestTimeExerciseTracker,
              removeRefFromQueries: [
                GQLOpNames.userFastestTimeExerciseTrackers
              ]);

          checkOperationResult(context, result, onSuccess: context.pop);
        });
  }

  Future<void> _submitManualEntry(
      BuildContext context, UserFastestTimeExerciseTracker tracker) async {
    context.push(
        child: UserFastestTimeManualEntryCreator(
      parent: tracker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final tracker =
        context.select<ExerciseTrackersBloc, UserFastestTimeExerciseTracker?>(
            (b) => b.userFastestTimeExerciseTrackers
                .firstWhereOrNull((t) => t.id == trackerId));

    /// It has probably been deleted so this page will pop shortly.
    if (tracker == null) {
      return Container();
    }

    final trackerRelevantScores = [];

    /// TODO.

    final repString = tracker.reps == 1 ? 'rep' : 'reps';
    final equipmentString =
        tracker.equipment == null ? '' : ' - ${tracker.equipment!.name}';

    return CupertinoPageScaffold(
      navigationBar: MyNavBar(
        middle: TertiaryButton(
            prefixIconData: MyCustomIcons.medal,
            iconSize: 14,
            fontSize: FONTSIZE.three,
            onPressed: () => _submitManualEntry(context, tracker),
            text: 'Submit a Score'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash,
              size: 20,
            ),
            onPressed: () => _confirmDeleteTracker(context, tracker)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: MyHeaderText(
              tracker.move.name,
              weight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: MyHeaderText(
              '${tracker.reps} $repString$equipmentString - ${tracker.loadUnit.display}',
              size: FONTSIZE.two,
              weight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 14),
          if (trackerRelevantScores.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: MyText(
                  'No scores logged or submitted yet',
                  subtext: true,
                ),
              ),
            ),
          // if (trackerRelevantScores.isNotEmpty)
          //   Expanded(
          //     child: ListView(
          //       shrinkWrap: true,
          //       children: [
          // _MaxLiftProgressGraph(
          //   scores: trackerRelevantScores,
          //   tracker: tracker,
          // ),
          // _TopTenScoresList(
          //   tracker: tracker,
          //   scores: trackerRelevantScores,
          // ),
          // ],
          // ),
          // )
        ],
      ),
    );
  }
}

// class _MaxLiftProgressGraph extends StatelessWidget {
//   final UserFastestTimeExerciseTracker tracker;
//   final List<FastestTimeScoreWithCompletedOnDate> scores;
//   const _MaxLiftProgressGraph(
//       {Key? key, required this.tracker, required this.scores})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final gridlineColor = context.theme.primary.withOpacity(0.07);
//     final labelStyle = TextStyle(color: context.theme.primary, fontSize: 10);

//     return Container(
//       width: MediaQuery.of(context).size.width * 0.6,
//       padding: const EdgeInsets.only(right: 10.0),
//       child: SfCartesianChart(
//           enableAxisAnimation: false,
//           plotAreaBorderWidth: 0,
//           zoomPanBehavior: ZoomPanBehavior(
//               zoomMode: ZoomMode.x,
//               enablePanning: true,
//               enablePinching: true,
//               enableDoubleTapZooming: true),
//           primaryYAxis: NumericAxis(
//               labelStyle: labelStyle,
//               rangePadding: ChartRangePadding.round,
//               decimalPlaces: 2,
//               majorGridLines: MajorGridLines(color: gridlineColor)),
//           primaryXAxis: DateTimeAxis(
//               labelStyle: labelStyle,
//               rangePadding: ChartRangePadding.round,
//               desiredIntervals: 6,
//               majorGridLines: MajorGridLines(color: gridlineColor)),
//           series: <ChartSeries>[
//             LineSeries<FastestTimeScoreWithCompletedOnDate, DateTime>(
//               dataSource: scores.sorted((a, b) {
//                 if (a.completedOn == b.completedOn) {
//                   return a.loadAmount.compareTo(b.loadAmount);
//                 } else {
//                   return a.completedOn.compareTo(b.completedOn);
//                 }
//               }),
//               xValueMapper: (score, _) => score.completedOn,
//               yValueMapper: (score, _) => score.loadAmount,
//               color: Styles.primaryAccent,
//             )
//           ]),
//     );
//   }
// }

// class _TopTenScoresList extends StatelessWidget {
//   final UserFastestTimeExerciseTracker tracker;
//   final List<FastestTimeScoreWithCompletedOnDate> scores;
//   const _TopTenScoresList(
//       {Key? key, required this.scores, required this.tracker})
//       : super(key: key);

//   void _confirmDeleteManualEntry(
//     BuildContext context,
//     String entryId,
//   ) {
//     context.showConfirmDeleteDialog(
//         message:
//             'This will delete the score entry and also any video that has been uploaded. Ok?',
//         itemType: 'Score Tracker Entry',
//         onConfirm: () async {
//           final result = await context.graphQLStore.mutate(
//               mutation: DeleteUserFastestTimeTrackerManualEntryMutation(
//                   variables: DeleteUserFastestTimeTrackerManualEntryArguments(
//                       entryId: entryId, parentId: tracker.id)),
//               broadcastQueryIds: [GQLOpNames.userFastestTimeExerciseTrackers]);

//           checkOperationResult(context, result);
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// TODO: FastestTimeScoreWithCompletedOnDate
//     final topTenScores = [];

//     final buttonTagColor = context.theme.background.withOpacity(0.5);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
//       child: Column(
//         children: topTenScores
//             .map((s) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6.0),
//                   child: ContentBox(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           ContentBox(
//                             borderRadius: 30,
//                             backgroundColor:
//                                 context.theme.background.withOpacity(0.2),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 MyText(
//                                   s.loadAmount.stringMyDouble(),
//                                   color: Styles.primaryAccent,
//                                   size: FONTSIZE.six,
//                                 ),
//                                 const SizedBox(width: 2),
//                                 MyText(
//                                   tracker.loadUnit.display,
//                                   color: Styles.primaryAccent,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           if (Utils.textNotNull(s.loggedWorkoutId))
//                             TertiaryButton(
//                                 fontSize: FONTSIZE.one,
//                                 iconSize: 14,
//                                 backgroundColor: buttonTagColor,
//                                 suffixIconData: CupertinoIcons.chevron_right,
//                                 text: 'View Log',
//                                 onPressed: () => context.navigateTo(
//                                     LoggedWorkoutDetailsRoute(
//                                         id: s.loggedWorkoutId!))),
//                           if (Utils.textNotNull(s.videoUri))
//                             TertiaryButton(
//                                 fontSize: FONTSIZE.one,
//                                 iconSize: 14,
//                                 backgroundColor: buttonTagColor,
//                                 suffixIconData: CupertinoIcons.tv,
//                                 text: 'View Video',
//                                 onPressed: () =>
//                                     VideoSetupManager.openFullScreenVideoPlayer(
//                                         context: context,
//                                         videoUri: s.videoUri!)),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           if (s.manualEntryId != null)
//                             IconButton(
//                                 iconData: CupertinoIcons.trash,
//                                 size: 20,
//                                 onPressed: () => _confirmDeleteManualEntry(
//                                     context, s.manualEntryId!)),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               MyText(
//                                 s.completedOn.compactDateString,
//                                 size: FONTSIZE.two,
//                               ),
//                               const SizedBox(height: 2),
//                               MyText(
//                                 s.completedOn.timeString,
//                                 size: FONTSIZE.one,
//                               ),
//                               if (s.manualEntryId != null)
//                                 const Padding(
//                                   padding: EdgeInsets.only(top: 2.0),
//                                   child: MyText(
//                                     'Submitted Manually',
//                                     size: FONTSIZE.zero,
//                                     color: Styles.primaryAccent,
//                                   ),
//                                 )
//                             ],
//                           ),
//                         ],
//                       )
//                     ],
//                   )),
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }
