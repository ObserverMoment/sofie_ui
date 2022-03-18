import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

class RegisterDetails extends StatefulWidget {
  final TextEditingController displayNameController;
  final bool nameIsValid;
  final bool nameIsAvailable;
  final TextEditingController emailController;
  final bool Function() validateEmail;
  final TextEditingController passwordController;
  final bool Function() validatePassword;
  final bool Function() canSubmit;
  final void Function() registerNewUserAndContinue;
  final bool registeringNewUser;

  const RegisterDetails({
    Key? key,
    required this.emailController,
    required this.validateEmail,
    required this.passwordController,
    required this.validatePassword,
    required this.canSubmit,
    required this.registerNewUserAndContinue,
    this.registeringNewUser = false,
    required this.displayNameController,
    required this.nameIsValid,
    required this.nameIsAvailable,
  }) : super(key: key);

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: MyText(
                'Want to get involved? Just enter your details to get started.',
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            MyTextFormFieldRow(
              placeholder: 'Display name',
              keyboardType: TextInputType.name,
              controller: widget.displayNameController,
              validator: () => widget.nameIsValid,
              autofocus: true,
              autofillHints: const <String>[AutofillHints.name],
              backgroundColor: context.theme.cardBackground,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    'Min 3 characters',
                    size: FONTSIZE.two,
                  ),
                  widget.nameIsValid && widget.nameIsAvailable
                      ? FadeInUp(
                          key: Key(
                              '${widget.nameIsValid}${widget.nameIsAvailable}'),
                          child: const MyText('This name is available!',
                              size: FONTSIZE.two,
                              weight: FontWeight.bold,
                              color: Styles.primaryAccent))
                      : widget.nameIsValid && !widget.nameIsAvailable
                          ? FadeInUp(
                              key: Key(
                                  '${widget.nameIsValid}${widget.nameIsAvailable}'),
                              child: const MyText(
                                  'Sorry, this name has been taken!',
                                  size: FONTSIZE.two,
                                  weight: FontWeight.bold,
                                  color: Styles.primaryAccent))
                          : Container()
                ],
              ),
            ),
            if (widget.nameIsValid && widget.nameIsAvailable)
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TertiaryButton(
                        suffixIconData: CupertinoIcons.arrow_right,
                        text: 'Next',
                        onPressed: () => _pageController.toPage(1))
                  ],
                ),
              )
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TertiaryButton(
                    prefixIconData: CupertinoIcons.arrow_left,
                    text: 'Back',
                    onPressed: () => _pageController.toPage(0))
              ],
            ),
            const SizedBox(height: 8),
            MyTextFormFieldRow(
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailController,
              validator: widget.validateEmail,
              autofillHints: const <String>[AutofillHints.email],
              backgroundColor: context.theme.cardBackground,
            ),
            const SizedBox(height: 10),
            MyPasswordFieldRow(
              controller: widget.passwordController,
              validator: widget.validatePassword,
              autofillHints: const <String>[AutofillHints.newPassword],
              backgroundColor: context.theme.cardBackground,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: Row(
                children: const [
                  MyText(
                    'Min 6 characters',
                    size: FONTSIZE.two,
                  ),
                ],
              ),
            ),
            if (widget.canSubmit())
              FadeIn(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PrimaryButton(
                    onPressed: widget.registerNewUserAndContinue,
                    text: 'Sign Up',
                    disabled: !widget.canSubmit(),
                    loading: widget.registeringNewUser,
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }
}
