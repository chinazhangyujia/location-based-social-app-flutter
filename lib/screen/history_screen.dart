import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {

  final int year;
  HistoryScreen(this.year);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(year.toString()),
        ),
      )
    );
  }
}
