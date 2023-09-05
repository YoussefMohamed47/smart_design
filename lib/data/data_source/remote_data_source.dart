import '../network/app_api.dart';
import '../response/responses.dart' hide HomeResponse;

abstract class RemoteDataSource {}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);
}
