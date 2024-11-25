import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseUnit extends Entity {
  late String name;
  late String companyId;

  BaseUnit({
    required super.id,
    required this.name,
    required this.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  BaseUnit.fromBaseUnit({required BaseUnit unit})
      : super(
          id: unit.id,
          dateCreated: unit.dateCreated,
          dateUpdated: unit.dateUpdated,
          flagForDeletion: unit.flagForDeletion,
        ) {
    name = unit.name;
    companyId = unit.companyId;
  }

  @override
  toJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
      'flagForDeletion': flagForDeletion.toString(),
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      name,
      companyId,
      dateCreated.toUtc().toIso8601String(),
      dateUpdated.toUtc().toIso8601String(),
    ].join('|');
  }
}

class BaseUnitFactory<T extends BaseUnit> extends EntityFactory<T> {
  @override
  BaseUnit fromJson(Map<String, dynamic> json) {
    return BaseUnit(
        id: json['id'],
        name: json['name'],
        companyId: json['companyId'],
        dateCreated:
            DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
        dateUpdated:
            DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
        flagForDeletion: json['flagForDeletion'] == "true");
  }
}
