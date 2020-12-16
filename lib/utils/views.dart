import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:empty_widget/empty_widget.dart';

import '../main.dart';
 
  

class AppButton extends StatelessWidget {
  String text;
  Color color;
  Function onTap;
  double width, height;

  AppButton(
      {this.text,
      this.color = accentColor,
      this.width = 40,
      this.height = 10,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        color: color,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: color,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}

void toast(message) {
  if (message != null) {
    showToast(
      message,
      duration: Duration(seconds: 4),
      position: ToastPosition.bottom,
      backgroundColor: Colors.blueGrey,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
    );
  }
}
