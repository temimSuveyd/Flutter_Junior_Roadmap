import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/services/network/failure.dart';

/// Tests that `runCatching` wraps successful and failing calls safely.
void main() {
  group('runCatching', () {
    test('returns Success when the future succeeds', () async {
      final result = await runCatching(() async => 42);

      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 42);
    });

    test('returns Error when the future throws', () async {
      final result = await runCatching<int>(() async => throw Exception('boom'));

      expect(result, isA<Error<int>>());
      expect((result as Error<int>).error, isA<Failure>());
    });
  });
}
