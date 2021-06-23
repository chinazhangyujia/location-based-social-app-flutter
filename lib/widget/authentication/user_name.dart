import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  final void Function(String) _setUserName;
  final void Function(int) _setStep;

  const UserName(this._setUserName, this._setStep);

  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  String _userName = '';
  String _errorMessage;

  String _getInputError() {
    if (_userName.length < 4) {
      return 'user name is too short';
    }

    if (_userName.contains(' ')) {
      return 'user name should not contains space';
    }

    if (_userName.contains('_')) {
      return 'user name should not contains _';
    }

    return null;
  }

  void _onClickNext() {
    final String inputError = _getInputError();
    if (inputError != null) {
      setState(() {
        _errorMessage = inputError;
      });
      return;
    }

    widget._setUserName(_userName);
    widget._setStep(2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'User Name',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                    onChanged: (value) {
                      _userName = value;
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
                  onPressed: _onClickNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    primary: Theme.of(context).accentColor,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  )
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 150,
            alignment: Alignment.centerLeft,
            child: BackButton(
              onPressed: () {
                widget._setStep(0);
              },
            )),
      ],
    );
  }
}
