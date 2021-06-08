import 'package:flutter/material.dart';

void renderErrorDialog(BuildContext context, String message) {
  showDialog(context: context, builder: (context) => AlertDialog(
    title: const Text('An Error Occurred'),
    content: Text(message),
    actions: [
      TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor)),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor,),)
      )
    ],
  ));
}