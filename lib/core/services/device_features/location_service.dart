import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/storage/address_data.dart';
import 'permission_service.dart';

abstract class LocationService {
  Future<Address> getCurrentAddress();
}

class LocationException implements Exception {
  const LocationException(this.messageKey);
  final String messageKey;
}

class LocationServiceImpl implements LocationService {
  LocationServiceImpl(this._permissionService);

  final PermissionService _permissionService;

  @override
  Future<Address> getCurrentAddress() async {
    final hasPermission = await _permissionService
        .checkAndRequestLocationPermission();
    if (!hasPermission) {
      throw const LocationException('locationPermissionDenied');
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        throw const LocationException('locationError');
      }

      final place = placemarks.first;
      final city =
          place.locality ?? place.subLocality ?? place.administrativeArea ?? '';
      final fullAddress = [
        place.street,
        place.subLocality,
        place.locality,
        place.postalCode,
        place.country,
      ].whereType<String>().where((e) => e.isNotEmpty).join(', ');

      return Address(city: city, fullAddress: fullAddress);
    } catch (e) {
      if (e is LocationException) rethrow;
      throw const LocationException('locationError');
    }
  }
}
