import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

/// Add / remove string tags. Receives and returns a list of tags.
class TagsEditor extends StatefulWidget {
  final List<String> tags;
  final Function(List<String> tags) updateTags;
  final String placeholder;
  final int maxTags;
  const TagsEditor({
    Key? key,
    required this.tags,
    required this.updateTags,
    this.placeholder = 'Add tag...',
    this.maxTags = 0,
  }) : super(key: key);

  @override
  State<TagsEditor> createState() => _TagsEditorState();
}

class _TagsEditorState extends State<TagsEditor> {
  final TextEditingController _tagInputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tagInputController.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void _addTag() {
    widget.updateTags([...widget.tags, _tagInputController.text]);
    _tagInputController.text = '';
  }

  void _removeTag(String tag) {
    widget.updateTags(widget.tags.where((t) => t != tag).toList());
  }

  @override
  void dispose() {
    _tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: kStandardAnimationDuration,
              padding: const EdgeInsets.only(top: 8, bottom: 6, right: 6),
              decoration: BoxDecoration(
                  color: context.theme.cardBackground,
                  border: Border.all(
                      color: _focusNode.hasFocus
                          ? context.theme.primary
                          : context.theme.cardBackground),
                  borderRadius: BorderRadius.circular(6)),
              child: CupertinoTextFormFieldRow(
                controller: _tagInputController,
                focusNode: _focusNode,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                ],
                placeholder: widget.placeholder,
                keyboardType: TextInputType.text,
                placeholderStyle: TextStyle(
                    fontSize: 17,
                    color: context.theme.primary.withOpacity(0.75)),
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Positioned(
                right: 10,
                child: FadeIn(
                    child: IconButton(
                        disabled: _tagInputController.text.isEmpty,
                        iconData: CupertinoIcons.plus,
                        size: 36,
                        onPressed: _addTag))),
          ],
        ),
        GrowInOut(
            show: widget.tags.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 4,
                runSpacing: 0,
                children: widget.tags
                    .map((t) => CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _removeTag(t),
                          child: MyText(
                            t,
                            weight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
            )),
      ],
    );
  }
}
