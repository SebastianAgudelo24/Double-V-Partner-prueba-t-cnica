import '../../domain/entities/user.dart';
import '../../../addresses/domain/entities/address.dart';
import '../../../addresses/data/models/address_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.surname,
    required super.birthDate,
    required super.addresses,
    required super.createdAt,
    required super.updatedAt,
  });

  // Convertir entidad a modelo
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      surname: user.surname,
      birthDate: user.birthDate,
      addresses: user.addresses,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  // Convertir modelo a entidad
  User toEntity() {
    return User(
      id: id,
      name: name,
      surname: surname,
      birthDate: birthDate,
      addresses: addresses,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Parseo desde Map (JSON, SharedPreferences, etc.)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
      addresses:
          (map['addresses'] as List<dynamic>?)
              ?.map(
                (addr) =>
                    AddressModel.fromMap(
                      addr as Map<String, dynamic>,
                    ).toEntity(),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Parseo a Map (JSON, SharedPreferences, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'birthDate': birthDate.toIso8601String(),
      'addresses':
          addresses
              .map((addr) => AddressModel.fromEntity(addr).toMap())
              .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // CopyWith específico para el modelo
  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? surname,
    DateTime? birthDate,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
