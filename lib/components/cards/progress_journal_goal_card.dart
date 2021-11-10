import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';

class ProgressJournalGoalCard extends StatelessWidget {
  final ProgressJournalGoal progressJournalGoal;
  const ProgressJournalGoalCard({
    Key? key,
    required this.progressJournalGoal,
  }) : super(key: key);

  Future<void> _toggleComplete(BuildContext context) async {
    if (progressJournalGoal.completedDate == null) {
      _markComplete(context);
    } else {
      _markIncomplete(context);
    }
  }

  Future<void> _markComplete(BuildContext context) async {
    await context.showActionSheetPopup(
        child: _MarkGoalCompletedBottomSheet(
      progressJournalGoal: progressJournalGoal,
      onUpdateComplete: (result) {
        context.pop();
        _checkResult(context, result);
      },
    ));
  }

  Future<void> _markIncomplete(BuildContext context) async {
    context.showConfirmDialog(
        title: 'Mark Incomplete?',
        onConfirm: () async {
          final updated =
              ProgressJournalGoal.fromJson(progressJournalGoal.toJson());
          updated.completedDate = null;

          final variables = UpdateProgressJournalGoalArguments(
              data: UpdateProgressJournalGoalInput.fromJson(updated.toJson()));

          final result = await context.graphQLStore.mutate(
              mutation: UpdateProgressJournalGoalMutation(variables: variables),
              optimisticData: updated.toJson(),
              broadcastQueryIds: [
                /// Broadcasting the operation name with no variables (nullified or parameterized)
                /// This will trigger all observerable queries with [progressJournalByIdQuery] keys to rebuild.
                GQLOpNames.progressJournalByIdQuery,
                UserProgressJournalsQuery().operationName
              ]);
          _checkResult(context, result);
        });
  }

  void _checkResult(BuildContext context, MutationResult? result) {
    if (result?.data == null || result!.hasErrors) {
      context.showToast(
          message: 'Sorry, there was an issue updating this goal.',
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = progressJournalGoal.completedDate != null;

    return AnimatedOpacity(
      opacity: isComplete ? 0.7 : 1,
      duration: kStandardAnimationDuration,
      child: ContentBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyText(
                          progressJournalGoal.name,
                          lineHeight: 1.3,
                          decoration:
                              isComplete ? TextDecoration.lineThrough : null,
                        ),
                        if (!isComplete && progressJournalGoal.deadline != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: MyText(
                              'by ${progressJournalGoal.deadline!.compactDateString}',
                              size: FONTSIZE.two,
                              decoration: isComplete
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: progressJournalGoal.deadline!
                                      .isBefore(DateTime.now())
                                  ? Styles.errorRed
                                  : Styles.primaryAccent,
                            ),
                          ),
                        if (isComplete)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: MyText(
                              'Completed ${progressJournalGoal.completedDate!.compactDateString}',
                              color: Styles.primaryAccent,
                              size: FONTSIZE.two,
                            ),
                          )
                      ],
                    ),
                    if (Utils.textNotNull(progressJournalGoal.description))
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 6.0, top: 6, bottom: 6),
                        child: MyText(
                          progressJournalGoal.description!,
                          maxLines: 10,
                          lineHeight: 1.3,
                          decoration:
                              isComplete ? TextDecoration.lineThrough : null,
                          size: FONTSIZE.two,
                        ),
                      ),
                    if (progressJournalGoal.progressJournalGoalTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: progressJournalGoal.progressJournalGoalTags
                              .map((tag) => Tag(
                                    tag: tag.tag,
                                    color: HexColor.fromHex(tag.hexColor),
                                    textColor: Styles.white,
                                    fontSize: FONTSIZE.one,
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: AnimatedSwitcher(
                          duration: kStandardAnimationDuration,
                          child: isComplete
                              ? const Icon(
                                  CupertinoIcons.checkmark_alt_circle_fill,
                                  size: 40,
                                  color: Styles.primaryAccent,
                                )
                              : const Icon(
                                  CupertinoIcons.circle,
                                  size: 40,
                                )),
                      onPressed: () => _toggleComplete(context))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MarkGoalCompletedBottomSheet extends StatefulWidget {
  final ProgressJournalGoal progressJournalGoal;
  final void Function(MutationResult result) onUpdateComplete;
  const _MarkGoalCompletedBottomSheet(
      {required this.progressJournalGoal, required this.onUpdateComplete});

  @override
  __MarkGoalCompletedBottomSheetState createState() =>
      __MarkGoalCompletedBottomSheetState();
}

class __MarkGoalCompletedBottomSheetState
    extends State<_MarkGoalCompletedBottomSheet> {
  DateTime _completedDate = DateTime.now();
  bool _loading = false;

  Future<void> _markComplete() async {
    setState(() => _loading = true);
    final updated =
        ProgressJournalGoal.fromJson(widget.progressJournalGoal.toJson());
    updated.completedDate = _completedDate;

    final input = UpdateProgressJournalGoalInput.fromJson(updated.toJson());

    final variables = UpdateProgressJournalGoalArguments(data: input);

    final result = await context.graphQLStore.mutate(
        mutation: UpdateProgressJournalGoalMutation(variables: variables),
        optimisticData: updated.toJson(),
        broadcastQueryIds: [
          GQLOpNames.progressJournalByIdQuery,
          UserProgressJournalsQuery().operationName
        ]);

    setState(() => _loading = false);

    widget.onUpdateComplete(result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DateTimePickerDisplay(
              title: 'Completed Date',
              dateTime: _completedDate,
              showTime: false,
              contentBoxColor: context.theme.background,
              saveDateTime: (d) => setState(() => _completedDate = d)),
          const SizedBox(height: 30),
          PrimaryButton(
            text: 'Mark Complete',
            prefixIconData: CupertinoIcons.checkmark_alt,
            onPressed: _markComplete,
            loading: _loading,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
