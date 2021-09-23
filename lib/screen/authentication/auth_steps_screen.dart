import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/provider/auth_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/widget/authentication/email.dart';
import 'package:location_based_social_app/widget/authentication/password.dart';
import 'package:location_based_social_app/widget/authentication/email_and_password.dart';
import 'package:location_based_social_app/widget/authentication/user_name.dart';
import 'package:location_based_social_app/widget/authentication/welcome.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:provider/provider.dart';

/// signin signup steps page
class AuthStepsScreen extends StatefulWidget {
  @override
  _AuthStepsScreenState createState() => _AuthStepsScreenState();
}

class _AuthStepsScreenState extends State<AuthStepsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _path;
  int _currentStep = 0;
  bool _loading = false;

  final Map<String, String> _signInData = {
    'email': '',
    'password': '',
  };
  final Map<String, String> _signUpData = {
    'email': '',
    'password': '',
    'nickname': '',
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
      setState(() {
        _loading = true;
      });
      await authProvider.login(_signInData['email'], _signInData['password']).timeout(const Duration(seconds: 2));
    } on HttpException catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, error.toString());
    } on TimeoutException catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, AuthStepsScreenConstant.SIGNIN_TIMEOUT_ERROR_MESSAGE);
    } catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, AuthStepsScreenConstant.AUTH_FAILURE_ERROR_MESSAGE);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _submitForSignUp(BuildContext context) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      setState(() {
        _loading = true;
      });
      await authProvider.signup(_signUpData['email'], _signUpData['password'],
          _signUpData['nickname']).timeout(const Duration(seconds: 2));
    } on HttpException catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, error.toString());
    } on TimeoutException catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, AuthStepsScreenConstant.SIGNUP_TIMEOUT_ERROR_MESSAGE);
    } catch (error) {
      renderErrorDialogWithScaffoldKey(_scaffoldKey, AuthStepsScreenConstant.AUTH_FAILURE_ERROR_MESSAGE);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _setEmailAndPasswordSignIn(String email, String password) async {
    _signInData['email'] = email;
    _signInData['password'] = password;
  }

  void _setEmailSignUp(String email) {
    _signUpData['email'] = email;
  }
  
  void _setPasswordSignUp(String password) {
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
        Email(_setPath, _setStep, _setEmailSignUp, (_) {}),
        Password(_setStep, _setPasswordSignUp, (_) {}),
        UserName(_setUserName, _setStep, _submitForSignUp)
      ]
    };

    return _loading ? 
    Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: CircularProgressIndicator(color: Theme.of(context).accentColor),
      ),
    ) : Scaffold(
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
