import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:build_stats_flutter/model/entity/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class MockChecklist extends Mock implements Checklist {
  @override
  String get id =>
      super.noSuchMethod(Invocation.getter(#id), returnValue: 'checklist1');

  @override
  String get worksiteId => super
      .noSuchMethod(Invocation.getter(#worksiteId), returnValue: 'worksite1');

  @override
  HashMap<String, String> TESTING_GetChecklistIdsByDate() => super.noSuchMethod(
        Invocation.method(#TESTING_GetChecklistIdsByDate, []),
        returnValue: HashMap<String, String>(),
      );
}

class MockCacheable extends Mock implements Cacheable {
  @override
  String get id =>
      super.noSuchMethod(Invocation.getter(#id), returnValue: '123');

  @override
  set id(String value) => super.noSuchMethod(Invocation.setter(#id, value));

  @override
  Map<String, dynamic> toJson() => super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: {'id': '123'},
        returnValueForMissingStub: <String, dynamic>{},
      );

  @override
  String joinData() => super.noSuchMethod(
        Invocation.method(#joinData, []),
        returnValue: '123',
        returnValueForMissingStub: '',
      );

  @override
  String getChecksum() => super.noSuchMethod(
        Invocation.method(#getChecksum, []),
        returnValue: '7238631b',
        returnValueForMissingStub: '',
      );
}

class MockItem extends Mock implements Item {
  MockItem() {
    // Throws an error if a stub is missing
    throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: 'item1')
          as String);

  @override
  set id(String value) => super.noSuchMethod(Invocation.setter(#id, value),
      returnValueForMissingStub: null);

  @override
  String get checklistDayId => (super
          .noSuchMethod(Invocation.getter(#checklistDayId), returnValue: 'day1')
      as String);

  @override
  set checklistDayId(String value) =>
      super.noSuchMethod(Invocation.setter(#checklistDayId, value),
          returnValueForMissingStub: null);

  @override
  String? get unit =>
      (super.noSuchMethod(Invocation.getter(#unit), returnValue: "unit1")
          as String?);

  @override
  set unit(String? value) => super.noSuchMethod(Invocation.setter(#unit, value),
      returnValueForMissingStub: null);

  @override
  String? get desc =>
      (super.noSuchMethod(Invocation.getter(#desc), returnValue: "description")
          as String?);

  @override
  set desc(String? value) => super.noSuchMethod(Invocation.setter(#desc, value),
      returnValueForMissingStub: null);

  @override
  String? get result =>
      (super.noSuchMethod(Invocation.getter(#result), returnValue: "result1")
          as String?);

  @override
  set result(String? value) =>
      super.noSuchMethod(Invocation.setter(#result, value),
          returnValueForMissingStub: null);

  @override
  String? get comment =>
      (super.noSuchMethod(Invocation.getter(#comment), returnValue: "comment1")
          as String?);

  @override
  set comment(String? value) =>
      super.noSuchMethod(Invocation.setter(#comment, value),
          returnValueForMissingStub: null);

  @override
  int? get creatorId =>
      (super.noSuchMethod(Invocation.getter(#creatorId), returnValue: 123)
          as int?);

  @override
  set creatorId(int? value) =>
      super.noSuchMethod(Invocation.setter(#creatorId, value),
          returnValueForMissingStub: null);

  @override
  bool? get verified =>
      (super.noSuchMethod(Invocation.getter(#verified), returnValue: true)
          as bool?);

  @override
  set verified(bool? value) =>
      super.noSuchMethod(Invocation.setter(#verified, value),
          returnValueForMissingStub: null);

  @override
  DateTime get dateCreated =>
      (super.noSuchMethod(Invocation.getter(#dateCreated),
          returnValue: DateTime.parse('2023-01-01T00:00:00.000Z')) as DateTime);

  @override
  set dateCreated(DateTime value) =>
      super.noSuchMethod(Invocation.setter(#dateCreated, value),
          returnValueForMissingStub: null);

  @override
  DateTime get dateUpdated =>
      (super.noSuchMethod(Invocation.getter(#dateUpdated),
          returnValue: DateTime.parse('2023-01-01T00:00:00.000Z')) as DateTime);

  @override
  set dateUpdated(DateTime value) =>
      super.noSuchMethod(Invocation.setter(#dateUpdated, value),
          returnValueForMissingStub: null);

  @override
  Map<String, dynamic> toJson() =>
      (super.noSuchMethod(Invocation.method(#toJson, []), returnValue: {
        'id': 'item1',
        'checklistDayId': 'day1',
        'unit': 'unit1',
        'desc': 'description',
        'result': 'result1',
        'comment': 'comment1',
        'creatorId': 123,
        'verified': true,
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      }) as Map<String, dynamic>);

  @override
  String joinData() => (super.noSuchMethod(Invocation.method(#joinData, []),
          returnValue:
              'item1|day1|unit1|description|result1|comment1|123|true|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z')
      as String);

  @override
  String getChecksum() =>
      (super.noSuchMethod(Invocation.method(#getChecksum, []),
          returnValue: '25492fbb') as String);
}

// Mock class generated by Mockito
class MockChecklistDay extends Mock implements ChecklistDay {
  MockChecklistDay() {
    throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: 'day1')
          as String);

  @override
  set id(String? value) => super.noSuchMethod(Invocation.setter(#id, value));

  @override
  String get checklistId =>
      (super.noSuchMethod(Invocation.getter(#checklistId), returnValue: '1')
          as String);

  @override
  set checklistId(String? value) =>
      super.noSuchMethod(Invocation.setter(#checklistId, value));

  @override
  DateTime get date =>
      (super.noSuchMethod(Invocation.getter(#date), returnValue: DateTime.now())
          as DateTime);

  @override
  set date(DateTime? value) =>
      super.noSuchMethod(Invocation.setter(#date, value));

  @override
  String? get comment =>
      (super.noSuchMethod(Invocation.getter(#comment)) as String?);

  @override
  set comment(String? value) =>
      super.noSuchMethod(Invocation.setter(#comment, value));

  @override
  HashMap<String, List<String>> get itemsByCatagory =>
      (super.noSuchMethod(Invocation.getter(#itemsByCatagory),
              returnValue: HashMap<String, List<String>>())
          as HashMap<String, List<String>>);

  @override
  set itemsByCatagory(HashMap<String, List<String>>? value) =>
      super.noSuchMethod(Invocation.setter(#itemsByCatagory, value));

  @override
  DateTime get dateCreated =>
      (super.noSuchMethod(Invocation.getter(#dateCreated),
          returnValue: DateTime.now()) as DateTime);

  @override
  set dateCreated(DateTime? value) =>
      super.noSuchMethod(Invocation.setter(#dateCreated, value));

  @override
  DateTime get dateUpdated =>
      (super.noSuchMethod(Invocation.getter(#dateUpdated),
          returnValue: DateTime.now()) as DateTime);

  @override
  set dateUpdated(DateTime? value) =>
      super.noSuchMethod(Invocation.setter(#dateUpdated, value));

  @override
  dynamic toJson() => super.noSuchMethod(
        Invocation.method(#toJson, []),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      );

  @override
  String joinData() => (super.noSuchMethod(
        Invocation.method(#joinData, []),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);

  @override
  String getChecksum() => (super.noSuchMethod(
        Invocation.method(#getChecksum, []),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
}

class MockDataConnectionService<T extends Cacheable> extends Mock
    implements DataConnectionService<T> {
  final itemMock = MockItem();
  final checklistMock = MockChecklist();
  final checklistDayMock = MockChecklistDay();
  //final worksiteMock = MockWorksite();

  returnItem() => jsonEncode(T is Item
      ? itemMock.toJson()
      : T is ChecklistDay
          ? checklistDayMock.toJson()
          : //T is Worksite? worksiteMock.toJson():
          {});

  @override
  Future<String> get(String path, List<String> keys) {
    return super.noSuchMethod(
      Invocation.method(#get, [path, keys]),
      returnValue: Future.value(returnItem()),
    );
  }

  @override
  Future<String> post(String path, T value) {
    return super.noSuchMethod(
      Invocation.method(#post, [path, value]),
      returnValue: Future.value(returnItem()),
    );
  }

  @override
  Future<String> put(String path, T value) {
    return super.noSuchMethod(
      Invocation.method(#put, [path, value]),
      returnValue: Future.value(returnItem()),
    );
  }

  @override
  Future<bool> delete(String path, String key) {
    return super.noSuchMethod(
      Invocation.method(#delete, [path, key]),
      returnValue: Future.value(true),
    );
  }
}

class MockJsonFileAccess<T extends CacheableInterface> extends Mock
    implements JsonFileAccess<T> {
  @override
  Future<String> readDataFile(String path) {
    return super.noSuchMethod(
      Invocation.method(#readDataFile, [path]),
      returnValue: Future.value('mocked read data'),
    );
  }

  @override
  Future<bool> saveDataFile(String path, String data) {
    return super.noSuchMethod(
      Invocation.method(#saveDataFile, [path, data]),
      returnValue: Future.value(true),
    );
  }

  @override
  Future<bool> deleteDataFile(String path) {
    return super.noSuchMethod(
      Invocation.method(#deleteDataFile, [path]),
      returnValue: Future.value(true),
    );
  }

  @override
  Future<bool> deleteFromDataFile(String path, List<String> keys) {
    return super.noSuchMethod(
      Invocation.method(#deleteFromDataFile, [path, keys]),
      returnValue: Future.value(true),
    );
  }
}

class MockCacheableFactory<T extends Cacheable> extends Mock
    implements CacheableFactory<T> {
  @override
  T fromJson(Map<String, dynamic> json) {
    return super.noSuchMethod(
      Invocation.method(#fromJson, [json]),
      returnValue: T is Item
          ? MockItem() as T
          : T is ChecklistDay
              ? MockChecklistDay() as T
              : //T is Worksite? MockWorksite() as T:
              MockCacheable() as T,
    );
  }
}

class MockLocalStorage extends Mock implements LocalStorage {
  final Map<String, dynamic> _storage = {};

  @override
  String? getItem(String key) {
    return _storage[key];
  }

  @override
  Future<void> setItem(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> removeItem(String key) async {
    _storage.remove(key);
  }

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }

  // Implement other methods if needed
}
