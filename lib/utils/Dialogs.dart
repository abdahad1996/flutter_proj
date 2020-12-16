import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../main.dart';
import 'views.dart';

class Dialogs {

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.black54,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: accentColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
