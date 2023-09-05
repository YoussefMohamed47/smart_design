import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/resources/color_manager.dart';
import '../presentation/resources/font_manager.dart';
import 'Caching/generic_cache.dart';
import 'di.dart';

class AppShared {
  static final navKey = GlobalKey<NavigatorState>();
  static bool hasToken = false;
  static String token = '';
  static String remebertoken = '';
  static String deviceId = '';
  static GenericCache genericCache = GenericCache.instance;
  static noSupportAlert() {
    return showDialog(
        context: AppShared.navKey.currentContext!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'ملف غير مدعوم',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorManager.mnsaColorlack,
                    fontFamily: FontConstants.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "صيغة هذا الملف غير مدعومة",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorManager.secondTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          constraints: BoxConstraints(minWidth: 48.w),
                          decoration: BoxDecoration(
                            color: ColorManager.mnsaColorlack,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0.w, vertical: 8.h),
                            child: Text(
                              'موافق',
                              style: TextStyle(
                                color: ColorManager.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])
              ],
            ),
          );
        });
  }
}
