import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  final Function onEdit;
  final String hint;

  MultilineTextField({@required this.onEdit, @required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.blueAccent,
      onChanged: onEdit,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
      ),
    );
  }
}
