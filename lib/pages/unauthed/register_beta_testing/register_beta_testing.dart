import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/unauthed/register_details.dart';
import 'package:sofie_ui/services/utils.dart';

class RegisterBetaTesting extends StatefulWidget {
  const RegisterBetaTesting({Key? key}) : super(key: key);

  @override
  _RegisterBetaTestingState createState() => _RegisterBetaTestingState();
}

class _RegisterBetaTestingState extends State<RegisterBetaTesting> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _registeringNewUser = false;
  String? _registrationError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail() => EmailValidator.validate(_emailController.text);
  bool _validatePassword() => _passwordController.text.length > 5;

  bool _canSubmitRegisterDetails() => _validateEmail() && _validatePassword();

  Future<void> _registerNewUserAndContinue() async {
    setState(() => _registeringNewUser = true);
    try {
      await GetIt.I<AuthBloc>().registerWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      printLog(e.toString());
      if (mounted) setState(() => _registrationError = e.toString());
    } finally {
      setState(() => _registeringNewUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(children: const [NavBarBackButton()]),
        const NavBarLargeTitle(
          'Welcome to Sofie Beta!',
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: MyText(
            'Want to get involved? Just enter an email address and password to get started.',
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        RegisterDetails(
          canSubmit: _canSubmitRegisterDetails,
          emailController: _emailController,
          passwordController: _passwordController,
          registerNewUserAndContinue: _registerNewUserAndContinue,
          validateEmail: _validateEmail,
          validatePassword: _validatePassword,
          registeringNewUser: _registeringNewUser,
        ),
        if (_registrationError != null)
          GrowIn(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                _registrationError!,
                color: Styles.errorRed,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ]),
    );
  }
}
