import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// UI for the user to input a sequence of [int] to represent either reps or load which can then be used to generate a sequence of workout sets (or similar).
class PyramidGenerator extends StatefulWidget {
  final String pageTitle;
  final void Function(List<int> sequence) generateSequence;
  const PyramidGenerator(
      {Key? key,
      this.pageTitle = 'Pyramid Generator',
      required this.generateSequence})
      : super(key: key);

  @override
  _PyramidGeneratorState createState() => _PyramidGeneratorState();
}

class _PyramidGeneratorState extends State<PyramidGenerator> {
  /// Start with 3 - the user can add more but must always be 2 or more.
  final int _minInputs = 2;
  final int _initialInputs = 3;

  /// One for each input.
  late List<TextEditingController> _activeInputControllers;

  /// Keep references to these and dispose them all when you unmount.
  final List<TextEditingController> _removedControllers = [];

  @override
  void initState() {
    super.initState();
    _activeInputControllers = List.generate(
        _initialInputs, (i) => TextEditingController(text: (i + 1).toString()));

    for (final c in _activeInputControllers) {
      c.addListener(() {
        setState(() {});
      });
    }
  }

  void _addInput() {
    /// Create new controller in [inputControllers]
    final newController =
        TextEditingController(text: _activeInputControllers.last.text);
    _activeInputControllers.add(newController);
    newController.addListener(() {
      setState(() {});
    });
    setState(() {});
  }

  void _removeInput(int index) {
    _removedControllers.add(_activeInputControllers.removeAt(index));
    setState(() {});
  }

  void _saveAndClose() {
    if (validToSubmit) {
      widget.generateSequence(
          _activeInputControllers.map((c) => int.parse(c.text)).toList());
    }
    context.pop();
  }

  bool get validToSubmit =>
      _activeInputControllers.every((c) => c.text != '' && c.text != '0');

  @override
  void dispose() {
    for (final c in _activeInputControllers) {
      c.dispose();
    }
    for (final c in _removedControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: NavBarTitle(widget.pageTitle),
        trailing: validToSubmit
            ? FadeIn(child: NavBarTertiarySaveButton(_saveAndClose))
            : null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: MyText(
                'Use this to generate a sequence (i.e. a ladder or a pyramid) where reps or load increase or decrease with each round.',
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _activeInputControllers
                    .mapIndexed((i, c) => SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              MyNumberInput(
                                c,
                                textSize: 20,
                                backgroundColor: c.text == '' || c.text == '0'
                                    ? Styles.errorRed
                                    : null,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                              ),
                              if (_activeInputControllers.length > _minInputs)
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      CupertinoIcons.delete,
                                      size: 16,
                                    ),
                                    onPressed: () => _removeInput(i))
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CreateTextIconButton(
                text: 'Add Step',
                onPressed: _addInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
