import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_text_field.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class CreateEditMemberNote extends StatefulWidget {
  final String clubId;
  final String memberId;
  final ClubMemberNote? clubMemberNote;
  final void Function(ClubMemberNote note)? onCreate;
  final void Function(ClubMemberNote note)? onUpdate;
  const CreateEditMemberNote(
      {Key? key,
      this.clubMemberNote,
      required this.clubId,
      required this.memberId,
      this.onCreate,
      this.onUpdate})
      : super(key: key);

  @override
  State<CreateEditMemberNote> createState() => _CreateEditMemberNoteState();
}

class _CreateEditMemberNoteState extends State<CreateEditMemberNote> {
  final TextEditingController _textInputController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();
  late List<String> _tags = [];

  bool _loading = false;
  bool _formIsDirty = false;

  @override
  void initState() {
    _textInputController.text = widget.clubMemberNote?.note ?? '';
    _tags = widget.clubMemberNote?.tags ?? [];

    _textInputController.addListener(() {
      if (_textInputController.text != (widget.clubMemberNote?.note ?? '')) {
        _formIsDirty = true;
      }
      setState(() {});
    });
    _tagInputController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool get _inputIsValid =>
      _textInputController.text.isNotEmpty && _formIsDirty;

  void _addTag(String tag) {
    _formIsDirty = true;

    /// Don't add a tag that is already there.
    if (!_tags.contains(tag)) {
      setState(() {
        _tagInputController.text = '';
        _tags.add(tag);
      });
    }
  }

  void _removeTag(String tag) {
    _formIsDirty = true;
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _createNote() async {
    if (_inputIsValid) {
      setState(() {
        _loading = true;
      });
      try {
        final variables = CreateClubMemberNoteArguments(
            data: CreateClubMemberNoteInput(
                clubId: widget.clubId,
                memberId: widget.memberId,
                note: _textInputController.text,
                tags: _tags));

        final result = await context.graphQLStore.networkOnlyOperation(
            operation: CreateClubMemberNoteMutation(variables: variables));

        checkOperationResult(context, result, onSuccess: () {
          setState(() {
            _loading = false;
          });
          widget.onCreate?.call(result.data!.createClubMemberNote);
          context.pop();
        });
      } catch (e) {
        printLog(e.toString());
        context.showToast(
            message: 'Sorry, there was a problem!',
            toastType: ToastType.destructive);
      }
    }
  }

  Future<void> _updateNote() async {
    if (_inputIsValid && widget.clubMemberNote != null) {
      setState(() {
        _loading = true;
      });
      try {
        final variables = UpdateClubMemberNoteArguments(
            data: UpdateClubMemberNoteInput(
                id: widget.clubMemberNote!.id,
                note: _textInputController.text,
                tags: _tags));

        final result = await context.graphQLStore.networkOnlyOperation(
            operation: UpdateClubMemberNoteMutation(variables: variables));

        checkOperationResult(context, result, onSuccess: () {
          setState(() {
            _loading = false;
          });
          widget.onUpdate?.call(result.data!.updateClubMemberNote);
          context.pop();
        });
      } catch (e) {
        printLog(e.toString());
        context.showToast(
            message: 'Sorry, there was a problem!',
            toastType: ToastType.destructive);
      }
    }
  }

  @override
  void dispose() {
    _textInputController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        customLeading: NavBarCancelButton(context.pop),
        middle: NavBarTitle(
            widget.clubMemberNote != null ? 'Edit Note' : 'Create Note'),
        trailing: _inputIsValid
            ? _loading
                ? const FadeInUp(child: CupertinoActivityIndicator(radius: 10))
                : FadeInUp(
                    child: NavBarTertiarySaveButton(
                      widget.clubMemberNote != null ? _updateNote : _createNote,
                    ),
                  )
            : null,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyTextField(
                  placeholder: 'Note...(required)',
                  autofocus: true,
                  maxLines: null,
                  textInputType: TextInputType.multiline,
                  controller: _textInputController),
              const SizedBox(height: 16),
              ClubMemberNoteTags(
                addTag: _addTag,
                removeTag: _removeTag,
                tagInputController: _tagInputController,
                tags: _tags,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClubMemberNoteTags extends StatelessWidget {
  final List<String> tags;
  final TextEditingController tagInputController;
  final void Function(String tag) addTag;
  final void Function(String tag) removeTag;
  const ClubMemberNoteTags(
      {Key? key,
      required this.tags,
      required this.addTag,
      required this.removeTag,
      required this.tagInputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextFormFieldRow(
                  controller: tagInputController,
                  // Don't allow any spaces or special chracters.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  ],
                  placeholder: 'Add a tag...',
                  keyboardType: TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  disabled: tagInputController.text.isEmpty,
                  iconData: CupertinoIcons.plus,
                  size: 50,
                  onPressed: () => addTag(tagInputController.text)),
            )
          ],
        ),
        GrowInOut(
            show: tags.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: tags
                    .map((t) => CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => removeTag(t),
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
