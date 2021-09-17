import 'package:flutter/material.dart';
import 'package:location_based_social_app/util/constant.dart';

void renderErrorDialog(BuildContext context, String message) {
  showDialog(context: context, builder: (innerContext) => AlertDialog(
    title: const Text(DialogUtilConstant.ERROR_MESSAGE),
    content: Text(message),
    actions: [
      TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(innerContext).accentColor)),
        onPressed: () {
          Navigator.of(innerContext).pop();
        },
        child: Text(DialogUtilConstant.OK, style: TextStyle(color: Theme.of(innerContext).accentColor,),)
      )
    ],
  ));
}

void renderErrorDialogWithScaffoldKey(GlobalKey<ScaffoldState> key, String message) {
  showDialog(context: key.currentContext, builder: (innerContext) => AlertDialog(
    title: const Text(DialogUtilConstant.ERROR_MESSAGE),
    content: Text(message),
    actions: [
      TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(innerContext).accentColor)),
        onPressed: () {
          Navigator.of(innerContext).pop();
        },
        child: Text(DialogUtilConstant.OK, style: TextStyle(color: Theme.of(innerContext).accentColor,),)
      )
    ],
  ));
}