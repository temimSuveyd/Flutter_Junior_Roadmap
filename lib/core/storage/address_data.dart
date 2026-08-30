import 'package:equatable/equatable.dart';

class Address extends Equatable {
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: (json['city'] as String?) ?? '',
      fullAddress: (json['fullAddress'] as String?) ?? '',
    );
  }

  const Address({required this.city, required this.fullAddress});
  final String city;
  final String fullAddress;

  Address copyWith({String? city, String? fullAddress}) {
    return Address(
      city: city ?? this.city,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }

  Map<String, dynamic> toJson() => {'city': city, 'fullAddress': fullAddress};

  @override
  List<Object?> get props => [city, fullAddress];
}
