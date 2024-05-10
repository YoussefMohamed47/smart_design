import 'package:clean_arch_base/data/repository/login/login_repo_impl.dart';
import 'package:clean_arch_base/domain/repository/login/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local_data_source.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../domain/usecase/login/login_use_case.dart';
import '../presentation/screens/login/view model/login_view_model.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  //app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // ----------------- repositories -----------------

  instance.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(instance(), instance(), instance()));

  // ----------------- use cases -----------------
  instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));

  // ----------------- view models -----------------

  instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
}

initLoginModule() {
  // if (!GetIt.I.isRegistered<LoginUseCase>()) {
  //   instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
  //   instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  // }
}

initForgotPasswordModule() {
  // if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
  //   instance.registerFactory<ForgotPasswordUseCase>(
  //       () => ForgotPasswordUseCase(instance()));
  //   // instance.registerFactory<ForgotPasswordViewModel>(
  //   //     () => ForgotPasswordViewModel(instance()));
  // }
}

initRegisterModule() {
  // if (!GetIt.I.isRegistered<RegisterUseCase>()) {
  //   instance
  //       .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
  //   instance.registerFactory<RegisterViewModel>(
  //       () => RegisterViewModel(instance()));
  //   instance.registerFactory<ImagePicker>(() => ImagePicker());
  // }
}

initHomeModule() {
  //if (!GetIt.I.isRegistered<HomeUseCase>()) {
  //   instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
  //   instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  //}
}

initStoreDetailsModule() {
  // if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
  //   instance.registerFactory<StoreDetailsUseCase>(
  //       () => StoreDetailsUseCase(instance()));
  // }
}
