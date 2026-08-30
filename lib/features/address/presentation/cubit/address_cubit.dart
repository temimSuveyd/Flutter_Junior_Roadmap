import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/device_features/location_service.dart';
import '../../../../core/storage/address_data.dart';
import '../../../../core/storage/address_store.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(this._locationService, this._addressStore)
    : super(const AddressState()) {
    _loadSaved();
  }

  final LocationService _locationService;
  final AddressStore _addressStore;

  Future<void> _loadSaved() async {
    final saved = await _addressStore.read();
    emit(state.copyWith(savedAddress: saved));
  }

  Future<Address?> fetchCurrentAddress() async {
    emit(state.copyWith(isFetching: true));
    try {
      final address = await _locationService.getCurrentAddress();
      emit(state.copyWith(isFetching: false, detected: address));
      return address;
    } on LocationException catch (e) {
      emit(state.copyWith(isFetching: false, error: e.messageKey));
      return null;
    } catch (_) {
      emit(state.copyWith(isFetching: false, error: 'locationError'));
      return null;
    }
  }

  Future<void> saveAddress(String city, String fullAddress) async {
    final address = Address(city: city.trim(), fullAddress: fullAddress.trim());
    await _addressStore.save(address);
    emit(state.copyWith(savedAddress: address, detected: address));
  }
}

@immutable
final class AddressState extends Equatable {
  const AddressState({
    this.savedAddress,
    this.detected,
    this.isFetching = false,
    this.error,
  });
  final Address? savedAddress;
  final Address? detected;
  final bool isFetching;
  final String? error;

  AddressState copyWith({
    Address? savedAddress,
    Address? detected,
    bool? isFetching,
    String? error,
  }) {
    return AddressState(
      savedAddress: savedAddress ?? this.savedAddress,
      detected: detected ?? this.detected,
      isFetching: isFetching ?? this.isFetching,
      error: error,
    );
  }

  @override
  List<Object?> get props => [savedAddress, detected, isFetching, error];
}
