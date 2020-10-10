import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  final Function onEdit;

  MultilineTextField(this.onEdit);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onEdit,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Post something about what you see...',
      ),
    );
  }
}
