import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/unauthed/register_beta_testing/register_beta_testing.dart';
import 'package:sofie_ui/pages/unauthed/sign_in.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class UnauthedLandingPage extends StatelessWidget {
  const UnauthedLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.asset('assets/placeholder_images/landing.jpg',
            fit: BoxFit.cover, alignment: Alignment.topRight),
        Container(
          decoration: BoxDecoration(
              color: Styles.black,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.0,
                    0.25,
                    0.6,
                    0.75
                  ],
                  colors: [
                    Styles.black.withOpacity(0.6),
                    Styles.black.withOpacity(0.1),
                    Styles.black.withOpacity(0.7),
                    Styles.black.withOpacity(0.9),
                  ])),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/logos/sofie_logo.svg',
                  width: 50, color: Styles.white),
              Text('Sofie',
                  style: GoogleFonts.voces(
                    fontSize: 40,
                    color: Styles.white,
                  )),
              const MyText(
                'Social Fitness Elevated',
                color: Styles.white,
              ),
            ]),
        Positioned(
          bottom: 60,
          child: Column(
            children: [
              const MyText(
                'Already have an account?',
                color: Styles.white,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Sign In',
                onPressed: () => context.showBottomSheet(child: const SignIn()),
              ),
              const SizedBox(height: 24),
              const MyText(
                'New to Sofie? Sign up',
                color: Styles.white,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Sign Up to Beta Testing',
                onPressed: () =>
                    context.showBottomSheet(child: const RegisterBetaTesting()),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
