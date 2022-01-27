import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class FeedPostCommentInput extends StatefulWidget {
  final void Function(String comment) postComment;
  const FeedPostCommentInput({
    Key? key,
    required this.postComment,
  }) : super(key: key);

  @override
  _FeedPostCommentInputState createState() => _FeedPostCommentInputState();
}

class _FeedPostCommentInputState extends State<FeedPostCommentInput> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CupertinoTextField(
                      controller: _textController,
                      placeholder: 'Add a comment...',
                      autofocus: true,
                      maxLines: 10,
                      minLines: 1,
                      onSubmitted: (text) => widget.postComment(text),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      suffixMode: OverlayVisibilityMode.editing,
                      suffix: GestureDetector(
                        onTap: () async {
                          if (_textController.value.text.isNotEmpty) {
                            widget.postComment(_textController.text);
                            _textController.clear();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            color: context.theme.primary,
                            size: 30,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.cardBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
