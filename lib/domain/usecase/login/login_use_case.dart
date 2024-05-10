import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../model/models.dart';
import '../../repository/login/login_repository.dart';
import '../base_usecase.dart';

class LoginUseCase implements BaseUseCase<dynamic, dynamic> {
  final LoginRepository _loginRepository;

  LoginUseCase(this._loginRepository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
