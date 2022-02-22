import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';

class EmptyPlaceholderAction {
  final VoidCallback action;
  final IconData buttonIcon;
  final String buttonText;
  EmptyPlaceholderAction(
      {required this.action,
      required this.buttonIcon,
      required this.buttonText});
}

/// E.g. if user has not created or saved any workouts - show this so that they can navigate somewhere to rectify the situation.
class YourContentEmptyPlaceholder extends StatelessWidget {
  final String message;

  /// Useful for explaining what a function is used for - before the user has ever created one.
  final String? explainer;
  final bool showIcon;
  final List<EmptyPlaceholderAction> actions;
  const YourContentEmptyPlaceholder({
    Key? key,
    this.message = 'Nothing to display',
    required this.actions,
    this.showIcon = true,
    this.explainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showIcon ? NoResultsToDisplay(message: message) : MyText(message),
            const SizedBox(height: 20),
            if (explainer != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MyText(
                  explainer!,
                  maxLines: 10,
                  lineHeight: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),
            ...actions
                .map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: PrimaryButton(
                        onPressed: a.action,
                        prefixIconData: a.buttonIcon,
                        text: a.buttonText,
                      ),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
