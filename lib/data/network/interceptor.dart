import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../presentation/resources/color_manager.dart';
import 'network_info.dart';

class DioInterceptor {
  // final UserCredentialsService userCredentialsService =
  //     UserCredentialsService.instance;
  late Dio dioCall;
  // late AppAuthServiceClient _appAuthServiceClient;
  // late  lateAuthRemoteDataSource _remoteDataSource ;
  InternetConnectionChecker _internetConnectionChecker =
      InternetConnectionChecker();
  late NetworkInfo _networkInfo = NetworkInfoImpl(_internetConnectionChecker);
  // late AuthRepository _repository = AuthRepositoryImpl(_remoteDataSource, _networkInfo, userCredentialsService);

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) {});
  }

  DioInterceptor(dio) {
    dioCall = dio;
    //_appAuthServiceClient = AppAuthServiceClient(dio,baseUrl: Constants.baseUrl);
    // _remoteDataSource =  AuthRemoteDataSourceImpl(_appAuthServiceClient);
  }
  void prints(var s1) {
    String s = s1.toString();
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => print(match.group(0)));
  }

  // get new auth token via refresh token
  Future<bool> callRefreshTokenApi(DioError error) async {
    if (error.type == DioErrorType.response) {
      print("error.response!.statusCode dddd ${error.response!.statusCode}");
      //On authToken expiry ( Status Code 401) try to request new one with refresh token
      //if refreshing authToken token fails delete authToken and redirect to login page
      // if (error.response != null && error.response!.statusCode == 401) {
      //   final AppPreferences _appPreferences = instance<AppPreferences>();
      //   String? refreshToken = await _appPreferences.getRemeberToken();
      //   print("refreshToken $refreshToken");
      //   try {
      //     var url = Uri.parse(
      //         "https://api.platform.mainasat.com/api/v1/auth/login-with-remember");
      //     var response = await http.post(url,
      //         body: {"remember_token": "$refreshToken"},
      //         headers: {"accept": "application/json"});
      //     print('Response status: ${response.statusCode}');
      //     print('Response body: ${response.body}');
      //     if (response.statusCode == 400) {
      //       // Provider.of<PlayerService>(AppShared.navKey.currentContext!,
      //       //         listen: false)
      //       //     .setToken(null);
      //       return false;
      //     } else {
      //       print("responseresponse $response");
      //       print("responseresponse body ${response.body}");
      //       print("responseresponse body ${response.body}");

      //       var res = json.decode(response.body);
      //       print("responseresponse body ${res["access_token"]}");
      //       print("responseresponse body ${res["item"]["remember_token"]}");
      //       print("responseresponse body ${res["item"]["name"]}");
      //       print("responseresponse body ${res["item"]["email"]}");

      //       AppShared.token = res["access_token"] ?? '';
      //       AppShared.remebertoken = res["item"]["remember_token"] ?? '';
      //       _appPreferences.setAccessToken(res["access_token"]);
      //       _appPreferences.setRemeberToken(res["item"]["remember_token"]);
      //       _appPreferences.setName(res["item"]["name"]);
      //       _appPreferences.setEmail(res["item"]["email"]);
      //       var options = error.response!.requestOptions;
      //       options.headers[HttpHeaders.authorizationHeader] =
      //           "Bearer ${res["access_token"]}";
      //       return true;
      //     }
      //   } catch (e) {
      //     print("er >>>>>>>>>>>>>. $e");
      //     return false;
      //   }
      // }
    }
    return false;
  }

  dynamic errorInterceptor(
      DioError error, ErrorInterceptorHandler handler) async {
    if (error.response != null && error.response!.statusCode == 401) {
      bool reCall = await callRefreshTokenApi(error);
      if (reCall) {
        var options = error.response!.requestOptions;
        dioCall.fetch(options).then((r) => handler.resolve(r), onError: (e) {
          handler.reject(e);
        });
      }
    }
    // callRefreshTokenApi(error);
    Fluttertoast.showToast(
        msg: error.response?.data['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.error,
        textColor: Colors.white,
        fontSize: 16.0);
    handler.next(error);
  }

  // todo : cache data on local storage
  dynamic responseInterceptor(
      Response response, ResponseInterceptorHandler handler) async {
    //AppShared.isDeviceOffline.value=false;
    printWrapped("response is $response");
    handler.next(response);
  }

  // add user token and local language on the request's header
  dynamic requestInterceptor(
      RequestOptions requestOptions, RequestInterceptorHandler handler) async {
    final AppPreferences _appPreferences = instance<AppPreferences>();
    String? userToken = ""; //await _appPreferences.getAccessToken();
    // if (userToken != null) {
    //   print("There is Token");
    //   requestOptions.headers[HttpHeaders.authorizationHeader] =
    //       "Bearer $userToken";
    // }
    if (userToken != null && userToken.isNotEmpty) {
      print("There is Token");
      requestOptions.headers[HttpHeaders.authorizationHeader] =
          "Bearer $userToken";
    }
    //AppShared.menuPageViewModel.refreshToken();
    //requestOptions.queryParameters["culture"] = LocalizationService().currentLocale.languageCode;
    handler.next(requestOptions);
  }
}
