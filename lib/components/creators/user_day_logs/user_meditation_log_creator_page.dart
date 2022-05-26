import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_custom_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class UserMeditationLogCreatorPage extends StatefulWidget {
  final int? year;
  final int? dayNumber;
  final UserMeditationLog? userMeditationLog;
  const UserMeditationLogCreatorPage(
      {Key? key, this.userMeditationLog, this.year, this.dayNumber})
      : assert(
            (userMeditationLog != null) ^ (year != null && dayNumber != null)),
        super(key: key);

  @override
  State<UserMeditationLogCreatorPage> createState() =>
      _UserMeditationLogCreatorPageState();
}

class _UserMeditationLogCreatorPageState
    extends State<UserMeditationLogCreatorPage> {
  late bool _isCreate;

  late int _year;
  late int _dayNumber;
  late int _minutesLogged;
  String? _note;

  final TextEditingController _minutesController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isCreate = widget.userMeditationLog == null;

    _year = _isCreate ? widget.year! : widget.userMeditationLog!.year;
    _dayNumber =
        _isCreate ? widget.dayNumber! : widget.userMeditationLog!.dayNumber;

    _minutesLogged = _isCreate ? 10 : widget.userMeditationLog!.minutesLogged;
    _minutesController.text = _minutesLogged.toString();

    _minutesController.selection = TextSelection(
        baseOffset: 0, extentOffset: _minutesController.value.text.length);

    _minutesController.addListener(() {
      setState(() => _minutesLogged = int.parse(_minutesController.text));
    });

    _note = widget.userMeditationLog?.note;
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

    checkOperationResult(result,
        onFail: _showErrorToast, onSuccess: context.pop);
  }

  Future<OperationResult> _createLog() async {
    final variables = CreateUserMeditationLogArguments(
        data: CreateUserMeditationLogInput(
      year: _year,
      dayNumber: _dayNumber,
      minutesLogged: _minutesLogged,
      note: _note,
    ));

    final result = await GraphQLStore.store.create(
      mutation: CreateUserMeditationLogMutation(variables: variables),
      addRefToQueries: [
        GQLOpNames.userMeditationLogs,
      ],
    );
    return result;
  }

  Future<OperationResult> _updateLog() async {
    final variables = UpdateUserMeditationLogArguments(
        data: UpdateUserMeditationLogInput(
      id: widget.userMeditationLog!.id,
      minutesLogged: _minutesLogged,
      note: _note,
    ));

    final result = await GraphQLStore.store.mutate(
      mutation: UpdateUserMeditationLogMutation(variables: variables),
      broadcastQueryIds: [
        GQLOpNames.userMeditationLogs,
      ],
    );
    return result;
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  bool get _validToSave => _minutesLogged != 0;

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Convert the [dayNumber] into a DateTime.
    final logDateTime = DateTime(_year, 1, _dayNumber);

    return MyPageScaffold(
        navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          middle: NavBarTitle(
            _isCreate ? 'Log Time' : 'Edit Time',
          ),
          trailing: _saving
              ? const NavBarTrailingRow(
                  children: [
                    NavBarLoadingIndicator(),
                  ],
                )
              : _validToSave
                  ? FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: NavBarTertiarySaveButton(
                          _saveAndClose,
                        ),
                      ),
                    )
                  : null,
        ),
        child: Column(
          children: [
            ContentBox(child: MyText(logDateTime.compactDateString)),
            const SizedBox(height: 6),
            const ContentBox(
              child: Icon(
                MyCustomIcons.mindfulnessIcon,
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: MyNumberInput(
                _minutesController,
                autoFocus: true,
                allowDouble: false,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.time,
                  size: 20,
                ),
                SizedBox(width: 6),
                MyText(
                  'Minutes Being Mindful',
                  size: FONTSIZE.five,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const HorizontalLine(
              verticalPadding: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: EditableTextAreaRow(
                  title: 'Notes or thoughts?',
                  text: _note ?? '',
                  onSave: _updateNote,
                  inputValidation: (_) => true),
            ),
          ],
        ));
  }
}
