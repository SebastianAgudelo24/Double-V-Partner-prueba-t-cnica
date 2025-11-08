import '../../../../core/utils/app_logger.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/datasources/auth_datasource.dart';
import '../../../addresses/domain/entities/address.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<User?> getUserProfile() async {
    return await localDataSource.getUser();
  }

  @override
  Future<User> updateUserProfile(User user) async {
    await localDataSource.saveUser(user.copyWith(updatedAt: DateTime.now()));
    AppLogger.d('Perfil del usuario actualizado', tag: 'profile');
    return user;
  }

  @override
  Future<User> addAddressToProfile({
    required String country,
    required String state,
    required String city,
    String? streetAddress,
    bool? setAsDefault,
  }) async {
    final currentUser = await getUserProfile();
    if (currentUser == null) {
      throw Exception('No hay usuario autenticado para agregar dirección');
    }

    // Determinar si debe ser dirección por defecto
    final shouldBeDefault = setAsDefault ?? currentUser.addresses.isEmpty;

    final address = Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      country: country,
      state: state,
      city: city,
      streetAddress: streetAddress,
      isDefault: shouldBeDefault,
      createdAt: DateTime.now(),
    );

    // Agregar dirección al usuario
    final updatedAddresses = [...currentUser.addresses];

    // Si es por defecto, quitar default de otras direcciones
    if (address.isDefault) {
      for (int i = 0; i < updatedAddresses.length; i++) {
        updatedAddresses[i] = updatedAddresses[i].copyWith(isDefault: false);
      }
    }

    updatedAddresses.add(address);

    final updatedUser = currentUser.copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );

    await localDataSource.saveUser(updatedUser);
    AppLogger.d('Dirección agregada al perfil del usuario', tag: 'profile');

    return updatedUser;
  }

  @override
  Future<User?> refreshProfile() async {
    AppLogger.d('Refrescando perfil del usuario', tag: 'profile');
    return await localDataSource.getUser();
  }
}
