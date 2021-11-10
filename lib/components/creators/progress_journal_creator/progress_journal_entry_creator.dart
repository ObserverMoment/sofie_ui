import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/progress_journal_entry_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/future_builder_handler.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/number_picker.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class ProgressJournalEntryCreator extends StatefulWidget {
  final ProgressJournal parentJournal;
  final ProgressJournalEntry? progressJournalEntry;
  const ProgressJournalEntryCreator(
      {Key? key, this.progressJournalEntry, required this.parentJournal})
      : super(key: key);
  @override
  _ProgressJournalEntryCreatorState createState() =>
      _ProgressJournalEntryCreatorState();
}

class _ProgressJournalEntryCreatorState
    extends State<ProgressJournalEntryCreator> {
  ProgressJournalEntry? _activeProgressJournalEntry;
  late bool _isCreate;

  /// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  late Future<ProgressJournalEntry> _initEntryFuture;

  Future<ProgressJournalEntry> _initEntry() async {
    if (_activeProgressJournalEntry != null) {
      return _activeProgressJournalEntry!;
    } else {
      _activeProgressJournalEntry =
          await ProgressJournalEntryCreatorBloc.initialize(
              context, widget.parentJournal, widget.progressJournalEntry);
      return _activeProgressJournalEntry!;
    }
  }

  @override
  void initState() {
    super.initState();
    _isCreate = widget.progressJournalEntry == null;
    _initEntryFuture = _initEntry();
  }

  void _saveAndClose(BuildContext context) {
    final success = context
        .read<ProgressJournalEntryCreatorBloc>()
        .saveAllChanges(widget.parentJournal.id);
    if (success) {
      context.pop();
    } else {
      context.showErrorAlert(
          'Sorry there was a problem updating, please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderHandler<ProgressJournalEntry>(
        loadingWidget: const ShimmerDetailsPage(),
        future: _initEntryFuture,
        builder: (initialEntryData) => ChangeNotifierProvider(
              create: (context) => ProgressJournalEntryCreatorBloc(
                  parentJournal: widget.parentJournal,
                  initialEntry: initialEntryData,
                  context: context,
                  isCreate: _isCreate),
              builder: (context, child) {
                final bool formIsDirty =
                    context.select<ProgressJournalEntryCreatorBloc, bool>(
                        (bloc) => bloc.formIsDirty);

                final bool uploadingMedia =
                    context.select<ProgressJournalEntryCreatorBloc, bool>(
                        (b) => b.uploadingMedia);

                return MyPageScaffold(
                  navigationBar: CreateEditPageNavBar(
                    handleClose: context.pop,
                    handleSave: () => _saveAndClose(context),
                    saveText: 'Done',

                    /// You always need to run the bloc.saveAllUpdates fn when creating.
                    /// i.e when [widget.progressJournalEntry == null]
                    formIsDirty:
                        widget.progressJournalEntry == null || formIsDirty,

                    /// Disable save / done while media is uploading.
                    inputValid: !uploadingMedia,
                    title: widget.progressJournalEntry == null
                        ? 'New Entry'
                        : 'Edit Entry',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: const [
                          ProgressJournalEntryCreatorNotes(),
                          SizedBox(height: 12),
                          ProgressJournalEntryCreatorScores()
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
  }
}

class ProgressJournalEntryCreatorNotes extends StatelessWidget {
  const ProgressJournalEntryCreatorNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final note = context
        .select<ProgressJournalEntryCreatorBloc, String?>((b) => b.entry.note);
    final voiceNoteUri =
        context.select<ProgressJournalEntryCreatorBloc, String?>(
            (b) => b.entry.voiceNoteUri);

    return Column(
      children: [
        UserInputContainer(
          child: EditableTextAreaRow(
              title: 'Text Note',
              text: note ?? '',
              onSave: (note) => context
                  .read<ProgressJournalEntryCreatorBloc>()
                  .updateEntry({'note': note}),
              inputValidation: (t) => true),
        ),
        UserInputContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: MyText(
                  'Voice Note',
                ),
              ),
              AudioUploader(
                  audioUri: voiceNoteUri,
                  onUploadStart: () => context
                      .read<ProgressJournalEntryCreatorBloc>()
                      .setUploadingMedia(uploading: true),
                  onUploadSuccess: (uri) {
                    final bloc =
                        context.read<ProgressJournalEntryCreatorBloc>();
                    bloc.updateEntry({'voiceNoteUri': uri});
                    bloc.setUploadingMedia(uploading: false);
                  },
                  iconData: CupertinoIcons.mic_solid,
                  removeAudio: () => context
                      .read<ProgressJournalEntryCreatorBloc>()
                      .updateEntry({'voiceNoteUri': null})),
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressJournalEntryCreatorScores extends StatelessWidget {
  double get kMaxScore => 10.0;

  const ProgressJournalEntryCreatorScores({Key? key}) : super(key: key);

  void _updateBodyweight(BuildContext context, double bodyweight) {
    context.read<ProgressJournalEntryCreatorBloc>().updateEntry({
      'bodyweight': bodyweight,
    });
  }

  void _updateScore(BuildContext context, String key, double score) {
    context.read<ProgressJournalEntryCreatorBloc>().updateEntry({
      key: score,
    });
  }

  bool _hasSubmittedScores(ProgressJournalEntry progressJournalEntry) => [
        progressJournalEntry.moodScore,
        progressJournalEntry.energyScore,
        progressJournalEntry.motivationScore,
        progressJournalEntry.confidenceScore
      ].any((s) => s != null);

  double _calcOverallAverage(ProgressJournalEntry progressJournalEntry) {
    final scores = [
      for (final s in [
        progressJournalEntry.moodScore,
        progressJournalEntry.energyScore,
        progressJournalEntry.motivationScore,
        progressJournalEntry.confidenceScore
      ])
        if (s != null) s
    ];
    return scores.average;
  }

  @override
  Widget build(BuildContext context) {
    final entry =
        context.select<ProgressJournalEntryCreatorBloc, ProgressJournalEntry>(
            (b) => b.entry);

    final bodyweight = context.select<ProgressJournalEntryCreatorBloc, double?>(
        (b) => b.entry.bodyweight);

    final bodyweightUnit =
        context.select<ProgressJournalEntryCreatorBloc, BodyweightUnit>(
            (b) => b.parentJournal.bodyweightUnit);

    return Column(
      children: [
        UserInputContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText('Bodyweight'),
              Row(
                children: [
                  NumberPickerDouble(
                    modalTitle: 'Bodyweight (${bodyweightUnit.display})',
                    number: bodyweight,
                    saveValue: (bw) => _updateBodyweight(context, bw),
                  ),
                  MyText(
                    bodyweightUnit.display,
                    weight: FontWeight.bold,
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                'Mind Health - Reflective Scores',
              ),
              if (_hasSubmittedScores(entry))
                FadeIn(
                  child: Row(
                    children: [
                      const MyText('Average '),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: CircularPercentIndicator(
                          startAngle: 180,
                          backgroundColor:
                              Styles.primaryAccent.withOpacity(0.35),
                          circularStrokeCap: CircularStrokeCap.round,
                          radius: 54.0,
                          lineWidth: 6.0,
                          percent: _calcOverallAverage(entry) / kMaxScore,
                          center: MyText(
                            _calcOverallAverage(entry).toInt().toString(),
                            lineHeight: 1,
                            weight: FontWeight.bold,
                          ),
                          progressColor: Color.lerp(
                              kBadScoreColor,
                              kGoodScoreColor,
                              _calcOverallAverage(entry) / kMaxScore),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        JournalEntryScoreInput(
          title: 'Mood',
          updateScore: (s) => _updateScore(context, 'moodScore', s),
          score: entry.moodScore,
        ),
        JournalEntryScoreInput(
          title: 'Energy',
          updateScore: (s) => _updateScore(context, 'energyScore', s),
          score: entry.energyScore,
        ),
        JournalEntryScoreInput(
            title: 'Confidence',
            updateScore: (s) => _updateScore(context, 'confidenceScore', s),
            score: entry.confidenceScore),
        JournalEntryScoreInput(
          title: 'Motivation',
          updateScore: (s) => _updateScore(context, 'motivationScore', s),
          score: entry.motivationScore,
        ),
      ],
    );
  }
}

class JournalEntryScoreInput extends StatefulWidget {
  final String title;
  final double? score;
  final void Function(double score) updateScore;
  const JournalEntryScoreInput(
      {Key? key, required this.title, this.score, required this.updateScore})
      : super(key: key);

  @override
  _JournalEntryScoreInputState createState() => _JournalEntryScoreInputState();
}

class _JournalEntryScoreInputState extends State<JournalEntryScoreInput> {
  late double? _activeScore;

  @override
  void initState() {
    super.initState();
    _activeScore = widget.score;
  }

  void _handleSave() {
    if (_activeScore != null && _activeScore != widget.score) {
      widget.updateScore(_activeScore!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ContentBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    widget.title,
                    weight: FontWeight.bold,
                  ),
                  H3(
                    _activeScore != null
                        ? _activeScore!.stringMyDouble()
                        : ' - ',
                  )
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 20.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11),
                ),
                child: Slider(
                  max: 10,
                  divisions: 10,
                  value: _activeScore ?? 0,
                  onChanged: (s) => setState(() => _activeScore = s),
                  onChangeEnd: (_) => _handleSave(),
                  activeColor: _activeScore == null
                      ? Styles.greyOne
                      : Color.lerp(
                          kBadScoreColor, kGoodScoreColor, _activeScore! / 10),
                  inactiveColor: context.theme.primary.withOpacity(0.08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
