import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  final void Function(String) onEdit;
  final String hint;

  const MultilineTextField({@required this.onEdit, @required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.blueAccent,
      onChanged: onEdit,
      maxLines: null,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
      ),
    );
  }
}
