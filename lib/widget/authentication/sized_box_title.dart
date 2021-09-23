
import 'package:flutter/material.dart';

class SizedBoxTitle extends StatelessWidget {

  final String title;

  const SizedBoxTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text(
          title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
