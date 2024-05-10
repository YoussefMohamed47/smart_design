import 'package:clean_arch_base/domain/repository/Forgot%20password/forgot_password_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/repository/login/login_repository.dart';
import '../../data_source/local_data_source.dart';
import '../../data_source/remote_data_source.dart';
import '../../network/error_handler.dart';
import '../../network/failure.dart';
import '../../network/network_info.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ForgotPasswordRepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
}
