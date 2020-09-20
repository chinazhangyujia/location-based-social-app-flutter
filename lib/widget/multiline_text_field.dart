import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  MultilineTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Post something about what you see...',
      ),
    );
  }
}
