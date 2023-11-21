import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilsDialogs {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(BuildContext context, String? text,
      {Color color = Colors.red}) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: color);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future showIndicatorDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator(),
            ));
  }

  static Future closeDialogNoReturn(context) async {
    Navigator.of(context, rootNavigator: true)
        .pop(); // pop(result)로 할 수도 있음, result는 dialog의 리턴값(유저인풋)
  }
}
