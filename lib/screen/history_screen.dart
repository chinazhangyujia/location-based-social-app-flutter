import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {

  final int year;
  const HistoryScreen(this.year);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(year.toString()),
      )
    );
  }
}
