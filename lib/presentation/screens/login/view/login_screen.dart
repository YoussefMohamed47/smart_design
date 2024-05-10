import 'package:clean_arch_base/app/di.dart';
import 'package:clean_arch_base/domain/usecase/login/login_use_case.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_button.dart';
import 'package:clean_arch_base/presentation/common/widget/custom_text_field.dart';
import 'package:clean_arch_base/presentation/common/widget/loading_widget.dart';
import 'package:clean_arch_base/presentation/resources/assets_manager.dart';
import 'package:clean_arch_base/presentation/screens/login/view%20model/login_view_model.dart';
import 'package:clean_arch_base/utils/strings/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel _loginViewModel = instance<LoginViewModel>();
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _loginViewModel.start();
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
        child: StreamBuilder<LoginUseCaseModel>(
            stream: _loginViewModel.outputLoginContent,
            builder: (context, snapshot) {
              LoginUseCaseModel? data = snapshot.data;
              return data != null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Form(
                          key: data.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageAssets.logo,
                                height: 100.h,
                              ),
                              SizedBox(height: 30.h),
                              Text(
                                'Sign in Your Account',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: HexColor('1f2f62'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Enter Your Username and Password\n Sent to your email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 30.h),
                              CustomTextField(
                                textEditingController: data.userNameController,
                                keyboardType: TextInputType.text,
                                borderColor: Colors.transparent,
                                fieldValidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                hint: 'User Name',
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
                              const SizedBox(height: 20),
                              CustomTextField(
                                textEditingController: data.passwordController,
                                keyboardType: TextInputType.text,
                                borderColor: Colors.transparent,
                                fieldValidator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                hint: 'Password',
                                hintTextColor: HexColor('989797'),
                                hintFontFamily:
                                    AppStringsFonts.fontFamilyRegular,
                                hintFontSize: 12.sp,
                                isPassword: true,
                                fillColor: Colors.white,
                                borderRadius: 16,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: HexColor('b8b8b8'),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40.h),
                              CustomButton(
                                width: 200.w,
                                height: 30.h,
                                title: 'Login',
                                borderRadius: 16,
                                fontFamily: AppStringsFonts.fontFamilyRegular,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                                buttonColor: HexColor('1f2f62'),
                                textColor: Colors.white,
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
