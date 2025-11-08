import '../../../addresses/domain/entities/address.dart';

class User {
  final String id;
  final String name;
  final String surname;
  final DateTime birthDate;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName {
    if (name.isEmpty && surname.isEmpty) return 'Usuario';
    if (name.isEmpty) return surname;
    if (surname.isEmpty) return name;
    return '$name $surname';
  }

  String get displayName => '$name ${surname.isNotEmpty ? surname[0] : ''}.';

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Address? get defaultAddress {
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  bool get isComplete {
    return name.isNotEmpty && surname.isNotEmpty && addresses.isNotEmpty;
  }

  User copyWith({
    String? id,
    String? name,
    String? surname,
    DateTime? birthDate,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $fullName, age: $age)';
}
