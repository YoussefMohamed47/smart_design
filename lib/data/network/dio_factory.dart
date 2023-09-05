import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app_prefs.dart';
import '../../app/constants.dart';
import 'interceptor.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";
const String device_type = "device_type";
const String device_id = "device_id";

class DioFactory {
  final AppPreferences _appPreferences;
  late final DioInterceptor dioInterceptors;
  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    dioInterceptors = DioInterceptor(dio);
    String language = await _appPreferences.getAppLanguage();
    String? token = await _appPreferences.getAccessToken() ?? '';
    String remberToken = ""; //await _appPreferences.getRemeberToken() ?? '';
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: token == '' ? '' : "Bearer $token",
      DEFAULT_LANGUAGE: 'ar',
      device_type: Platform.isAndroid ? "1" : "2",
      // device_id: AppShared.deviceId
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: Constants.apiTimeOut,
      sendTimeout: Constants.apiTimeOut,
    );

    dio.interceptors.addAll(
      [
        QueuedInterceptorsWrapper(
            onRequest:
                (RequestOptions options, RequestInterceptorHandler handler) =>
                    dioInterceptors.requestInterceptor(options, handler),
            onResponse:
                (Response response, ResponseInterceptorHandler handler) =>
                    dioInterceptors.responseInterceptor(response, handler),
            onError: (DioError error, ErrorInterceptorHandler handler) {
              print("kkkkkkkkkkkkkkkkkjhkg");
              dioInterceptors.errorInterceptor(error, handler);
            }),
        // performanceInterceptor,
        // its debug mode so print app logs
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        )
      ],
    );

    // if (!kReleaseMode) {
    //   // its debug mode so print app logs
    //   dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseHeader: true,
    //   ));
    // }
    return dio;
  }
}
