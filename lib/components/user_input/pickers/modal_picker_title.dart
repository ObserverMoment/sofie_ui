import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class ModalPickerTitle extends StatelessWidget {
  final String title;
  const ModalPickerTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: MyHeaderText(
        title.toUpperCase(),
        size: FONTSIZE.four,
        textAlign: TextAlign.center,
      ),
    );
  }
}
