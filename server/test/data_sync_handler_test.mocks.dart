// Mocks generated by Mockito 5.4.4 from annotations
// in Server/test/data_sync_handler_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:collection' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:Server/entity/unit.dart' as _i2;
import 'package:Server/storage/unit_cache.dart' as _i3;

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

class _FakeUnit_0 extends _i1.SmartFake implements _i2.Unit {
  _FakeUnit_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UnitCache].
///
/// See the documentation for Mockito's code generation for more information.
class MockUnitCache extends _i1.Mock implements _i3.UnitCache {
  MockUnitCache() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.HashMap<String, String> get cacheCheckSums => (super.noSuchMethod(
        Invocation.getter(#cacheCheckSums),
        returnValue: _i5.dummyValue<_i4.HashMap<String, String>>(
          this,
          Invocation.getter(#cacheCheckSums),
        ),
      ) as _i4.HashMap<String, String>);

  @override
  _i4.HashMap<String, bool> get cacheSyncFlags => (super.noSuchMethod(
        Invocation.getter(#cacheSyncFlags),
        returnValue: _i5.dummyValue<_i4.HashMap<String, bool>>(
          this,
          Invocation.getter(#cacheSyncFlags),
        ),
      ) as _i4.HashMap<String, bool>);

  @override
  _i6.Future<_i2.Unit?> getById(String? key) => (super.noSuchMethod(
        Invocation.method(
          #getById,
          [key],
        ),
        returnValue: _i6.Future<_i2.Unit?>.value(),
      ) as _i6.Future<_i2.Unit?>);

  @override
  _i6.Future<List<_i2.Unit>?> get(
    List<String>? keys,
    _i6.Future<List<String>?> Function(List<String>?)? onCacheMiss,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [
            keys,
            onCacheMiss,
          ],
        ),
        returnValue: _i6.Future<List<_i2.Unit>?>.value(),
      ) as _i6.Future<List<_i2.Unit>?>);

  @override
  _i6.Future<List<_i2.Unit>?> getAll(
          _i6.Future<List<String>?> Function(List<String>?)? onCacheMiss) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [onCacheMiss],
        ),
        returnValue: _i6.Future<List<_i2.Unit>?>.value(),
      ) as _i6.Future<List<_i2.Unit>?>);

  @override
  _i6.Future<List<_i2.Unit>> storeBulk(List<_i2.Unit>? entities) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeBulk,
          [entities],
        ),
        returnValue: _i6.Future<List<_i2.Unit>>.value(<_i2.Unit>[]),
      ) as _i6.Future<List<_i2.Unit>>);

  @override
  _i6.Future<_i2.Unit> store(
    String? key,
    _i2.Unit? entityValue,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #store,
          [
            key,
            entityValue,
          ],
        ),
        returnValue: _i6.Future<_i2.Unit>.value(_FakeUnit_0(
          this,
          Invocation.method(
            #store,
            [
              key,
              entityValue,
            ],
          ),
        )),
      ) as _i6.Future<_i2.Unit>);

  @override
  _i6.Future<_i2.Unit> storeUnprotected(
    String? key,
    _i2.Unit? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeUnprotected,
          [
            key,
            value,
          ],
        ),
        returnValue: _i6.Future<_i2.Unit>.value(_FakeUnit_0(
          this,
          Invocation.method(
            #storeUnprotected,
            [
              key,
              value,
            ],
          ),
        )),
      ) as _i6.Future<_i2.Unit>);

  @override
  _i6.Future<void> delete(String? key) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [key],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteUnprotected(String? key) => (super.noSuchMethod(
        Invocation.method(
          #deleteUnprotected,
          [key],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> setCacheSyncFlags(
          _i4.HashMap<String, String>? serverCheckSums) =>
      (super.noSuchMethod(
        Invocation.method(
          #setCacheSyncFlags,
          [serverCheckSums],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i4.HashMap<String, String>> getCacheCheckStates() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCacheCheckStates,
          [],
        ),
        returnValue: _i6.Future<_i4.HashMap<String, String>>.value(
            _i5.dummyValue<_i4.HashMap<String, String>>(
          this,
          Invocation.method(
            #getCacheCheckStates,
            [],
          ),
        )),
      ) as _i6.Future<_i4.HashMap<String, String>>);
}