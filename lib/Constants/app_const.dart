import 'dart:ui';

import 'package:flutter/material.dart';

class AppConst {
  static const Color blue = Color.fromRGBO(10, 80, 190, 1);
  static const Color lightGrey = Color(0xFFF5F9FD);
  static const Color darkGrey = Color.fromRGBO(205, 210, 220, 1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const String poppins = 'Poppins';
  static void showSimpleToast(BuildContext context, String message,
      {int duration = 4}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'HIDE',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    );
    scaffold.showSnackBar(snackBar);
  }
}
