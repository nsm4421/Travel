part of '../usecase.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository _repository;

  SignInWithEmailAndPasswordUseCase(this._repository);

  Future<ResponseWrapper<PresenceEntity?>> call(
      {required String email, required String password}) async {
    return await _repository.signInWithEmailAndPassword(email, password);
  }
}
