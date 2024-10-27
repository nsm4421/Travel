part of 'repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource _dataSource;

  CommentRepositoryImpl(this._dataSource);

  @override
  Future<Either<ErrorResponse, String>> create(
      {required BaseEntity ref, required String content}) async {
    try {
      return await _dataSource
          .create(
              refTable: customUtil.getRefTable(ref),
              refId: ref.id!,
              content: content)
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, void>> deleteById(String commentId) async {
    try {
      return await _dataSource.deleteById(commentId).then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, List<CommentEntity>>> fetch(
      {required BaseEntity ref,
      required String beforeAt,
      int take = 20}) async {
    try {
      return await _dataSource
          .fetch(
              refTable: customUtil.getRefTable(ref),
              refId: ref.id!,
              beforeAt: beforeAt,
              take: take)
          .then((res) => res.map(CommentEntity.from).toList())
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }

  @override
  Future<Either<ErrorResponse, void>> modifyById(
      {required String commentId, required String content}) async {
    try {
      return await _dataSource
          .modifyById(commentId: commentId, content: content)
          .then(Right.new);
    } on Exception catch (error) {
      customUtil.logger.e(error);
      return Left(ErrorResponse.from(error));
    }
  }
}
