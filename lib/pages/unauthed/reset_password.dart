import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _requestingReset = false;
  bool _resetRequested = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validateEmail() => EmailValidator.validate(_emailController.text);

  Future<void> _requestResetPassword() async {
    try {
      setState(() => _requestingReset = true);
      await GetIt.I<AuthBloc>().resetPassword(_emailController.text);
      setState(() {
        _requestingReset = false;
        _resetRequested = true;
      });
    } catch (e) {
      printLog(e.toString());
      setState(() {
        _requestingReset = false;
        _resetRequested = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalPageScaffold(
        title: 'Reset Password',
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _resetRequested
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const MyText(
                        'If this email address was used to create an account, instructions to reset your password will be sent to you. Please check your email.',
                        maxLines: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          text: 'Back to Sign In',
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: MyText(
                        'Enter the email address you used when you joined and we’ll send you instructions to reset your password.',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyTextFormFieldRow(
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: _validateEmail,
                        autofocus: true,
                        autofillHints: const <String>[AutofillHints.email],
                        backgroundColor: context.theme.background,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                        onPressed: _requestResetPassword,
                        text: 'Send Reset Instructions',
                        loading: _requestingReset,
                        disabled: !_validateEmail()),
                  ],
                ),
        ));
  }
}
