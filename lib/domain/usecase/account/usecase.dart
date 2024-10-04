import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:travel/core/response/error_response.dart';
import 'package:travel/domain/repository/account/repository.dart';

part 'scenario/check_username.dart';

@lazySingleton
class AccountUseCase {
  final AccountRepository _repository;

  AccountUseCase(this._repository);

  CheckUsernameUseCase get isUsernameDuplicated =>
      CheckUsernameUseCase(_repository);
}
