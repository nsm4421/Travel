import 'package:travel/core/abstract/abstract.dart';
import 'package:travel/data/model/feed/fetch.dart';
import 'package:travel/domain/entity/auth/presence.dart';

class FeedEntity extends BaseEntity {
  final String content;
  late final List<String> hashtags;
  late final List<String> captions;
  final PresenceEntity author;

  FeedEntity(
      {super.id,
      super.createdAt,
      super.updatedAt,
      this.content = '',
      List<String>? hashtags,
      List<String>? captions,
      required this.author}) {
    this.hashtags = hashtags ?? [];
    this.captions = captions ?? [];
  }

  factory FeedEntity.from(FetchFeedDto dto) {
    return FeedEntity(
      id: dto.id,
      createdAt: dto.created_at,
      updatedAt: dto.updated_at,
      content: dto.content,
      hashtags: dto.hashtags,
      captions: dto.captions,
      author: PresenceEntity(
        id: dto.author_id,
        username: dto.author_username,
        avatarUrl: dto.author_avatar_url,
      ),
    );
  }
}