import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:juniorflutterroadmap/core/services/device_features/location_service.dart';
import 'package:juniorflutterroadmap/core/services/device_features/permission_service.dart';
import 'package:juniorflutterroadmap/core/storage/address_data.dart';
import 'package:mocktail/mocktail.dart';

// Reusable mock of the LocationService interface (same style as MockImagePickerService).
class MockLocationService extends Mock implements LocationService {}

class MockPermissionService extends Mock implements PermissionService {}

Position _fakePosition(double latitude, double longitude) => Position(
  latitude: latitude,
  longitude: longitude,
  timestamp: DateTime.now(),
  accuracy: 0,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

void main() {
  group('LocationServiceImpl', () {
    late MockPermissionService permission;
    late LocationServiceImpl service;

    setUp(() {
      permission = MockPermissionService();
      service = LocationServiceImpl(permission);
    });

    test('throws locationPermissionDenied when permission is denied', () async {
      when(
        () => permission.checkAndRequestLocationPermission(),
      ).thenAnswer((_) async => false);

      expect(
        () => service.getCurrentAddress(),
        throwsA(
          isA<LocationException>().having(
            (e) => e.messageKey,
            'messageKey',
            'locationPermissionDenied',
          ),
        ),
      );
    });

    test('throws locationError when getCurrentPosition fails', () async {
      when(
        () => permission.checkAndRequestLocationPermission(),
      ).thenAnswer((_) async => true);
      service = LocationServiceImpl(
        permission,
        getCurrentPosition:
            ({LocationAccuracy? desiredAccuracy, Duration? timeLimit}) async =>
                throw Exception('gps unavailable'),
      );

      expect(
        () => service.getCurrentAddress(),
        throwsA(
          isA<LocationException>().having(
            (e) => e.messageKey,
            'messageKey',
            'locationError',
          ),
        ),
      );
    });

    test('throws locationError when no placemarks are returned', () async {
      when(
        () => permission.checkAndRequestLocationPermission(),
      ).thenAnswer((_) async => true);
      service = LocationServiceImpl(
        permission,
        getCurrentPosition:
            ({LocationAccuracy? desiredAccuracy, Duration? timeLimit}) async =>
                _fakePosition(36.2, 37.1),
        placemarkFromCoordinates: (double latitude, double longitude) async =>
            <Placemark>[],
      );

      expect(
        () => service.getCurrentAddress(),
        throwsA(
          isA<LocationException>().having(
            (e) => e.messageKey,
            'messageKey',
            'locationError',
          ),
        ),
      );
    });

    test('returns Address with city and fullAddress on success', () async {
      when(
        () => permission.checkAndRequestLocationPermission(),
      ).thenAnswer((_) async => true);
      service = LocationServiceImpl(
        permission,
        getCurrentPosition:
            ({LocationAccuracy? desiredAccuracy, Duration? timeLimit}) async =>
                _fakePosition(36.2, 37.1),
        placemarkFromCoordinates: (double latitude, double longitude) async =>
            const [
              Placemark(
                street: 'St 10',
                subLocality: 'District',
                locality: 'Halep',
                postalCode: '12345',
                country: 'Syria',
              ),
            ],
      );

      final address = await service.getCurrentAddress();

      expect(address.city, 'Halep');
      expect(address.fullAddress, contains('Halep'));
      expect(address.fullAddress, contains('Syria'));
      expect(address.fullAddress, contains('St 10'));
    });
  });

  // Sanity check that the generated mock matches the interface (same style
  // as the MockImagePickerService stub test).
  group('MockLocationService', () {
    late MockLocationService mock;

    setUp(() => mock = MockLocationService());

    test('can stub getCurrentAddress', () async {
      when(() => mock.getCurrentAddress()).thenAnswer(
        (_) async => const Address(city: 'Mock', fullAddress: 'Mock City'),
      );

      final address = await mock.getCurrentAddress();

      expect(address.city, 'Mock');
      verify(() => mock.getCurrentAddress()).called(1);
    });
  });
}
