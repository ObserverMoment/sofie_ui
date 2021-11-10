import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_text_field.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class CommaSeparatedListGenerator extends StatefulWidget {
  final String title;

  /// Comma separated list of things.
  /// Each thing will display in its own input field.
  /// Where it can be edited or deleted.
  final String list;
  final void Function(String list) updateList;
  const CommaSeparatedListGenerator(
      {Key? key,
      required this.title,
      required this.list,
      required this.updateList})
      : super(key: key);

  @override
  _CommaSeparatedListGeneratorState createState() =>
      _CommaSeparatedListGeneratorState();
}

class _CommaSeparatedListGeneratorState
    extends State<CommaSeparatedListGenerator> {
  late List<TextEditingController> _activeInputControllers;

  /// Keep references to these and dispose them all when you unmount.
  final List<TextEditingController> _removedControllers = [];

  @override
  void initState() {
    super.initState();
    _activeInputControllers = widget.list
        .split(',')
        .map((text) => TextEditingController(text: text))
        .toList();

    for (final c in _activeInputControllers) {
      c.addListener(() {
        setState(() {});
      });
    }
  }

  void _removeMoveFromSet(int index) {
    setState(() {
      final removed = _activeInputControllers.removeAt(index);
      _removedControllers.add(removed);
    });
  }

  void _addMoveToSet() {
    setState(() {
      _activeInputControllers.add(TextEditingController());
    });
  }

  void _saveAndClose() {
    final updatedList = _activeInputControllers
        .where((c) => c.text != '')
        .map((c) => c.text)
        .join(',');
    widget.updateList(updatedList);
    context.pop();
  }

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
        middle: NavBarTitle(widget.title),
        trailing: NavBarSaveButton(
          _saveAndClose,
          text: 'Done',
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ..._activeInputControllers
                    .mapIndexed((i, c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: MyTextField(
                                controller: c,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(',')
                                ],
                              )),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _removeMoveFromSet(i),
                                child: const Icon(
                                  CupertinoIcons.clear_thick,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
                CreateTextIconButton(
                  text: 'Add Move',
                  onPressed: _addMoveToSet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
