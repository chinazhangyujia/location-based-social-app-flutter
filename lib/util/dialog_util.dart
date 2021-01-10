import 'package:flutter/material.dart';

Function renderErrorDialog = (BuildContext context, String message) {
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text('An Error Occurred'),
    content: Text(message),
    actions: [
      FlatButton(
        textColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor,),)
      )
    ],
  ));
};