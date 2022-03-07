import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class UserGoalCreatorPage extends StatelessWidget {
  final UserGoal? journalGoal;
  const UserGoalCreatorPage({Key? key, this.journalGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return journalGoal != null
        ? _EditGoal(
            journalGoal: journalGoal!,
          )
        : const _CreateGoal();
  }
}

class _CreateGoal extends StatefulWidget {
  const _CreateGoal({Key? key}) : super(key: key);

  @override
  State<_CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<_CreateGoal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  bool get _validToSubmit => Utils.textNotNull(_nameController.text);

  Future<void> _saveAndClose() async {
    if (_validToSubmit) {
      setState(() {
        _saving = true;
      });

      final variables = CreateUserGoalArguments(
          data: CreateUserGoalInput(
        name: _nameController.text,
        description: _descriptionController.text,
        deadline: _deadline,
      ));

      final result = await context.graphQLStore.create(
        mutation: CreateUserGoalMutation(variables: variables),
        addRefToQueries: [
          GQLOpNames.userGoals,
        ],
      );

      setState(() {
        _saving = false;
      });

      checkOperationResult(context, result,
          onFail: _showErrorToast, onSuccess: context.pop);
    }
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  EdgeInsets get _inputPadding =>
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Add Goal',
        ),
        trailing: _saving
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingIndicator(),
                ],
              )
            : NavBarTrailingRow(
                children: [
                  if (_validToSubmit)
                    FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TertiaryButton(
                          backgroundColor: Styles.primaryAccent,
                          textColor: Styles.white,
                          onPressed: _saveAndClose,
                          text: 'Save',
                        ),
                      ),
                    ),
                  NavBarCancelButton(context.pop),
                ],
              ),
      ),
      child: ListView(
        children: [
          Padding(
            padding: _inputPadding,
            child: MyTextFormFieldRow(
                controller: _nameController,
                placeholder: 'The Goal',
                backgroundColor: context.theme.cardBackground,
                keyboardType: TextInputType.text),
          ),
          Padding(
            padding: _inputPadding,
            child: MyTextAreaFormFieldRow(
              controller: _descriptionController,
              placeholder: 'More Details',
              backgroundColor: context.theme.cardBackground,
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MyHeaderText('Target Completion Date'),
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.scope)
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                  onTap: () {
                    Utils.hideKeyboard(context);
                    context.showBottomSheet(
                        child: DateTimePicker(
                            title: 'Target Completion Date',
                            showTime: false,
                            saveDateTime: (date) =>
                                setState(() => _deadline = date)));
                  },
                  child: ContentBox(
                      child: MyText(
                    _deadline == null ? 'No Target' : _deadline!.dateString,
                    size: FONTSIZE.five,
                  )))
            ],
          )
        ],
      ),
    );
  }
}

class _EditGoal extends StatefulWidget {
  final UserGoal journalGoal;
  const _EditGoal({Key? key, required this.journalGoal}) : super(key: key);

  @override
  State<_EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<_EditGoal> {
  /// For optimistic UI updates.
  late UserGoal _activeUserGoal;
  late Map<String, dynamic> _backup;

  @override
  void initState() {
    super.initState();
    _backup = widget.journalGoal.toJson();
    _activeUserGoal = UserGoal.fromJson(_backup);
  }

  /// Updates the UI optimistically.
  /// Saves the the DB. Check result. If no errors, do nothing further.
  /// Else rollback and show errro toast.
  Future<void> _updateUserGoal(Map<String, dynamic> data) async {
    setState(() {
      _activeUserGoal =
          UserGoal.fromJson({..._activeUserGoal.toJson(), ...data});
    });

    final variables = UpdateUserGoalArguments(
        data: UpdateUserGoalInput(
      id: _activeUserGoal.id,
      name: _activeUserGoal.name,
      description: _activeUserGoal.description,
      deadline: _activeUserGoal.deadline,
    ));

    final result = await context.graphQLStore.mutate(
      mutation: UpdateUserGoalMutation(variables: variables),
      broadcastQueryIds: [
        GQLOpNames.userGoals,
      ],
    );

    checkOperationResult(context, result, onFail: _showErrorToast);
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Goal',
        ),
        trailing: FadeIn(
          child: NavBarTertiarySaveButton(
            context.pop,
            text: 'Done',
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        children: [
          UserInputContainer(
            child: EditableTextFieldRow(
                title: "The Goal",
                text: _activeUserGoal.name,
                onSave: (name) => _updateUserGoal({'name': name}),
                inputValidation: (name) => Utils.textNotNull(name)),
          ),
          UserInputContainer(
            child: EditableTextAreaRow(
                title: 'Description',
                text: _activeUserGoal.description ?? '',
                onSave: (description) =>
                    _updateUserGoal({'description': description}),
                inputValidation: (_) => true),
          ),
          UserInputContainer(
            child: DateTimePickerDisplay(
                title: 'Complete By',
                dateTime: _activeUserGoal.deadline,
                showTime: false,
                saveDateTime: (deadline) => _updateUserGoal(
                    {'deadline': deadline.millisecondsSinceEpoch})),
          ),
        ],
      ),
    );
  }
}
