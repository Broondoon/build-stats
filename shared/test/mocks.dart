// Mocks generated by Mockito 5.4.4 from annotations
// in shared/test/cache_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:mutex/mutex.dart' as _i6;
import 'package:shared/src/base_entities/entity/entity.dart' as _i3;
import 'package:shared/src/base_services/cache/localStorage.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_1<T1> extends _i1.SmartFake implements _i2.Future<T1> {
  _FakeFuture_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Entity].
///
/// See the documentation for Mockito's code generation for more information.
class MockEntity extends _i1.Mock implements _i3.Entity {
  MockEntity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  set id(String? _id) => super.noSuchMethod(
        Invocation.setter(
          #id,
          _id,
        ),
        returnValueForMissingStub: null,
      );

  @override
  DateTime get dateCreated => (super.noSuchMethod(
        Invocation.getter(#dateCreated),
        returnValue: _FakeDateTime_0(
          this,
          Invocation.getter(#dateCreated),
        ),
      ) as DateTime);

  @override
  set dateCreated(DateTime? _dateCreated) => super.noSuchMethod(
        Invocation.setter(
          #dateCreated,
          _dateCreated,
        ),
        returnValueForMissingStub: null,
      );

  @override
  DateTime get dateUpdated => (super.noSuchMethod(
        Invocation.getter(#dateUpdated),
        returnValue: _FakeDateTime_0(
          this,
          Invocation.getter(#dateUpdated),
        ),
      ) as DateTime);

  @override
  set dateUpdated(DateTime? _dateUpdated) => super.noSuchMethod(
        Invocation.setter(
          #dateUpdated,
          _dateUpdated,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get flagForDeletion => (super.noSuchMethod(
        Invocation.getter(#flagForDeletion),
        returnValue: false,
      ) as bool);

  @override
  set flagForDeletion(bool? _flagForDeletion) => super.noSuchMethod(
        Invocation.setter(
          #flagForDeletion,
          _flagForDeletion,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String joinData() => (super.noSuchMethod(
        Invocation.method(
          #joinData,
          [],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #joinData,
            [],
          ),
        ),
      ) as String);

  @override
  String getChecksum() => (super.noSuchMethod(
        Invocation.method(
          #getChecksum,
          [],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #getChecksum,
            [],
          ),
        ),
      ) as String);

  @override
  dynamic toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #toJson,
            [],
          ),
        ),
      ) as String);
}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i5.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String> get keys => (super.noSuchMethod(
        Invocation.getter(#keys),
        returnValue: <String>[],
      ) as List<String>);

  @override
  List<String> get values => (super.noSuchMethod(
        Invocation.getter(#values),
        returnValue: <String>[],
      ) as List<String>);

  @override
  List<MapEntry<String, String>> get entries => (super.noSuchMethod(
        Invocation.getter(#entries),
        returnValue: <MapEntry<String, String>>[],
      ) as List<MapEntry<String, String>>);

  @override
  _i2.Future<String?> getItem(String? key) => (super.noSuchMethod(
        Invocation.method(
          #getItem,
          [key],
        ),
        returnValue: _i2.Future<String?>.value(),
      ) as _i2.Future<String?>);

  @override
  _i2.Future<void> setItem(
    String? key,
    String? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setItem,
          [
            key,
            value,
          ],
        ),
        returnValue: _i2.Future<void>.value(),
        returnValueForMissingStub: _i2.Future<void>.value(),
      ) as _i2.Future<void>);

  @override
  _i2.Future<void> removeItem(String? key) => (super.noSuchMethod(
        Invocation.method(
          #removeItem,
          [key],
        ),
        returnValue: _i2.Future<void>.value(),
        returnValueForMissingStub: _i2.Future<void>.value(),
      ) as _i2.Future<void>);
}

/// A class which mocks [EntityFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockEntityFactory<T extends _i3.Entity> extends _i1.Mock
    implements _i3.EntityFactory<T> {
  MockEntityFactory() {
    _i1.throwOnMissingStub(this);
  }

  @override
  dynamic fromJson(Map<String, dynamic>? json) =>
      super.noSuchMethod(Invocation.method(
        #fromJson,
        [json],
      ));
}

/// A class which mocks [ReadWriteMutex].
///
/// See the documentation for Mockito's code generation for more information.
class MockReadWriteMutex extends _i1.Mock implements _i6.ReadWriteMutex {
  MockReadWriteMutex() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isLocked => (super.noSuchMethod(
        Invocation.getter(#isLocked),
        returnValue: false,
      ) as bool);

  @override
  bool get isWriteLocked => (super.noSuchMethod(
        Invocation.getter(#isWriteLocked),
        returnValue: false,
      ) as bool);

  @override
  bool get isReadLocked => (super.noSuchMethod(
        Invocation.getter(#isReadLocked),
        returnValue: false,
      ) as bool);

  @override
  _i2.Future<dynamic> acquireRead() => (super.noSuchMethod(
        Invocation.method(
          #acquireRead,
          [],
        ),
        returnValue: _i2.Future<dynamic>.value(),
      ) as _i2.Future<dynamic>);

  @override
  _i2.Future<dynamic> acquireWrite() => (super.noSuchMethod(
        Invocation.method(
          #acquireWrite,
          [],
        ),
        returnValue: _i2.Future<dynamic>.value(),
      ) as _i2.Future<dynamic>);

  @override
  void release() => super.noSuchMethod(
        Invocation.method(
          #release,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Future<T> protectRead<T>(_i2.Future<T> Function()? criticalSection) =>
      (super.noSuchMethod(
        Invocation.method(
          #protectRead,
          [criticalSection],
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #protectRead,
                  [criticalSection],
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #protectRead,
                [criticalSection],
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> protectWrite<T>(_i2.Future<T> Function()? criticalSection) =>
      (super.noSuchMethod(
        Invocation.method(
          #protectWrite,
          [criticalSection],
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #protectWrite,
                  [criticalSection],
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #protectWrite,
                [criticalSection],
              ),
            ),
      ) as _i2.Future<T>);
}
