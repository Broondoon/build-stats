import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseUser extends Entity {
  late String companyId;

  BaseUser({
    required super.id,
    super.name,
    required this.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  BaseUser.fromBaseUser({required BaseUser user}) : this.fromEntity(entity: user, companyId: user.companyId);

  BaseUser.fromEntity({required super.entity, required this.companyId})
      : super.fromEntity();

  @override
  toJson() {
        Map<String, dynamic> map = super.toJson();
    map['companyId'] = companyId;
    return map;
  }

  @override
  toJsonTransfer() {
        Map<String, dynamic> map = super.toJsonTransfer();
    map['companyId'] = companyId;
    return map;
  }

  @override
  joinData() {
    return super.joinData() + '|' + ([
      companyId,
    ].join('|'));
  }
}

class BaseUserFactory<T extends BaseUser> extends EntityFactory<T> {
  @override
  BaseUser fromJson(Map<String, dynamic> json) {
    BaseUser user = BaseUser.fromEntity(
      entity: super.fromJson(json),
      companyId: json['companyId'],
    );
    return user;
  }
}
