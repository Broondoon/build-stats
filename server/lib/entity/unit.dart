import 'package:shared/unit.dart';

class Unit extends BaseUnit {
  Unit({
    required super.id,
    required super.name,
    required super.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  Unit.fromBaseUnit({required super.unit}) : super.fromBaseUnit();
}

class UnitFactory extends BaseUnitFactory<Unit> {
  @override
  Unit fromJson(Map<String, dynamic> json) =>
      Unit.fromBaseUnit(unit: super.fromJson(json));
}
