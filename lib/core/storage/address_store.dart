import 'address_data.dart';

abstract class AddressStore {
  Future<Address?> read();
  Future<void> save(Address address);
  Future<void> clear();
}
