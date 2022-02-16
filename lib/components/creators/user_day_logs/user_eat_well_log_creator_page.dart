import 'package:flutter/material.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/selectors/user_day_log_rating_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class UserEatWellLogCreatorPage extends StatefulWidget {
  final int? year;
  final int? dayNumber;
  final UserEatWellLog? userEatWellLog;
  const UserEatWellLogCreatorPage(
      {Key? key, this.userEatWellLog, this.year, this.dayNumber})
      : assert((userEatWellLog != null) ^ (year != null && dayNumber != null)),
        super(key: key);

  @override
  State<UserEatWellLogCreatorPage> createState() =>
      _UserEatWellLogCreatorPageState();
}

class _UserEatWellLogCreatorPageState extends State<UserEatWellLogCreatorPage> {
  late bool _isCreate;

  late int _year;
  late int _dayNumber;
  late UserDayLogRating _rating;
  String? _note;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isCreate = widget.userEatWellLog == null;

    _year = _isCreate ? widget.year! : widget.userEatWellLog!.year;
    _dayNumber =
        _isCreate ? widget.dayNumber! : widget.userEatWellLog!.dayNumber;

    _rating =
        _isCreate ? UserDayLogRating.average : widget.userEatWellLog!.rating;

    _note = widget.userEatWellLog?.note;
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
    final variables = CreateUserEatWellLogArguments(
        data: CreateUserEatWellLogInput(
      year: _year,
      dayNumber: _dayNumber,
      rating: _rating,
      note: _note,
    ));

    final result = await context.graphQLStore.create(
      mutation: CreateUserEatWellLogMutation(variables: variables),
      addRefToQueries: [
        GQLOpNames.userEatWellLogs,
      ],
    );
    return result;
  }

  Future<OperationResult> _updateLog() async {
    final variables = UpdateUserEatWellLogArguments(
        data: UpdateUserEatWellLogInput(
      id: widget.userEatWellLog!.id,
      rating: _rating,
      note: _note,
    ));

    final result = await context.graphQLStore.mutate(
      mutation: UpdateUserEatWellLogMutation(variables: variables),
      broadcastQueryIds: [
        GQLOpNames.userEatWellLogs,
      ],
    );
    return result;
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    /// Convert the [dayNumber] into a DateTime.
    final logDateTime = DateTime(_year, 1, _dayNumber);

    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          middle: const NavBarTitle(
            'Food Log',
          ),
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
                  Icons.restaurant,
                ),
              ],
            )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MyHeaderText('How well did you eat?'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserDayLogRatingSelector(
                userDayLogRating: _rating,
                updateRating: (r) => setState(() => _rating = r),
              ),
            ),
            const SizedBox(height: 16),
            const HorizontalLine(
              verticalPadding: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: EditableTextAreaRow(
                  title: 'Notes / food diary?',
                  text: _note ?? '',
                  onSave: _updateNote,
                  inputValidation: (_) => true),
            ),
          ],
        ));
  }
}
