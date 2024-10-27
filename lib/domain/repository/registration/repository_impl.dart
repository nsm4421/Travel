part of 'repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationDataSource _registrationDataSource;

  RegistrationRepositoryImpl(
      {required RegistrationDataSource registrationDataSource})
      : _registrationDataSource = registrationDataSource;

  @override
  Future<Either<ErrorResponse, void>> create(
      {required String meetingId, required String introduce}) async {
    try {
      return await _registrationDataSource
          .create(meetingId: meetingId, introduce: introduce)
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, void>> deleteByMeetingId(
      String meetingId) async {
    try {
      return await _registrationDataSource
          .deleteByMeetingId(meetingId)
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, List<RegistrationEntity>>> fetch(
      String meetingId) async {
    try {
      return await _registrationDataSource
          .fetch(meetingId)
          .then((res) => res.map(RegistrationEntity.from).toList())
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, void>> update(
      {required String registrationId, required bool isPermitted}) async {
    try {
      return await _registrationDataSource
          .update(registrationId: registrationId, isPermitted: isPermitted)
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }
}