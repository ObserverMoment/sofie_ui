import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class MyCupertinoSearchTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String value) onChanged;
  final void Function(String)? onSubmitted;
  final String? placeholder;
  final bool autofocus;
  const MyCupertinoSearchTextField(
      {Key? key,
      this.focusNode,
      required this.onChanged,
      this.placeholder = 'Search',
      this.onSubmitted,
      this.autofocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      autofocus: autofocus,
      placeholder: placeholder,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      suffixInsets: const EdgeInsets.only(right: 8),
      prefixIcon: Container(),
      decoration: BoxDecoration(
        color: context.theme.cardBackground,
        borderRadius: BorderRadius.circular(35),
      ),
      style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          decorationStyle: null,
          color: context.theme.primary),
      placeholderStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: context.theme.primary.withOpacity(0.5)),
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
