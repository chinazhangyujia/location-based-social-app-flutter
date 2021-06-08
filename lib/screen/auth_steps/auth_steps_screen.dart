import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/screen/auth_steps/birthday.dart';
import 'package:location_based_social_app/screen/auth_steps/email_and_password.dart';
import 'package:location_based_social_app/screen/auth_steps/user_name.dart';
import 'package:location_based_social_app/screen/auth_steps/welcome.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

class AuthStepsScreen extends StatefulWidget {
  @override
  _AuthStepsScreenState createState() => _AuthStepsScreenState();
}

class _AuthStepsScreenState extends State<AuthStepsScreen> {
  String _path;
  int _currentStep = 0;

  final Map<String, String> _signInData = {
    'email': '',
    'password': '',
  };
  final Map<String, String> _signUpData = {
    'email': '',
    'password': '',
    'nickname': '',
    'birthday': ''
  };

  void _setStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _submitForSignIn(BuildContext context) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.login(_signInData['email'], _signInData['password']);
    } on HttpException catch (error) {
      renderErrorDialog(context, error.toString());
    } catch (error) {
      renderErrorDialog(context, 'Authentication failed. Please try later.');
    }
  }

  void _submitForSignUp(BuildContext context) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.signup(_signUpData['email'], _signUpData['password'],
          _signUpData['nickname'], _signUpData['birthday']);
    } on HttpException catch (error) {
      renderErrorDialog(context, error.toString());
    } catch (error) {
      renderErrorDialog(context, 'Authentication failed. Please try later.');
    }
  }

  void _setBirthdayString(String birthday) {
    _signUpData['birthday'] = birthday;
  }

  void _setEmailAndPasswordSignIn(String email, String password) async {
    _signInData['email'] = email;
    _signInData['password'] = password;
  }

  void _setEmailAndPasswordSignUp(String email, String password) {
    _signUpData['email'] = email;
    _signUpData['password'] = password;
  }

  void _setUserName(String userName) {
    _signUpData['nickname'] = userName;
  }

  void _setPath(String path) {
    setState(() {
      _path = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Widget>> _steps = {
      'signin': [
        EmailAndPassword(
            _setPath, (_) {}, _setEmailAndPasswordSignIn, _submitForSignIn)
      ],
      'signup': [
        EmailAndPassword(
            _setPath, _setStep, _setEmailAndPasswordSignUp, (_) {}),
        UserName(_setUserName, _setStep),
        Birthday(_setBirthdayString, _setStep, _submitForSignUp)
      ]
    };

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _path == null
            ? Welcome(_setPath, _setStep)
            : _steps[_path][_currentStep],
      ),
    );
  }
}
