class Address {
  final String id;
  final String country;
  final String state;
  final String city;
  final String? streetAddress;
  final bool isDefault;
  final DateTime createdAt;

  const Address({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    this.streetAddress,
    this.isDefault = false,
    required this.createdAt,
  });

  // Dirección completa como string
  String get fullAddress {
    final parts = <String>[
      if (streetAddress?.isNotEmpty == true) streetAddress!,
      city,
      state,
      country,
    ];
    return parts.join(', ');
  }

  Address copyWith({
    String? id,
    String? country,
    String? state,
    String? city,
    String? streetAddress,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Address(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, fullAddress: $fullAddress, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
