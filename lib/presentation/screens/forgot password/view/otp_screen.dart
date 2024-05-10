import 'package:clean_arch_base/app/di.dart';
import 'package:clean_arch_base/app/validation.dart';
import 'package:clean_arch_base/domain/usecase/login/login_use_case.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_button.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_text_field.dart';
import 'package:clean_arch_base/presentation/common/widget/loading_widget.dart';
import 'package:clean_arch_base/presentation/resources/assets_manager.dart';
import 'package:clean_arch_base/presentation/resources/base_page_route.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/view%20model/forgot_password_view_model.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/view/change_password_screen.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/widgets/count_down_widget.dart';
import 'package:clean_arch_base/presentation/screens/login/view%20model/login_view_model.dart';
import 'package:clean_arch_base/utils/strings/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;
  final ForgotPasswordUseCaseModel data;
  const OTPScreen({super.key, required this.viewModel, required this.data});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  @override
  void dispose() {
    widget.data.controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.data.controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: widget.data
                .levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );
    widget.data.controller!.forward();
    widget.data.controller?.addListener(() {
      if (widget.data.controller?.status == AnimationStatus.completed) {
        widget.data.isTimeCompleted = true;
        widget.data.hasError = false;
        widget.viewModel.postDataToView();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: StreamBuilder<ForgotPasswordUseCaseModel>(
            stream: widget.viewModel.outputForgotPasswordContent,
            builder: (context, snapshot) {
              ForgotPasswordUseCaseModel? data = widget.data;
              return data != null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Form(
                          key: data.otpFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageAssets.logo,
                                height: 100.h,
                              ),
                              SizedBox(height: 30.h),
                              Text(
                                'OTP Verification',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: HexColor('1f2f62'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "We've sent a 4-digit code to your phone.\n Please Enter it below to proceedX",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: HexColor('878686'),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 30.h),
                              Center(
                                child: PinCodeTextField(
                                  appContext: context,
                                  length: 4,
                                  autoDisposeControllers: false,
                                  enableActiveFill: true,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.fade,
                                  cursorColor: HexColor('#1f2f62'),
                                  validator: (value) =>
                                      Validation.isEmptyValidator(
                                          context, value, "OTP"),
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 2,
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  backgroundColor: Colors.white,
                                  blinkWhenObscuring: false,
                                  hintCharacter: '-',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontFamily:
                                        AppStringsFonts.fontFamilyRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    fieldHeight: 40.h,
                                    fieldWidth: 40.w,
                                    borderWidth: 1.sp,
                                    selectedColor: Colors.white,
                                    inactiveColor: Colors.grey.withOpacity(0.4),
                                    activeFillColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    activeColor: Colors.white,
                                    disabledColor: Colors.white,
                                    inActiveBoxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    activeBoxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8.r),
                                    activeBorderWidth: 1.sp,
                                    errorBorderWidth: 1.sp,
                                    disabledBorderWidth: 1.sp,
                                    inactiveBorderWidth: 1.sp,
                                    selectedBorderWidth: 1.sp,
                                    errorBorderColor: Colors.red,
                                  ),
                                  errorAnimationController:
                                      data.errorController,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  textStyle: TextStyle(
                                    color: data.hasError
                                        ? Colors.red
                                        : HexColor('#1f2f62'),
                                    fontSize: 16.sp,
                                    fontFamily:
                                        AppStringsFonts.fontFamilyRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: data.otpController,
                                  onCompleted: (v) {
                                    print("Completed");
                                  },
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      //currentText = value;
                                    });
                                  },
                                  onTap: () {
                                    print("Pressed");
                                    if (data.hasError) {
                                      data.errorController
                                          .add(ErrorAnimationType.clear);
                                      data.hasError = false;
                                      widget.viewModel.postDataToView();
                                    }
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      color: HexColor('989797'),
                                      fontSize: 12.sp,
                                      fontFamily:
                                          AppStringsFonts.fontFamilyMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Countdown(
                                    animation: StepTween(
                                      begin: data.levelClock,
                                      end: 0,
                                    ).animate(data.controller!),
                                    key: UniqueKey(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                width: 200.w,
                                height: 35.h,
                                title: 'Submit',
                                borderRadius: 16,
                                fontFamily: AppStringsFonts.fontFamilyRegular,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                                buttonColor: HexColor('1f2f62'),
                                textColor: Colors.white,
                                onpress: () {
                                  Navigator.push(
                                      context,
                                      BasePageRoute(
                                          builder: (_) => ChangePasswordScreen(
                                              viewModel: widget.viewModel,
                                              data: data)));
                                },
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive any code?",
                                    style: TextStyle(
                                      color: HexColor('989797'),
                                      fontSize: 12.sp,
                                      fontFamily:
                                          AppStringsFonts.fontFamilyMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      color: data.isTimeCompleted
                                          ? HexColor('1f2f62')
                                          : HexColor('989797'),
                                      fontSize: 12.sp,
                                      fontFamily:
                                          AppStringsFonts.fontFamilyMedium,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Loading(
                        color: HexColor('1f2f62'),
                      ),
                    );
            }),
      ),
    );
  }
}
