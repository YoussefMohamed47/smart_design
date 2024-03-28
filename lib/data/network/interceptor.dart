import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/Caching/AppResponseCacheService.dart';
import '../../app/app_prefs.dart';
import '../../app/app_shared.dart';
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
  Future<bool> callRefreshTokenApi(DioException error) async {
    if (error.type == DioExceptionType.badResponse) {
      print("error.response!.statusCode dddd ${error.response!.statusCode}");
      //On authToken expiry ( Status Code 401) try to request new one with refresh token
      //if refreshing authToken token fails delete authToken and redirect to login page
      if (error.response != null && error.response!.statusCode == 401) {
        final AppPreferences _appPreferences = instance<AppPreferences>();

        //  String? refreshToken = await _appPreferences.getRemeberToken();
        //print("refreshToken $refreshToken");
        try {
          Future.wait([
            AppResponseCacheService.clearAllAppCacheResponse(),
            _appPreferences.logout(),
          ]).then((_) {
            Phoenix.rebirth(AppShared.navKey.currentContext!);
          });
        } catch (e) {
          print("callRefreshTokenApi error >>>>>>>>>>>>>. $e");
          return false;
        }
      }
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
          print("Error Happened in errorInterceptor: $e");
          handler.reject(e);
        });
      }
    }
    print("Errrrrrrrr ${error.response}");
    print("Errrrrrrrr ${error}");
    print(
        "Error Happened in errorInterceptor: ${json.decode(error.response.toString())}");
    // callRefreshTokenApi(error);
    Fluttertoast.showToast(
        msg: json.decode(error.response.toString())["message"].toString() ?? '',
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
    String? userToken = await _appPreferences.getAccessToken();
    // if (userToken != null) {
    //   print("There is Token");
    //   requestOptions.headers[HttpHeaders.authorizationHeader] =
    //       "Bearer $userToken";
    // }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('lang From interceptor ${prefs.getString('lang')}');
    String language = prefs.getString('lang') ?? "en";
    if (userToken != null && userToken.isNotEmpty) {
      print("There is Token");
      requestOptions.headers[HttpHeaders.authorizationHeader] =
          "Bearer $userToken";
      requestOptions.headers[HttpHeaders.acceptLanguageHeader] =
          language == "en" ? "ar" : "en";
    }
    //AppShared.menuPageViewModel.refreshToken();
    //requestOptions.queryParameters["culture"] = LocalizationService().currentLocale.languageCode;
    handler.next(requestOptions);
  }
}
