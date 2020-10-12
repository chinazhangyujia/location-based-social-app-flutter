import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/multiline_text_field.dart';
import 'package:provider/provider.dart';

class EditSelfIntroductionScreen extends StatefulWidget {
  static const String router = 'EditSelfIntroductionScreen';

  @override
  _EditSelfIntroductionScreenState createState() => _EditSelfIntroductionScreenState();
}

class _EditSelfIntroductionScreenState extends State<EditSelfIntroductionScreen> {

  String introduction = '';

  void onEditText(text) {
    setState(() {
      introduction = text;
    });
  }

  void onClickOk(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).updateSelfIntroduction(
          introduction);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, 'Failed to update self introduction. Please try later');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Self Introduction'),
        actions: [
          FlatButton(
            child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 17),),
            onPressed: () {
              onClickOk(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MultilineTextField(
          onEdit: onEditText,
          hint: 'Write something about yourself...',
        ),
      ),
    );
  }
}
