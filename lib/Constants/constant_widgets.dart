import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/Constants/app_const.dart';

import 'constant_functions.dart';
import 'dimensions.dart';

class ConstantWidgets {
  static Widget navDrawer(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    return Drawer(
      width: TSizes.widthMQ * 0.7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: TSizes.aspectRatioMQ * 400,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: AppConst.blue,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: AppConst.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConst.poppins,
                      ),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: InkWell(
              onTap: () {
                ConstantFunctions.showLogoutDialogBox(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: AppConst.poppins,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget customButton(VoidCallback onTap, String buttonText) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: TSizes.widthMQ * .5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: AppConst.blue),
        child: Center(
          child: Text(buttonText,
              style: AppStyles.defaultTextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  static Widget customTextField(TextEditingController controller,
      String hintText, String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppConst.white, // Border color when not focused
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppConst.white, // Border color when focused
            width: 2.0,
          ),
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      ),
      validator: validator,
    );
  }
}

class AppStyles {
  static TextStyle defaultTextStyle(
      {double fontSize = 16.0,
      FontStyle fontStyle = FontStyle.normal,
      Color color = AppConst.black,
      String fontFamily = AppConst.poppins,
      FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontStyle: fontStyle,
        fontWeight: fontWeight);
  }
}
