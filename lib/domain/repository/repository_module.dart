import 'package:injectable/injectable.dart';

import '../../data/datasource/datasource_module.dart';
import 'account/repository.dart';
import 'auth/repository.dart';
import 'chat/open_chat/repository.dart';
import 'chat/private_chat/repository.dart';
import 'comment/repository.dart';
import 'feed/repository.dart';
import 'like/repository.dart';
import 'meeting/repository.dart';
import 'registration/repository.dart';

@lazySingleton
class RepositoryModule {
  final DataSourceModule _dataSourceModule;

  RepositoryModule(this._dataSourceModule);

  @lazySingleton
  AuthRepository get auth => AuthRepositoryImpl(
      authDataSource: _dataSourceModule.auth,
      storageDataSource: _dataSourceModule.storage,
      localDataSource: _dataSourceModule.local);

  @lazySingleton
  AccountRepository get account =>
      AccountRepositoryImpl(_dataSourceModule.account);

  @lazySingleton
  OpenChatRepository get openChat => OpenChatRepositoryImpl(
      chatRoomDataSource: _dataSourceModule.openChat,
      messageDataSource: _dataSourceModule.openChatMessage,
      storageDataSource: _dataSourceModule.storage);

  @lazySingleton
  PrivateChatRepository get privateChat => PrivateChatRepositoryImpl(
      chatRoomDataSource: _dataSourceModule.privateChat,
      messageDataSource: _dataSourceModule.privateChatMessage,
      storageDataSource: _dataSourceModule.storage);

  @lazySingleton
  FeedRepository get feed => FeedRepositoryImpl(
      feedDataSource: _dataSourceModule.feed,
      storageDataSource: _dataSourceModule.storage);

  @lazySingleton
  MeetingRepository get meeting => MeetingRepositoryImpl(
      meetingDataSource: _dataSourceModule.meeting,
      storageDataSource: _dataSourceModule.storage,
      channelDataSource: _dataSourceModule.channel);

  @lazySingleton
  RegistrationRepository get registration => RegistrationRepositoryImpl(
      registrationDataSource: _dataSourceModule.registration);

  @lazySingleton
  CommentRepository get comment =>
      CommentRepositoryImpl(_dataSourceModule.comment);

  @lazySingleton
  LikeRepository get like => LikeRepositoryImpl(_dataSourceModule.like);
}
