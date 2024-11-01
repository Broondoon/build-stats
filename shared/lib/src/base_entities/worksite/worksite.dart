import 'dart:convert';

import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseWorksite extends Entity {
  late String? ownerId;
  late String? companyId;
  late List<String>? checklistIds;

  BaseWorksite({
    required super.id,
    this.ownerId,
    this.companyId,
    this.checklistIds,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    checklistIds ??= <String>[];
  }

  BaseWorksite.fromBaseWorksite({required BaseWorksite worksite})
      : super(
          id: worksite.id,
          dateCreated: worksite.dateCreated,
          dateUpdated: worksite.dateUpdated,
          flagForDeletion: worksite.flagForDeletion,
        ) {
    ownerId = worksite.ownerId;
    companyId = worksite.companyId;
    checklistIds = worksite.checklistIds;
  }

  @override
  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'companyId': companyId,
      'checklistIds': checklistIds,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'ownerId': ownerId,
      'companyId': companyId,
      'checklistIds':
          checklistIds?.where((x) => !x.startsWith(ID_TempIDPrefix)).toList(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      ownerId ?? '',
      companyId ?? '',
      checklistIds
              ?.where((element) => !element.startsWith(ID_TempIDPrefix))
              .join(',') ??
          '',
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class BaseWorksiteFactory<T extends BaseWorksite> extends EntityFactory<T> {
  @override
  BaseWorksite fromJson(Map<String, dynamic> json) {
    BaseWorksite worksite = BaseWorksite(
      id: json['id'],
      ownerId: json['ownerId'],
      companyId: json['companyId'],
      checklistIds: List<String>.from(json['checklistIds'] ?? <String>[]),
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );
    return worksite;
  }
}
