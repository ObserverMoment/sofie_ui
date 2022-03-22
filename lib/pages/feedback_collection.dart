import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class FeedbackCollectionPage extends StatefulWidget {
  /// Passed via [BetterFeedback.feedbackBuilder] which wraps whole app.
  final void Function(String, {Map<String, dynamic>? extras}) onSubmit;
  const FeedbackCollectionPage({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  State<FeedbackCollectionPage> createState() => _FeedbackCollectionPageState();
}

class _FeedbackCollectionPageState extends State<FeedbackCollectionPage> {
  final _feedbackController = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    _feedbackController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future<void> _handleFeedbackSubmission() async {
    setState(() {
      _submitted = true;
    });
    widget.onSubmit(_feedbackController.text);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyTextAreaFormFieldRow(
            placeholder: "What's on your mind?",
            keyboardType: TextInputType.text,
            controller: _feedbackController,
            backgroundColor: context.theme.background,
            expands: false,
            maxLines: 4,
          ),
        ),
        _submitted
            ? const MyText('Sending...')
            : NavBarTertiarySaveButton(
                _handleFeedbackSubmission,
                text: 'Send',
              ),
      ],
    );
  }
}
