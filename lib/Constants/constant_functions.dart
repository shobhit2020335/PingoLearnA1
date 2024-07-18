import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Views/Auth/signup.dart';

class ConstantFunctions {
  static void showLogoutDialogBox(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await logoutUser(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> logoutUser(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Signup()),
        (Route<dynamic> route) => false,
      );
      print('User logged out');
    } catch (e) {
      print('Error logging out user: $e');
    }
  }
}
