import '../../../core/abstract/abstract.dart';
import '../../../data/model/auth/auth_user.dart';

class PresenceEntity extends BaseEntity {
  final String? username;
  final String? avatarUrl;

  PresenceEntity(
      {super.id,
      super.createdAt,
      super.updatedAt,
      this.username,
      this.avatarUrl});

  static PresenceEntity? from(AuthUserModel? model) {
    return model == null
        ? null
        : PresenceEntity(
            id: model.id.isEmpty ? null : model.id,
            username: model.username.isEmpty ? null : model.username,
            avatarUrl: model.avatar_url.isEmpty ? null : model.avatar_url,
          );
  }
}
