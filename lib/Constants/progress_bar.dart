import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'app_const.dart';

class Progressbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.stretchedDots(
            color: AppConst.blue, size: 50));
  }
}
