import 'package:flutter/material.dart';

class SingleOptionPageOpener extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function onTap;

  SingleOptionPageOpener({
    @required this.icon,
    @required this.title,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Row(
          children: [
            icon,
            SizedBox(width: 8,),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            Spacer(),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
}
