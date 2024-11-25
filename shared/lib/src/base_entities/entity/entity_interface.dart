abstract class EntityInterface {
  toJson();
  toJsonTransfer();
  (List<String>, List<String>) toParamStringList();
  String getChecksum();
  String joinData();
}

abstract class EntityFactoryInterface<T extends EntityInterface> {
  dynamic fromJson(Map<String, dynamic> json);
}
