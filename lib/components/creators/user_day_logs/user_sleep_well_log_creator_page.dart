import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/selectors/user_day_log_rating_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class UserSleepWellLogCreatorPage extends StatefulWidget {
  final int? year;
  final int? dayNumber;
  final UserSleepWellLog? userSleepWellLog;
  const UserSleepWellLogCreatorPage(
      {Key? key, this.userSleepWellLog, this.year, this.dayNumber})
      : assert(
            (userSleepWellLog != null) ^ (year != null && dayNumber != null)),
        super(key: key);

  @override
  State<UserSleepWellLogCreatorPage> createState() =>
      _UserSleepWellLogCreatorPageState();
}

class _UserSleepWellLogCreatorPageState
    extends State<UserSleepWellLogCreatorPage> {
  late bool _isCreate;

  late int _year;
  late int _dayNumber;
  late UserDayLogRating _rating;
  String? _note;

  int? _minutesSlept;

  /// Use inputs in hours and we convert to minutes for the DB.
  final TextEditingController _hoursController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isCreate = widget.userSleepWellLog == null;

    _year = _isCreate ? widget.year! : widget.userSleepWellLog!.year;
    _dayNumber =
        _isCreate ? widget.dayNumber! : widget.userSleepWellLog!.dayNumber;

    _rating =
        _isCreate ? UserDayLogRating.average : widget.userSleepWellLog!.rating;

    _minutesSlept = widget.userSleepWellLog?.minutesSlept;
    _hoursController.text =
        _minutesSlept != null ? (_minutesSlept! / 60).round().toString() : '';

    _note = widget.userSleepWellLog?.note;

    _hoursController.addListener(() {
      setState(() => _minutesSlept = Utils.textNotNull(_hoursController.text)
          ? (double.parse(_hoursController.text) * 60).round()
          : 0);
    });
  }

  void _updateNote(String note) => setState(() => _note = note);

  Future<void> _saveAndClose() async {
    setState(() {
      _saving = true;
    });

    OperationResult? result;
    if (_isCreate) {
      result = await _createLog();
    } else {
      result = await _updateLog();
    }

    setState(() {
      _saving = false;
    });

    checkOperationResult(context, result,
        onFail: _showErrorToast, onSuccess: context.pop);
  }

  Future<OperationResult> _createLog() async {
    final variables = CreateUserSleepWellLogArguments(
        data: CreateUserSleepWellLogInput(
      year: _year,
      dayNumber: _dayNumber,
      rating: _rating,
      minutesSlept: _minutesSlept,
      note: _note,
    ));

    final result = await context.graphQLStore.create(
      mutation: CreateUserSleepWellLogMutation(variables: variables),
      addRefToQueries: [
        GQLOpNames.userSleepWellLogs,
      ],
    );
    return result;
  }

  Future<OperationResult> _updateLog() async {
    final variables = UpdateUserSleepWellLogArguments(
        data: UpdateUserSleepWellLogInput(
      id: widget.userSleepWellLog!.id,
      rating: _rating,
      minutesSlept: _minutesSlept,
      note: _note,
    ));

    final result = await context.graphQLStore.mutate(
      mutation: UpdateUserSleepWellLogMutation(variables: variables),
      broadcastQueryIds: [
        GQLOpNames.userSleepWellLogs,
      ],
    );
    return result;
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Convert the [dayNumber] into a DateTime.
    final logDateTime = DateTime(_year, 1, _dayNumber);

    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          middle: const NavBarTitle('Sleep Log'),
          trailing: _saving
              ? const NavBarTrailingRow(
                  children: [
                    NavBarLoadingIndicator(),
                  ],
                )
              : FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: NavBarTertiarySaveButton(
                      _saveAndClose,
                    ),
                  ),
                ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            ContentBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(logDateTime.compactDateString),
                const Icon(
                  CupertinoIcons.bed_double,
                ),
              ],
            )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MyHeaderText('How well did you sleep?'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserDayLogRatingSelector(
                badEmoji: 'unamused',
                averageEmoji: 'slightly_smiling_face',
                goodEmoji: 'relieved',
                userDayLogRating: _rating,
                updateRating: (r) => setState(() => _rating = r),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MyHeaderText('Hours?'),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: MyNumberInput(
                    _hoursController,
                    allowDouble: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const HorizontalLine(
              verticalPadding: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: EditableTextAreaRow(
                  title: 'Notes?',
                  text: _note ?? '',
                  onSave: _updateNote,
                  inputValidation: (_) => true),
            ),
          ],
        ));
  }
}
