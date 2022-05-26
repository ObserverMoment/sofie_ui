import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: const [
            Text('CIRCLES',
                style: TextStyle(fontFamily: 'Bauhaus', fontSize: 26)),
            SizedBox(height: 8),
            LoadingSpinnerCircle()
          ]),
    ));
  }
}

class LoadingSpinnerCircle extends StatelessWidget {
  final double size;
  final Color? color;
  const LoadingSpinnerCircle({Key? key, this.size = 30, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeArchedCircle(
        color: context.theme.primary, size: size);
  }
}
