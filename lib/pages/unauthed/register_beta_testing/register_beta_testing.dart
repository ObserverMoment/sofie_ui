import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/unauthed/register_details.dart';
import 'package:sofie_ui/services/debounce.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class RegisterBetaTesting extends StatefulWidget {
  const RegisterBetaTesting({Key? key}) : super(key: key);

  @override
  _RegisterBetaTestingState createState() => _RegisterBetaTestingState();
}

class _RegisterBetaTestingState extends State<RegisterBetaTesting> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _registeringNewUser = false;
  bool _nameIsValid = false;
  bool _nameIsAvailable = false;
  String? _registrationError;

  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _displayNameController.addListener(() {
      _debouncer.run(_validateDisplayName);
    });
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _validateDisplayName() async {
    if (_displayNameValid()) {
      final isUnique =
          await AuthBloc.displayNameAvailableCheck(_displayNameController.text);

      _nameIsAvailable = isUnique;
    }

    setState(() {
      _nameIsValid = _displayNameValid();
    });
  }

  bool _displayNameValid() => _displayNameController.text.length > 2;
  bool _validateEmail() => EmailValidator.validate(_emailController.text);
  bool _validatePassword() => _passwordController.text.length > 5;

  bool _canSubmitRegisterDetails() => _validateEmail() && _validatePassword();

  Future<void> _registerNewUserAndContinue() async {
    setState(() => _registeringNewUser = true);
    try {
      await GetIt.I<AuthBloc>().registerWithEmailAndPassword(
          _displayNameController.text,
          _emailController.text,
          _passwordController.text);
    } catch (e) {
      printLog(e.toString());
      if (mounted) setState(() => _registrationError = e.toString());
    } finally {
      setState(() => _registeringNewUser = false);
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle(
          'Welcome to Sofie Beta!',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const SizedBox(height: 8),
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
          Expanded(
            child: RegisterDetails(
              canSubmit: _canSubmitRegisterDetails,
              displayNameController: _displayNameController,
              nameIsValid: _nameIsValid,
              nameIsAvailable: _nameIsAvailable,
              passwordController: _passwordController,
              emailController: _emailController,
              registerNewUserAndContinue: _registerNewUserAndContinue,
              validateEmail: _validateEmail,
              validatePassword: _validatePassword,
              registeringNewUser: _registeringNewUser,
            ),
          ),
        ]),
      ),
    );
  }
}
