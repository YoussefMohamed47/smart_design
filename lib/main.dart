import 'dart:io';

import 'package:clean_arch_base/presentation/screens/app%20walkthrough/app_walkthrought.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'app/Caching/AppResponseCacheService.dart';
import 'app/app_shared.dart';
import 'app/di.dart';
import 'presentation/resources/langauge_manager.dart';
import 'presentation/resources/routes_manager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//test
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await initAppModule();
  await AppResponseCacheService.initInstance();
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       //statusBarColor: Colors.transparent,
  //     // systemNavigationBarColor: Colors.blue, // navigation bar color
  //   statusBarColor: Colors.transparent, //
  //     ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarBrightness:
          Brightness.dark // Dark == white status bar -- for IOS.
      ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = MyHttpOverrides();

  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      useOnlyLangCode: false,
      saveLocale: true,
      startLocale: ENGLISH_LOCAL,
      child: Phoenix(
          child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            localizationsDelegates: [
              EasyLocalization.of(context)!.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: EasyLocalization.of(context)!.supportedLocales,
            locale: EasyLocalization.of(context)!.locale,
            debugShowCheckedModeBanner: false,
            //showPerformanceOverlay: true,
            title: 'Base Clean Arch',
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.splashRoute,
            home: child,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ), //set desired text scale factor here
                child: child!,
              );
            },
            navigatorKey: AppShared.navKey,
          );
        },
        child: const AppWalkthroughScreen(),
      ))));
}
