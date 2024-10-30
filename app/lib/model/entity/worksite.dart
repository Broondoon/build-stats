import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

class Worksite extends Cacheable {
  String? ownerId;
  List<String>? checklistIds;

  Worksite({
    required super.id,
    this.ownerId,
    this.checklistIds,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  @override
  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'checklistIds': checklistIds,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonNoTempIds() {
    return {
      'id': id,
      'ownerId': ownerId,
      'checklistIds': checklistIds
          ?.where((x) => !x.startsWith(ID_TempIDPrefix))
          .toList()
          .toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      ownerId ?? '',
      checklistIds
              ?.where((element) => !element.startsWith(ID_TempIDPrefix))
              .join(',') ??
          '',
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class WorksiteFactory extends CacheableFactory<Worksite> {
  @override
  Worksite fromJson(Map<String, dynamic> json) {
    Worksite worksite = Worksite(
      id: json['id'],
      ownerId: json['ownerId'],
      checklistIds: List<String>.from(json['checklistIds'] ?? <String>[]),
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );
    return worksite;
  }
}
