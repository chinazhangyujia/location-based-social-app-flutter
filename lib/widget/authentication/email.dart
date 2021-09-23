import 'package:flutter/material.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/widget/authentication/sized_box_title.dart';

class Email extends StatefulWidget {
  final void Function(String) _setPath;
  final void Function(int) _setStep;
  final void Function(String) _setEmail;
  final void Function(BuildContext) _submit;

  const Email(
      this._setPath, this._setStep, this._setEmail, this._submit);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  String _errorMessage;
  String _email = '';

  String _getInputError() {
    if (_email.isEmpty || !_email.contains('@') || !_email.endsWith('.com')) {
      return AuthStepsScreenConstant.INVALID_EMAIL_ERRROR_MESSAGE;
    }

    return null;
  }

  void _onClickNext(BuildContext context) {
    final String inputError = _getInputError();
    if (inputError != null) {
      setState(() {
        _errorMessage = inputError;
      });
      return;
    }

    widget._setEmail(_email);
    widget._setStep(1);
    widget._submit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBoxTitle(AuthStepsScreenConstant.SIGN_UP_TITLE),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      AuthStepsScreenConstant.EMAIL,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(width: 2)),
                        filled: true,
                        fillColor: Colors.white),
                    style: const TextStyle(fontSize: 20),
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ],
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  child: (_errorMessage != null)
                      ? Text(
                          _errorMessage,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).errorColor),
                        )
                      : null),
              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                    onPressed: () {
                      _onClickNext(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).accentColor,
                    ),
                    child: const Text(
                      AuthStepsScreenConstant.NEXT,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
        Container(
            height: 150,
            alignment: Alignment.centerLeft,
            child: BackButton(
              onPressed: () {
                widget._setPath(null);
              },
            )),
      ],
    );
  }
}
