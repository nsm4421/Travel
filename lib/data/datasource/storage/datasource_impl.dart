part of 'datasource.dart';

class StorageDataSourceImpl with CustomLogger implements StorageDataSource {
  final SupabaseClient _supabaseClient;

  StorageDataSourceImpl(this._supabaseClient);

  @override
  Future<String> uploadAvatarAndReturnPublicUrl(File avatar) async {
    final bucket = _supabaseClient.storage.from(Buckets.avatars.name);
    final ext = _getExt(avatar);
    final path = '${const Uuid().v4()}.$ext';
    await bucket.uploadBinary(path, await avatar.readAsBytes(),
        fileOptions: FileOptions(
            contentType: 'image/$ext', cacheControl: '3600', upsert: true));
    return bucket.getPublicUrl(path);
  }

  @override
  Future<Iterable<String>> uploadFeedImagesAndReturnPublicUrls(
      List<File> images) async {
    final bucket = _supabaseClient.storage.from(Buckets.feeds.name);
    final futures = images.map((image) async {
      final path = '${const Uuid().v4()}.jpg';
      await bucket.uploadBinary(path, await image.readAsBytes(),
          fileOptions: const FileOptions(
              contentType: 'image/jpg', cacheControl: '3600', upsert: true));
      return bucket.getPublicUrl(path);
    });
    return await Future.wait(futures);
  }

  // 파일 확장자
  String _getExt(File file) {
    return file.path.split('.').last;
  }
}
