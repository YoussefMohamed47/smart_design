import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../utils/colors/appColors.dart';

class Loading extends StatefulWidget {
  final Color color;
  const Loading({Key? key, this.color = AppColors.orangeColor})
      : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200));
    });
    super.initState();
  }

  @override
  dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: widget.color,
      size: 50.0.sp,
      controller: animationController,
    );

    //   CircularProgressIndicator(
    //   valueColor:  AlwaysStoppedAnimation<Color>(ColorManager.black),
    // );
  }
}
