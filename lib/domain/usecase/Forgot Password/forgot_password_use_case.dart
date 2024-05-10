import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../../model/models.dart';
import '../../repository/Forgot password/forgot_password_repository.dart';
import '../../repository/login/login_repository.dart';
import '../base_usecase.dart';

class ForgotPasswordUseCase implements BaseUseCase<dynamic, dynamic> {
  final ForgotPasswordRepository _loginRepository;

  ForgotPasswordUseCase(this._loginRepository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
