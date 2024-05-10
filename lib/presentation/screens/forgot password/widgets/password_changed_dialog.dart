import 'package:clean_arch_base/presentation/common/widget/custom_button.dart';
import 'package:clean_arch_base/presentation/resources/base_page_route.dart';
import 'package:clean_arch_base/presentation/screens/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../resources/assets_manager.dart';

showPasswordChangedDialog({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(8),
        content: Container(
          color: Colors.white,
          width: 280.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.resetPasswordImg,
                height: 50.h,
              ),
              SizedBox(height: 8.h),
              Text(
                'Password Changed!',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "You are all set.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 8.h),
              CustomButton(
                width: 100.w,
                height: 30.h,
                buttonColor: HexColor('1f2f62'),
                textColor: Colors.white,
                title: 'Login',
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                borderRadius: 8,
                onpress: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      BasePageRoute(builder: (_) => LoginScreen()),
                      (route) => false);
                },
              )
            ],
          ),
        ),
      );
    },
  );
}
