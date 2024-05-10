import 'dart:async';
import 'dart:convert';

import 'package:clean_arch_base/domain/usecase/login/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/app_shared.dart';
import '../../../../app/di.dart';
import '../../../../domain/usecase/Forgot Password/forgot_password_use_case.dart';
import '../../../base/baseviewmodel.dart';
import '../../../resources/base_page_route.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInput, ForgotPasswordViewModelOutput {
  ForgotPasswordViewModel(this._loginUseCase) : super();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  StreamController<ForgotPasswordUseCaseModel> _loginStreamController =
      StreamController<ForgotPasswordUseCaseModel>.broadcast();
  final ForgotPasswordUseCaseModel _model = ForgotPasswordUseCaseModel();
  final ForgotPasswordUseCase _loginUseCase;

  // output
  @override
  void dispose() {
    _loginStreamController.close();
  }

  @override
  Sink get inputForgotPasswordInput => _loginStreamController.sink;

  @override
  Stream<ForgotPasswordUseCaseModel> get outputForgotPasswordContent =>
      _loginStreamController.stream.map((home) => home);

  // input
  @override
  Future start() async {
    if (_loginStreamController.isClosed) {
      _loginStreamController =
          StreamController<ForgotPasswordUseCaseModel>.broadcast();
    }
    postDataToView();
  }

  postDataToView() {
    if (!_loginStreamController.isClosed) {
      inputForgotPasswordInput.add(_model);
    }
  }
}

mixin ForgotPasswordViewModelInput {
  Sink get inputForgotPasswordInput;
}

mixin ForgotPasswordViewModelOutput {
  Stream<ForgotPasswordUseCaseModel> get outputForgotPasswordContent;
}

class ForgotPasswordUseCaseModel {
  ForgotPasswordUseCaseModel();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final resetPasswordFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  bool isLoadingForgotPassword = false;
  int counter = 0;
  AnimationController? controller;
  int levelClock = 30;
  bool isTimeCompleted = false;
  bool hasError = false;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
