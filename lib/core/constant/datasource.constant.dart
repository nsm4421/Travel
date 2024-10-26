part of 'constant.dart';

enum Tables {
  accounts('accounts'),
  diaries('diaries'),
  meeting('meetings'),
  comment('comments'),
  registration('registrations'),
  reels('reels'),
  openChatRooms('open_chat_rooms'),
  openChatMessages('open_chat_messages'),
  privateChatRooms('private_chat_rooms'),
  privateChatMessages('private_chat_messages'),
  ;

  final String name;

  const Tables(this.name);
}

enum Buckets {
  avatar('avatar'),
  diary('diary'),
  meeting('meeting'),
  reels('reels'),
  openChat('open_chat'),
  privateChat('private_chat'),
  ;

  final String name;

  const Buckets(this.name);
}

enum Boxes {
  credential;
}

enum Channels {
  meeting;
}

enum RpcFns {
  fetchDiaries('fetch_diaries'),
  fetchReels('fetch_reels'),
  fetchOpenChats('fetch_open_chats'),
  fetchOpenChatMessages('fetch_open_messages'),
  fetchMeetings('fetch_meetings'),
  fetchComments('fetch_comments'),
  fetchRegistrations('fetch_registrations'),
  createRegistration('create_registration'),
  updatePermissionOnRegistration('update_permission_on_registration'),
  ;

  final String name;

  const RpcFns(this.name);
}
