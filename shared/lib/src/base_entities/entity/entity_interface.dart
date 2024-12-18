abstract class EntityInterface {
  toJson();
  toJsonTransfer();
  String getChecksum();
  String joinData();
}

abstract class EntityFactoryInterface<T extends EntityInterface> {
  dynamic fromJson(Map<String, dynamic> json);
}
