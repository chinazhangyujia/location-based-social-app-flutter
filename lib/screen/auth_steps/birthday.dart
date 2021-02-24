import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Birthday extends StatefulWidget {
  final void Function(String) _setBirthdayString;
  final void Function(int) _setStep;
  final void Function(BuildContext) _submit;

  Birthday(this._setBirthdayString, this._setStep, this._submit);

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  String _errorMessage;
  DateTime _birthday;

  String _getInputError() {
    if (_birthday == null) {
      return 'Please select your birthday';
    }

    return null;
  }

  void _onClickNext(BuildContext context) {
    String inputError = _getInputError();
    if (inputError != null) {
      setState(() {
        _errorMessage = inputError;
      });
      return;
    }

    widget._setBirthdayString(DateFormat("yyyy-MM-dd").format(_birthday));
    widget._submit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Birthday',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DateTimeField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(width: 2)),
                          filled: true,
                          fillColor: Colors.white),
                      style: TextStyle(fontSize: 20),
                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).accentColor,
                                      onPrimary: Theme.of(context).primaryColor,
                                    ),
                                    dialogBackgroundColor:
                                        Theme.of(context).primaryColor),
                                child: child,
                              );
                            });
                      },
                      onChanged: (value) {
                        print(value);
                        _birthday = value;
                      },
                    )
                  ],
                ),
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
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: RaisedButton(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    _onClickNext(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Theme.of(context).accentColor,
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
                widget._setStep(1);
              },
            )),
      ],
    );
  }
}
