import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseUser extends Entity {
  late String companyId;

  BaseUser({
    required super.id,
    required this.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  BaseUser.fromBaseUser({required BaseUser user})
      : super(
            id: user.id,
            dateCreated: user.dateCreated,
            dateUpdated: user.dateUpdated,
            flagForDeletion: user.flagForDeletion) {
    companyId = user.companyId;
  }

  @override
  toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'companyId': companyId,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      companyId,
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class BaseUserFactory<T extends BaseUser> extends EntityFactory<T> {
  @override
  BaseUser fromJson(Map<String, dynamic> json) {
    BaseUser user = BaseUser(
      id: json['id'],
      companyId: json['companyId'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );

    return user;
  }
}
