import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseUnit extends Entity {
  late String companyId;

  BaseUnit({
    required super.id,
    required super.name,
    required this.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  BaseUnit.fromBaseUnit({required BaseUnit unit}) : this.fromEntity(entity: unit, companyId: unit.companyId);

  BaseUnit.fromEntity({required super.entity, required this.companyId})
      : super.fromEntity();

  @override
  toJson() {
    Map<String,dynamic> map = super.toJson();
    map['companyId'] = companyId;
    return map;
  }

  @override
  toJsonTransfer() {
    Map<String,dynamic> map = super.toJsonTransfer();
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

class BaseUnitFactory<T extends BaseUnit> extends EntityFactory<T> {
  @override
  BaseUnit fromJson(Map<String, dynamic> json) {
    return BaseUnit.fromEntity(
        entity: super.fromJson(json), companyId: json['companyId']);
  }
}
