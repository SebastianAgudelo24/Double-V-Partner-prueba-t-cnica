import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.country,
    required super.state,
    required super.city,
    super.streetAddress,
    super.isDefault = false,
    required super.createdAt,
  });

  // Convertir entidad a modelo
  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      country: address.country,
      state: address.state,
      city: address.city,
      streetAddress: address.streetAddress,
      isDefault: address.isDefault,
      createdAt: address.createdAt,
    );
  }

  // Convertir modelo a entidad
  Address toEntity() {
    return Address(
      id: id,
      country: country,
      state: state,
      city: city,
      streetAddress: streetAddress,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }

  // Parseo desde Map (JSON, SharedPreferences, etc.)
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      streetAddress: map['streetAddress'],
      isDefault: map['isDefault'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Parseo a Map (JSON, SharedPreferences, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country': country,
      'state': state,
      'city': city,
      'streetAddress': streetAddress,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith específico para el modelo
  @override
  AddressModel copyWith({
    String? id,
    String? country,
    String? state,
    String? city,
    String? streetAddress,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
