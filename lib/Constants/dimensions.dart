import 'package:flutter/material.dart';

class TSizes {
// Define MediaQuery constants
  static final heightMQ = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .size
      .height;
  static final widthMQ = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .size
      .width;
  static final aspectRatioMQ = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .size
      .aspectRatio;

  static final largeTextSize = TSizes.widthMQ * 0.042;
  static final extraLargeTextSize = TSizes.widthMQ * 0.05;
  static final mediumTextSize = TSizes.widthMQ * 0.035;
  static final smallTextSize = TSizes.widthMQ * 0.03;
}
