import 'package:flutter_test/flutter_test.dart';
import 'package:build_stats_flutter/model/entity/cachable.dart';

void main() {
  group('Cacheable', () {
    test('toJson should return a map with the correct id', () {
      final cacheable = Cacheable(id: '123');
      expect(cacheable.toJson(), {'id': '123'});
    });

    test('joinData should return the correct joined string', () {
      final cacheable = Cacheable(id: '123');
      expect(cacheable.joinData(), '123');
    });

    test('getChecksum should return the correct FNV-1a hash', () {
      final cacheable = Cacheable(id: '123');
      // Precomputed FNV-1a hash for '123'
      expect(cacheable.getChecksum(), '7238631b');
    });
  });
}
