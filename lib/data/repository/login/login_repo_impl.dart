import 'package:dartz/dartz.dart';

import '../../../domain/repository/login/login_repository.dart';
import '../../data_source/local_data_source.dart';
import '../../data_source/remote_data_source.dart';
import '../../network/error_handler.dart';
import '../../network/failure.dart';
import '../../network/network_info.dart';

class LoginRepositoryImpl implements LoginRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  LoginRepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
}
