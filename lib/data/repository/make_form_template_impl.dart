import 'package:dartz/dartz.dart';
import 'package:questionnaire/domain/repository/makeFormTemplete/make_form_template_repoistory.dart';

import '../../app/Caching/generic_cache.dart';
import '../../app/constants.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/network_info.dart';

class MakeFormTemplateRepositoryImpl implements MakeFormTemplateRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  MakeFormTemplateRepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
  final GenericCache genericCache = GenericCache.instance;

  // @override
  // Future<Either<Failure, TermsAndConditionsModel>>
  // getTermsAndConditions() async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       var data =
  //       await genericCache.getCacheResultCore<TermsAndConditionsModel>(
  //             () async => (await _remoteDataSource.getTermsAndConditions()),
  //         Constants.TERMSANDCONDITIONSKEYCACHE,
  //             (r) => (TermsAndConditionsModel.fromJson(r)),
  //         await _networkInfo.isConnected,
  //         additionalFilter: "getTermsAndConditions,termsAndConditionsModel",
  //         cacheTimeInterval: Constants.longTime * 60 * 1000,
  //       );
  //       return Right(data!);
  //     } catch (error) {
  //       return Left(ErrorHandler.handle(error).failure);
  //     }
  //   } else {
  //     return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
  //   }
  // }
}
