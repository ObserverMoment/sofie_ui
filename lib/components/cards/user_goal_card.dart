import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class UserGoalCard extends StatelessWidget {
  final UserGoal journalGoal;
  const UserGoalCard({
    Key? key,
    required this.journalGoal,
  }) : super(key: key);

  Future<void> _toggleComplete(BuildContext context) async {
    if (journalGoal.completedDate == null) {
      _markComplete(context);
    } else {
      _markIncomplete(context);
    }
  }

  Future<void> _markComplete(BuildContext context) async {
    await context.showActionSheetPopup(
        child: _MarkGoalCompletedBottomSheet(
      journalGoal: journalGoal,
      onUpdateComplete: (result) {
        context.pop();
        checkOperationResult(result, onFail: () => _showErrorToast(context));
      },
    ));
  }

  Future<void> _markIncomplete(BuildContext context) async {
    context.showConfirmDialog(
        title: 'Mark Incomplete?',
        onConfirm: () async {
          final updated = UserGoal.fromJson(journalGoal.toJson());
          updated.completedDate = null;

          final variables = UpdateUserGoalArguments(
              data: UpdateUserGoalInput.fromJson(updated.toJson()));

          final result = await GraphQLStore.store.mutate(
              mutation: UpdateUserGoalMutation(variables: variables),
              broadcastQueryIds: [GQLOpNames.userGoals]);

          checkOperationResult(result, onFail: () => _showErrorToast(context));
        });
  }

  void _showErrorToast(BuildContext context) => context.showToast(
      message: 'Sorry, there was an issue updating this goal.',
      toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    final isComplete = journalGoal.completedDate != null;

    return ContentBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: AnimatedSwitcher(
                      duration: kStandardAnimationDuration,
                      child: isComplete
                          ? const Icon(
                              CupertinoIcons.checkmark_alt_circle_fill,
                              size: 38,
                              color: Styles.primaryAccent,
                            )
                          : const Icon(
                              CupertinoIcons.circle,
                              size: 38,
                            )),
                  onPressed: () => _toggleComplete(context)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MyText(
                          journalGoal.name,
                          lineHeight: 1.3,
                          maxLines: 2,
                          size: FONTSIZE.four,
                          decoration:
                              isComplete ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (!isComplete && journalGoal.deadline != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const MyText('Complete By', size: FONTSIZE.one),
                              const SizedBox(height: 3),
                              MyText(
                                journalGoal.deadline!.minimalDateString,
                                size: FONTSIZE.two,
                                decoration: isComplete
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: journalGoal.deadline!
                                        .isBefore(DateTime.now())
                                    ? Styles.errorRed
                                    : Styles.primaryAccent,
                              ),
                            ],
                          ),
                        ),
                      if (isComplete)
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: MyText(
                            'Completed ${journalGoal.completedDate!.compactDateString}',
                            color: Styles.primaryAccent,
                            size: FONTSIZE.two,
                          ),
                        )
                    ],
                  ),
                  if (Utils.textNotNull(journalGoal.description))
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 6.0, top: 6, bottom: 6),
                      child: MyText(
                        journalGoal.description!,
                        maxLines: 10,
                        lineHeight: 1.3,
                        decoration:
                            isComplete ? TextDecoration.lineThrough : null,
                        size: FONTSIZE.two,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkGoalCompletedBottomSheet extends StatefulWidget {
  final UserGoal journalGoal;
  final void Function(OperationResult result) onUpdateComplete;
  const _MarkGoalCompletedBottomSheet(
      {required this.journalGoal, required this.onUpdateComplete});

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
    final updated = UserGoal.fromJson(widget.journalGoal.toJson());
    updated.completedDate = _completedDate;

    final input = UpdateUserGoalInput.fromJson(updated.toJson());

    final variables = UpdateUserGoalArguments(data: input);

    final result = await GraphQLStore.store.mutate(
        mutation: UpdateUserGoalMutation(variables: variables),
        broadcastQueryIds: [GQLOpNames.userGoals]);

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
