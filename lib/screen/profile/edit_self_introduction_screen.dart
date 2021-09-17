import 'package:flutter/material.dart';
import 'package:location_based_social_app/exception/http_exception.dart';
import 'package:location_based_social_app/provider/user_provider.dart';
import 'package:location_based_social_app/util/constant.dart';
import 'package:location_based_social_app/util/dialog_util.dart';
import 'package:location_based_social_app/widget/create_post/multiline_text_field.dart';
import 'package:provider/provider.dart';

/// screen to create or update self intro
class EditSelfIntroductionScreen extends StatefulWidget {
  static const String router = 'EditSelfIntroductionScreen';

  @override
  _EditSelfIntroductionScreenState createState() => _EditSelfIntroductionScreenState();
}

class _EditSelfIntroductionScreenState extends State<EditSelfIntroductionScreen> {

  String introduction = '';

  void onEditText(String text) {
    setState(() {
      introduction = text;
    });
  }

  void onClickOk(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).updateUserInfo(selfIntroduction: introduction);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      renderErrorDialog(context, error.message);
    } catch (error) {
      renderErrorDialog(context, EditSelfIntroductionScreenConstant.FAILED_TO_UPDATE_SLEF_INTRO_ERROR_MESSAGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(EditSelfIntroductionScreenConstant.TITLE),
        actions: [
          TextButton(
            onPressed: () {
              onClickOk(context);
            },
            child: Text(EditSelfIntroductionScreenConstant.OK, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 17),),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MultilineTextField(
          onEdit: onEditText,
          hint: EditSelfIntroductionScreenConstant.HINT,
        ),
      ),
    );
  }
}
