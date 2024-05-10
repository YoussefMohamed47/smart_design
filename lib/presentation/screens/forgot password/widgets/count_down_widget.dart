import 'package:clean_arch_base/utils/strings/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class Countdown extends AnimatedWidget {
  Countdown({required Key key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "in $timerText sec",
      style: TextStyle(
        color: HexColor('#1f2f62'),
        fontSize: 12.sp,
        fontFamily: AppStringsFonts.fontFamilyBold,
        fontWeight: FontWeight.bold,
        //  height: 0.10,
        letterSpacing: 0.72,
      ),
    );
  }
}
