import 'dart:collection';
import 'dart:convert';

import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseWorksite extends Entity {
  late String? ownerId;
  late String? companyId;
  late List<String>? checklistIds;

  BaseWorksite({
    required super.id,
    super.name,
    this.ownerId,
    this.companyId,
    this.checklistIds,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    checklistIds ??= <String>[];
  }


  BaseWorksite.fromEntity({required super.entity, this.ownerId, this.companyId, this.checklistIds})
      : super.fromEntity();
  
  BaseWorksite.fromBaseWorksite({required BaseWorksite worksite}) : this.fromEntity(entity: worksite, ownerId: worksite.ownerId, companyId: worksite.companyId, checklistIds: worksite.checklistIds);

  @override
  toJson() {
    Map<String, dynamic> map = super.toJson();
    map['ownerId'] = ownerId;
    map['companyId'] = companyId;
    map['checklistIds'] = checklistIds;
    return map;
  }

  @override
  toJsonTransfer() {
    Map<String, dynamic> map = super.toJsonTransfer();
    map['ownerId'] = ownerId;
    map['companyId'] = companyId;
    map['checklistIds'] = checklistIds?.where((x) => !x.startsWith(ID_TempIDPrefix)).toList();
    return map;
  }

  @override
  joinData() {
    return super.joinData() + '|' + ([
      ownerId ?? '',
      companyId ?? '',
      checklistIds
              ?.where((element) => !element.startsWith(ID_TempIDPrefix))
              .join(',') ??
          '',
    ].join('|'));
  }
}

class BaseWorksiteFactory<T extends BaseWorksite> extends EntityFactory<T> {
  @override
  BaseWorksite fromJson(Map<String, dynamic> json) {
    BaseWorksite worksite = BaseWorksite.fromEntity(
      entity: super.fromJson(json),
      ownerId: json['ownerId'],
      companyId: json['companyId'],
      checklistIds: List<String>.from(json['checklistIds'] ?? <String>[]));
    return worksite;
  }
}
