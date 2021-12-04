import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class DialogMenuItem {
  String text;
  Widget? icon;
  bool isDestructive;
  Function() onPressed;
  DialogMenuItem(
      {required this.text,
      this.icon,
      this.isDestructive = false,
      required this.onPressed});
}

class DialogMenu extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? message;
  final List<DialogMenuItem> actions;
  final VoidCallback? onCancel;

  DialogMenu(
      {Key? key,
      required this.actions,
      required this.title,
      this.message,
      this.subtitle,
      this.onCancel})
      : assert(actions.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          MyHeaderText(
            title,
            weight: FontWeight.normal,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          if (Utils.textNotNull(subtitle))
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: MyHeaderText(
                subtitle!,
                subtext: true,
                size: FONTSIZE.two,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          if (Utils.textNotNull(message))
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyText(
                message!,
                subtext: true,
                size: FONTSIZE.two,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: actions.map((a) => DialogMenuItemContainer(a)).toList(),
            ),
          ),
          if (onCancel != null)
            TextButton(underline: false, text: 'Cancel', onPressed: onCancel!)
        ],
      ),
    );
  }
}

class DialogMenuItemContainer extends StatelessWidget {
  final DialogMenuItem action;
  const DialogMenuItemContainer(this.action, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: context.theme.cardBackground.withOpacity(0.3),
            border: Border.all(
                color: action.isDestructive
                    ? Styles.errorRed
                    : context.theme.primary),
            borderRadius: BorderRadius.circular(30)),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          onPressed: () {
            context.pop();
            action.onPressed();
          },
          child: Row(
              mainAxisAlignment: action.icon != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                MyText(
                  action.text,
                  color: action.isDestructive
                      ? Styles.errorRed
                      : context.theme.primary,
                ),
                if (action.icon != null) action.icon!,
              ]),
        ),
      ),
    );
  }
}
