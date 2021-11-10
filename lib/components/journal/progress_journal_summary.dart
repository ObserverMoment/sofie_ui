import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/progress_journal_goals_summary_card.dart';
import 'package:sofie_ui/components/journal/bodyweight_tracker_chart.dart';
import 'package:sofie_ui/components/journal/reflective_journaling_chart.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ProgressJournalSummary extends StatelessWidget {
  final ProgressJournal journal;
  const ProgressJournalSummary({Key? key, required this.journal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProgressJournalGoalsSummaryCard(
            goals: journal.progressJournalGoals,
          ),
          const HorizontalLine(
            verticalPadding: 24,
          ),
          ReflectiveJournalingChart(
            journal: journal,
          ),
          const HorizontalLine(
            verticalPadding: 24,
          ),
          BodyweightTrackerChart(
            journal: journal,
          )
        ],
      ),
    );
  }
}
