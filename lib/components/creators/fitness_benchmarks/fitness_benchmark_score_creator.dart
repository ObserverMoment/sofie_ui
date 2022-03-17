import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class FitnessBenchmarkScoreCreator extends StatefulWidget {
  final FitnessBenchmark fitnessBenchmark;
  final FitnessBenchmarkScore? fitnessBenchmarkScore;
  const FitnessBenchmarkScoreCreator({
    Key? key,
    required this.fitnessBenchmark,
    this.fitnessBenchmarkScore,
  }) : super(key: key);
  @override
  _FitnessBenchmarkScoreCreatorState createState() =>
      _FitnessBenchmarkScoreCreatorState();
}

class _FitnessBenchmarkScoreCreatorState
    extends State<FitnessBenchmarkScoreCreator> {
  final TextEditingController _scoreController = TextEditingController();
  DateTime _completedOn = DateTime.now();

  /// If the score is a time then it is always in seconds.
  double _score = 0.0;
  String? _note;

  bool _formIsDirty = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.fitnessBenchmarkScore != null) {
      final e = widget.fitnessBenchmarkScore;
      _completedOn = e!.completedOn;
      _score = e.score;
      _note = e.note;
    }

    _scoreController.text = _score.stringMyDouble();
    _scoreController.selection = TextSelection(
        baseOffset: 0, extentOffset: _scoreController.value.text.length);
    _scoreController.addListener(() {
      if (Utils.textNotNull(_scoreController.text)) {
        _setStateWrapper(() => _score = double.parse(_scoreController.text));
      } else {
        _setStateWrapper(() => _score = 0.0);
      }
    });
  }

  void _setStateWrapper(void Function() cb) {
    _formIsDirty = true;
    setState(cb);
  }

  Future<void> _saveAndClose() async {
    setState(() => _loading = true);

    if (widget.fitnessBenchmarkScore != null) {
      _update();
    } else {
      _create();
    }
  }

  Future<void> _create() async {
    final variables = CreateFitnessBenchmarkScoreArguments(
        data: CreateFitnessBenchmarkScoreInput(
            note: _note,
            completedOn: _completedOn,
            score: _score,
            fitnessBenchmark:
                ConnectRelationInput(id: widget.fitnessBenchmark.id)));

    final result = await context.graphQLStore.mutate(
        mutation: CreateFitnessBenchmarkScoreMutation(variables: variables),
        broadcastQueryIds: [GQLOpNames.userFitnessBenchmarks]);

    setState(() => _loading = false);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: "Sorry, there was a problem creating this score.",
            toastType: ToastType.destructive),
        onSuccess: context.pop);
  }

  Future<void> _update() async {
    final variables = UpdateFitnessBenchmarkScoreArguments(
        data: UpdateFitnessBenchmarkScoreInput(
      id: widget.fitnessBenchmarkScore!.id,
      note: _note,
      completedOn: _completedOn,
      score: _score,
      // No media editing is done on this page.
      // Can't leave the media fields null as sending null will result in the video being deleted.
      videoUri: widget.fitnessBenchmarkScore!.videoUri,
      videoThumbUri: widget.fitnessBenchmarkScore!.videoThumbUri,
    ));

    final result = await context.graphQLStore.mutate(
        mutation: UpdateFitnessBenchmarkScoreMutation(variables: variables),
        broadcastQueryIds: [
          GQLOpNames.userFitnessBenchmarks,
        ]);

    setState(() => _loading = false);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: kDefaultErrorMessage, toastType: ToastType.destructive),
        onSuccess: context.pop);
  }

  void _handleCancel() {
    if (_formIsDirty) {
      context.showConfirmDialog(
          title: 'Close without saving?', onConfirm: context.pop);
    } else {
      context.pop();
    }
  }

  bool get _validToSubmit =>
      Utils.textNotNull(_scoreController.text) && _formIsDirty;

  Widget _buildNumberInput() => Column(
        children: [
          MyNumberInput(
            _scoreController,
            allowDouble: true,
            autoFocus: true,
          ),
          const SizedBox(height: 6),
          MyText(
            widget.fitnessBenchmark.type.scoreUnit ?? '',
            size: FONTSIZE.four,
            weight: FontWeight.bold,
          ),
        ],
      );

  Widget _buildDurationInput() {
    final duration = Duration(seconds: _score.round());
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CupertinoTimerPicker(
            initialTimerDuration: duration,
            onTimerDurationChanged: (d) => _setStateWrapper(
                  () => _score = d.inSeconds.toDouble(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(_handleCancel),
        middle: NavBarTitle(widget.fitnessBenchmark.name),
        trailing: _loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  LoadingIndicator(
                    size: 12,
                  ),
                ],
              )
            : _validToSubmit
                ? FadeIn(child: NavBarTertiarySaveButton(_saveAndClose))
                : null,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          UserInputContainer(
            child: DateTimePickerDisplay(
              dateTime: _completedOn,
              saveDateTime: (DateTime d) {
                _setStateWrapper(() {
                  _completedOn = d;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              children: [
                H3(widget.fitnessBenchmark.type.typeHeading),
                const SizedBox(height: 12),
                if ([
                  FitnessBenchmarkScoreType.fastesttimedistance,
                  FitnessBenchmarkScoreType.fastesttimereps,
                  FitnessBenchmarkScoreType.unbrokenmaxtime,
                ].contains(widget.fitnessBenchmark.type))
                  _buildDurationInput()
                else
                  _buildNumberInput(),
              ],
            ),
          ),
          UserInputContainer(
            child: EditableTextAreaRow(
                title: 'Note',
                text: _note ?? '',
                maxDisplayLines: 6,
                onSave: (t) => _setStateWrapper(() => _note = t),
                inputValidation: (t) => true),
          )
        ],
      ),
    );
  }
}
