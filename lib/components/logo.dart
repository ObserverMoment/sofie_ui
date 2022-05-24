import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class Logo extends StatelessWidget {
  final Color? color;
  final double? size;
  const Logo({Key? key, this.color, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset('assets/logos/circles_logo.svg',
          width: size, height: size, color: color ?? context.theme.primary),
    );
  }
}

class LogoText extends StatelessWidget {
  final double fontSize;
  const LogoText({Key? key, this.fontSize = 26}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('CIRCLES',
        style: TextStyle(
            fontFamily: 'Bauhaus', fontSize: fontSize, letterSpacing: 1.2));
  }
}
