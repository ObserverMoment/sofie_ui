import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/unauthed/register_beta_testing/register_beta_testing.dart';
import 'package:sofie_ui/pages/unauthed/sign_in.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UnauthedLandingPage extends StatelessWidget {
  const UnauthedLandingPage({Key? key}) : super(key: key);

  RotateAnimatedText _buildRotatingText(String text) => RotateAnimatedText(
        text,
        duration: const Duration(milliseconds: 3000),
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/placeholder_images/landing.jpg',
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                0.0,
                0.4,
                0.6
              ],
                  colors: [
                Styles.primaryAccent,
                Styles.black.withOpacity(0.5),
                Styles.black,
              ])),
        ),
        Positioned(
          top: 60,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/logos/circles_logo.svg',
                    width: 60, color: Styles.white),
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: const [
                    Text('CIRCLES',
                        style: TextStyle(fontFamily: 'Bauhaus', fontSize: 40)),
                    Positioned(
                      bottom: -14,
                      child: Text('FITNESS',
                          style:
                              TextStyle(fontFamily: 'Bauhaus', fontSize: 20)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  borderRadius: BorderRadius.circular(30),
                  margin: EdgeInsets.zero,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  backgroundColor: Styles.white,
                  child: const MyText(
                    'EARLY RELEASE',
                    size: FONTSIZE.one,
                    color: Styles.black,
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    CircleImage(
                      assetPath: 'assets/landing/1.jpg',
                    ),
                    CircleImage(
                      assetPath: 'assets/landing/2.jpg',
                    ),
                    CircleImage(
                      assetPath: 'assets/landing/7.jpg',
                    ),
                  ],
                ),
                Row(
                  children: const [
                    CircleImage(
                      assetPath: 'assets/landing/4.jpg',
                    ),
                    CircleImage(
                      assetPath: 'assets/landing/8.jpg',
                    ),
                    CircleImage(
                      assetPath: 'assets/landing/6.jpg',
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Bauhaus',
                      ),
                      child:
                          AnimatedTextKit(repeatForever: true, animatedTexts: [
                        _buildRotatingText('Fitness'),
                        _buildRotatingText('Knowledge'),
                        _buildRotatingText('Inspiration'),
                        _buildRotatingText('Community'),
                        _buildRotatingText('Coaching'),
                        _buildRotatingText('Progress Tracking'),
                        _buildRotatingText('Competition'),
                        _buildRotatingText('and more...'),
                      ]),
                    ),
                  ],
                )
              ]),
        ),
        Positioned(
          bottom: 40,
          child: Column(
            children: [
              PrimaryButton(
                text: 'Sign In',
                onPressed: () => context.push(child: const SignIn()),
              ),
              const SizedBox(height: 16),
              const MyText(
                'New to Circles? ',
                color: Styles.white,
                size: FONTSIZE.two,
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: 'Join Up',
                onPressed: () =>
                    context.push(child: const RegisterBetaTesting()),
              ),
              const SizedBox(height: 12),
              const MyText(
                'Free Access while in Early Release!',
                color: Styles.infoBlue,
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class CircleImage extends StatelessWidget {
  final String assetPath;
  const CircleImage({Key? key, required this.assetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 70,
      height: 70,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        assetPath,
        alignment: Alignment.topCenter,
        fit: BoxFit.cover,
      ),
    );
  }
}
