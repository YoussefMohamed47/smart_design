import 'package:clean_arch_base/app/di.dart';
import 'package:clean_arch_base/domain/usecase/login/login_use_case.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_button.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_text_field.dart';
import 'package:clean_arch_base/presentation/common/widget/loading_widget.dart';
import 'package:clean_arch_base/presentation/resources/assets_manager.dart';
import 'package:clean_arch_base/presentation/resources/base_page_route.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/view%20model/forgot_password_view_model.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/view/otp_screen.dart';
import 'package:clean_arch_base/presentation/screens/forgot%20password/widgets/password_changed_dialog.dart';
import 'package:clean_arch_base/presentation/screens/login/view%20model/login_view_model.dart';
import 'package:clean_arch_base/utils/strings/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class ChangePasswordScreen extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;
  final ForgotPasswordUseCaseModel data;

  const ChangePasswordScreen(
      {super.key, required this.viewModel, required this.data});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ForgotPasswordViewModel _forgotPasswordViewModel =
      instance<ForgotPasswordViewModel>();
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _forgotPasswordViewModel.start();
    });
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
            stream: _forgotPasswordViewModel.outputForgotPasswordContent,
            builder: (context, snapshot) {
              ForgotPasswordUseCaseModel? data = snapshot.data;
              return data != null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Form(
                          key: data.changePasswordFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageAssets.logo,
                                height: 100.h,
                              ),
                              SizedBox(height: 30.h),
                              Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: HexColor('1f2f62'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Enter New Password to reset your\n password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: HexColor('878686'),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 30.h),
                              CustomTextField(
                                textEditingController:
                                    data.currentPasswordController,
                                keyboardType: TextInputType.phone,
                                isPassword: true,
                                borderColor: Colors.transparent,
                                fieldValidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your current password';
                                  }
                                  return null;
                                },
                                hint: 'Current Password',
                                hintTextColor: HexColor('989797'),
                                hintFontFamily:
                                    AppStringsFonts.fontFamilyRegular,
                                hintFontSize: 12.sp,
                                fillColor: Colors.white,
                                borderRadius: 16,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                textEditingController:
                                    data.newPasswordController,
                                keyboardType: TextInputType.phone,
                                isPassword: true,
                                borderColor: Colors.transparent,
                                fieldValidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your New password';
                                  }
                                  return null;
                                },
                                hint: 'New Password',
                                hintTextColor: HexColor('989797'),
                                hintFontFamily:
                                    AppStringsFonts.fontFamilyRegular,
                                hintFontSize: 12.sp,
                                fillColor: Colors.white,
                                borderRadius: 16,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                textEditingController:
                                    data.confirmPasswordController,
                                keyboardType: TextInputType.phone,
                                isPassword: true,
                                borderColor: Colors.transparent,
                                onChanged: (String value) {
                                  data.changePasswordFormKey.currentState!
                                      .validate(); // if (data.loginEmailController.text
                                },
                                fieldValidator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter password';
                                  } else if (value !=
                                      data.newPasswordController.text) {
                                    return 'Password does not match';
                                  }
                                },
                                hint: 'Confirm New Password',
                                hintTextColor: HexColor('989797'),
                                hintFontFamily:
                                    AppStringsFonts.fontFamilyRegular,
                                hintFontSize: 12.sp,
                                fillColor: Colors.white,
                                borderRadius: 16,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                width: 200.w,
                                height: 35.h,
                                title: 'CONFIRM',
                                borderRadius: 16,
                                fontFamily: AppStringsFonts.fontFamilyRegular,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                                buttonColor: HexColor('1f2f62'),
                                textColor: Colors.white,
                                onpress: () {
                                  if (data.changePasswordFormKey.currentState!
                                      .validate()) {
                                    showPasswordChangedDialog(context: context);
                                  }
                                },
                              )
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
