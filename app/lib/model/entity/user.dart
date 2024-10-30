import 'package:build_stats_flutter/model/entity/cachable.dart';
import 'package:shared/app_strings.dart';

class User extends Cacheable {
  String companyId;

  User({
    required super.id,
    required this.companyId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

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

class UserFactory extends CacheableFactory<User> {
  @override
  User fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json['id'],
      companyId: json['companyId'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );

    return user;
  }
}
