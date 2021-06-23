import 'package:flutter/material.dart';

/// First page the user see
/// Welcome text. User can choose signin or signup
class Welcome extends StatelessWidget {
  final void Function(String) _setPath;
  final void Function(int) _setStep;

  const Welcome(this._setPath, this._setStep);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  '🎉 Welcome',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ))),
        const Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "This is a location based social app. You can see people's posts without adding them friend. Every post is attached to the location where people sent it. Once you get into the range, you will see these posts around you.",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setPath('signup');
                    _setStep(0);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    primary: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _setPath('signin');
                    _setStep(0);
                  },
                  child: Text(
                    'Already had account? Sign in',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
