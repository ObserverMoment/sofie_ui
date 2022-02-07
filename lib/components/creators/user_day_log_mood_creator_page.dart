import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:collection/collection.dart';

const List<String> kGoodFeelings = [
  'Calm',
  'Peaceful',
  'Content',
  'Cheerful',
  'Happy',
  'Excited',
  'Confident',
  'Proud',
  'Focused',
  'Relaxed',
  'Enthusiastic'
];

const List<String> kBadFeelings = [
  'Tense',
  'Anxious',
  'Frustrated',
  'Sad',
  'Nervous',
  'Irritable',
  'Drained',
  'Numb',
];

class UserDayLogMoodCreatorPage extends StatelessWidget {
  final UserDayLogMood? journalMood;
  const UserDayLogMoodCreatorPage({Key? key, this.journalMood})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return journalMood != null
        ? _EditMood(
            journalMood: journalMood!,
          )
        : const _CreateMood();
  }
}

class _CreateMood extends StatefulWidget {
  const _CreateMood({Key? key}) : super(key: key);

  @override
  State<_CreateMood> createState() => _CreateMoodState();
}

class _CreateMoodState extends State<_CreateMood> {
  int? _moodScore;
  int? _energyScore;
  List<String> _tags = [];
  String? _textNote;

  bool _saving = false;

  bool get _validToSubmit => _moodScore != null && _energyScore != null;

  Future<void> _saveAndClose() async {
    if (_validToSubmit) {
      setState(() {
        _saving = true;
      });

      /// TODO?
      // final variables = CreateUserDayLogMoodArguments(
      //     data: CreateUserDayLogMoodInput(
      //         energyScore: _energyScore!,
      //         moodScore: _moodScore!,
      //         tags: _tags,
      //         textNote: _textNote));

      // final result = await context.graphQLStore.create(
      //   mutation: CreateUserDayLogMoodMutation(variables: variables),
      //   addRefToQueries: [
      //     GQLOpNames.journalMoods,
      //   ],
      // );

      setState(() {
        _saving = false;
      });

      // checkOperationResult(context, result,
      //     onFail: _showErrorToast, onSuccess: context.pop);
    }
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Add Mood',
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
      child: _Inputs(
          moodScore: _moodScore,
          updateMoodScore: (score) => setState(() => _moodScore = score),
          energyScore: _energyScore,
          updateEnergyScore: (score) => setState(() => _energyScore = score),
          tags: _tags,
          toggleTag: (tag) =>
              setState(() => _tags = _tags.toggleItem<String>(tag)),
          textNote: _textNote,
          updateTextNote: (note) => setState(() => _textNote = note)),
    );
  }
}

class _EditMood extends StatefulWidget {
  final UserDayLogMood journalMood;
  const _EditMood({Key? key, required this.journalMood}) : super(key: key);

  @override
  State<_EditMood> createState() => _EditMoodState();
}

class _EditMoodState extends State<_EditMood> {
  /// For optimistic UI updates.
  late UserDayLogMood _activeUserDayLogMood;
  late Map<String, dynamic> _backup;

  @override
  void initState() {
    super.initState();
    _backup = widget.journalMood.toJson();
    _activeUserDayLogMood = UserDayLogMood.fromJson(_backup);
  }

  /// Updates the UI optimistically.
  /// Saves the the DB. Check result. If no errors, do nothing further.
  /// Else rollback and show errro toast.
  Future<void> _updateUserDayLogMood(Map<String, dynamic> data) async {
    setState(() {
      _activeUserDayLogMood =
          UserDayLogMood.fromJson({..._activeUserDayLogMood.toJson(), ...data});
    });

    /// TODO?
    // final variables = UpdateUserDayLogMoodArguments(
    //     data: UpdateUserDayLogMoodInput(
    //         id: _activeUserDayLogMood.id,
    //         energyScore: _activeUserDayLogMood.energyScore,
    //         moodScore: _activeUserDayLogMood.moodScore,
    //         tags: _activeUserDayLogMood.tags,
    //         textNote: _activeUserDayLogMood.textNote));

    // final result = await context.graphQLStore.mutate(
    //   mutation: UpdateUserDayLogMoodMutation(variables: variables),
    //   broadcastQueryIds: [
    //     GQLOpNames.journalMoods,
    //   ],
    // );

    // checkOperationResult(context, result, onFail: _showErrorToast);
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Edit Mood',
        ),
        trailing: FadeIn(
          child: NavBarTertiarySaveButton(
            context.pop,
            text: 'Done',
          ),
        ),
      ),
      child: _Inputs(
          moodScore: _activeUserDayLogMood.moodScore,
          updateMoodScore: (score) =>
              _updateUserDayLogMood({'moodScore': score}),
          energyScore: _activeUserDayLogMood.energyScore,
          updateEnergyScore: (score) =>
              _updateUserDayLogMood({'energyScore': score}),
          tags: _activeUserDayLogMood.tags,
          toggleTag: (tag) => _updateUserDayLogMood(
              {'tags': _activeUserDayLogMood.tags.toggleItem<String>(tag)}),
          textNote: _activeUserDayLogMood.textNote,
          updateTextNote: (note) => _updateUserDayLogMood({'textNote': note})),
    );
  }
}

/// Use for both Create and Edit by passing down the update functions.
class _Inputs extends StatelessWidget {
  final int? moodScore;
  final void Function(int score) updateMoodScore;
  final int? energyScore;
  final void Function(int score) updateEnergyScore;
  final List<String> tags;
  final void Function(String tag) toggleTag;
  final String? textNote;
  final void Function(String textNote) updateTextNote;
  const _Inputs(
      {Key? key,
      required this.moodScore,
      required this.updateMoodScore,
      required this.energyScore,
      required this.updateEnergyScore,
      required this.tags,
      required this.toggleTag,
      required this.textNote,
      required this.updateTextNote})
      : super(key: key);

  EdgeInsets get _inputPadding =>
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20);

  Widget get _spacer => const SizedBox(height: 16);

  Widget _heading(String text) => MyHeaderText(
        text,
        weight: FontWeight.normal,
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: _inputPadding,
          child: Column(
            children: [
              _heading('How is your mood?'),
              const MyText(
                '(REQUIRED)',
                size: FONTSIZE.two,
              ),
              _spacer,
              _ScoreSelectorInput(
                score: moodScore,
                labels: const ['Awful', 'Bad', 'Okay', 'Good', 'Great'],
                updateScore: updateMoodScore,
              ),
            ],
          ),
        ),
        Padding(
          padding: _inputPadding,
          child: Column(
            children: [
              _heading('How are your energy levels?'),
              const MyText(
                '(REQUIRED)',
                size: FONTSIZE.two,
              ),
              _spacer,
              _ScoreSelectorInput(
                score: energyScore,
                labels: const ['Empty', 'Low', 'Okay', 'High', 'Pumped'],
                updateScore: updateEnergyScore,
              ),
            ],
          ),
        ),
        Padding(
          padding: _inputPadding,
          child: Column(
            children: [
              _heading('How are you feeling?'),
              const SizedBox(height: 12),
              _FeelingSelectorInput(
                selectable: kGoodFeelings,
                selected: tags,
                selectedColor: kGoodScoreColor,
                toggleFeeling: toggleTag,
              ),
              const HorizontalLine(
                verticalPadding: 16,
              ),
              _FeelingSelectorInput(
                selectable: kBadFeelings,
                selected: tags,
                selectedColor: kBadScoreColor,
                toggleFeeling: toggleTag,
              ),
            ],
          ),
        ),
        const HorizontalLine(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: EditableTextAreaRow(
              title: 'Anything else?',
              text: textNote ?? '',
              onSave: updateTextNote,
              inputValidation: (_) => true),
        ),
      ],
    );
  }
}

class _ScoreSelectorInput extends StatelessWidget {
  final List<String> labels;
  final int? score;
  final void Function(int score) updateScore;
  const _ScoreSelectorInput(
      {Key? key,
      required this.labels,
      required this.score,
      required this.updateScore})
      : super(key: key);

  Color _scoreColor(int score) =>
      Color.lerp(kBadScoreColor, kGoodScoreColor, score / 4) ??
      Styles.primaryAccent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels
          .mapIndexed((index, label) => SelectableTag(
              isSelected: score != null && labels[score!] == label,
              selectedColor: _scoreColor(index),
              onPressed: () => updateScore(index),
              text: label))
          .toList(),
    );
  }
}

class _FeelingSelectorInput extends StatelessWidget {
  final List<String> selectable;
  final List<String> selected;
  final Color selectedColor;
  final void Function(String feeling) toggleFeeling;
  const _FeelingSelectorInput(
      {Key? key,
      required this.selected,
      required this.toggleFeeling,
      required this.selectable,
      required this.selectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      children: selectable
          .map((f) => SelectableTag(
              isSelected: selected.contains(f),
              selectedColor: selectedColor,
              onPressed: () => toggleFeeling(f),
              text: f))
          .toList(),
    );
  }
}
