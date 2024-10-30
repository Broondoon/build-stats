abstract class CacheableInterface {
  toJson();
  toJsonNoTempIds();
  String getChecksum();
  String joinData();
}

class Cacheable implements CacheableInterface {
  String id;
  DateTime dateCreated;
  DateTime dateUpdated;
  bool flagForDeletion = false;
  Cacheable(
      {required this.id,
      required this.dateCreated,
      required this.dateUpdated,
      this.flagForDeletion = false});
  @override
  toJson() => {
        'id': id,
        'dateCreated': dateCreated.toIso8601String(),
        'dateUpdated': dateUpdated.toIso8601String(),
        'flagForDeletion': flagForDeletion
      };
  @override
  toJsonNoTempIds() => {
        'id': id,
        'dateCreated': dateCreated.toIso8601String(),
        'dateUpdated': dateUpdated.toIso8601String()
      };
  @override
  joinData() => [
        id,
        dateCreated.toIso8601String(),
        dateUpdated.toIso8601String()
      ].join('|');
  //GENERATED BY CHATGPT.  FNV-1a hash algorithm
  @override
  getChecksum() {
    int _fnv1aHash(String data) {
      const int fnvPrime = 0x01000193;
      int hash = 0x811c9dc5;

      for (int i = 0; i < data.length; i++) {
        hash ^= data.codeUnitAt(i);
        hash = (hash * fnvPrime) & 0xFFFFFFFF;
      }
      return hash;
    }

    int hash = _fnv1aHash(this.joinData());
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

abstract class CacheableFactory<T extends Cacheable> {
  T fromJson(Map<String, dynamic> json) => throw UnimplementedError();
}
