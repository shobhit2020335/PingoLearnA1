import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// import '../Constants/const_widget.dart';
import 'app_const.dart';

class LoadingDialog {
  void start(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
            child: LoadingAnimationWidget.stretchedDots(
                color: AppConst.blue, size: 50));
      },
    );
  }

  void stop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
