part of 'repository.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingDataSource _meetingDataSource;
  final StorageDataSource _storageDataSource;

  MeetingRepositoryImpl(
      {required MeetingDataSource meetingDataSource,
      required StorageDataSource storageDataSource})
      : _meetingDataSource = meetingDataSource,
        _storageDataSource = storageDataSource;

  @override
  Future<Either<ErrorResponse, void>> edit(
      {String? id,
      bool update = false,
      required String country,
      String? city,
      required DateTime startDate,
      required DateTime endDate,
      int headCount = 2,
      required TravelPeopleSexType sex,
      required TravelPreferenceType preference,
      int minCost = 0,
      int maxCost = 500,
      required String title,
      required String content,
      required List<String> hashtags,
      required List<File> images}) async {
    try {
      final dto = EditMeetingModel(
          country: country,
          city: city,
          start_date: startDate.toUtc().toIso8601String(),
          end_date: endDate.toUtc().toIso8601String(),
          head_count: headCount,
          sex: sex,
          preference: preference,
          min_cost: minCost,
          max_cost: maxCost,
          title: title,
          content: content,
          hashtags: hashtags,
          images: images.isNotEmpty
              ? await Future.wait(images.map((file) async =>
                  await _storageDataSource.uploadImageAndReturnPublicUrl(
                      file: file, bucketName: Buckets.meeting.name)))
              : []);
      return await (update
              ? _meetingDataSource.modify(id: id!, model: dto)
              : _meetingDataSource.create(dto))
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, void>> deleteById(String id) async {
    try {
      return await _meetingDataSource.deleteById(id).then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, Iterable<MeetingEntity>>> fetch(String beforeAt,
      {int take = 20}) async {
    try {
      return await _meetingDataSource
          .fetch(beforeAt, take: take)
          .then((res) => res.map(MeetingEntity.from).toList())
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }
}
