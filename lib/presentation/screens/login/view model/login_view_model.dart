import 'dart:async';
import 'dart:convert';

import 'package:clean_arch_base/domain/usecase/login/login_use_case.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/app_shared.dart';
import '../../../../app/di.dart';
import '../../../base/baseviewmodel.dart';
import '../../../resources/base_page_route.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInput, LoginViewModelOutput {
  LoginViewModel(this._loginUseCase) : super();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  StreamController<LoginUseCaseModel> _loginStreamController =
      StreamController<LoginUseCaseModel>.broadcast();
  final LoginUseCaseModel _model = LoginUseCaseModel();
  final LoginUseCase _loginUseCase;

  // output
  @override
  void dispose() {
    _loginStreamController.close();
  }

  @override
  Sink get inputLoginInput => _loginStreamController.sink;

  @override
  Stream<LoginUseCaseModel> get outputLoginContent =>
      _loginStreamController.stream.map((home) => home);

  // input
  @override
  Future start() async {
    if (_loginStreamController.isClosed) {
      _loginStreamController = StreamController<LoginUseCaseModel>.broadcast();
    }
    postDataToView();
  }

  postDataToView() {
    if (!_loginStreamController.isClosed) {
      inputLoginInput.add(_model);
    }
  }
}

mixin LoginViewModelInput {
  Sink get inputLoginInput;
}

mixin LoginViewModelOutput {
  Stream<LoginUseCaseModel> get outputLoginContent;
}

class LoginUseCaseModel {
  LoginUseCaseModel();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoadingLogin = false;
  bool hasError = false;
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
