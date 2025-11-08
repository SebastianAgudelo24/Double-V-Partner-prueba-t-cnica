import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  /// Obtiene el perfil del usuario actual
  Future<User?> getUserProfile();

  /// Actualiza la información del perfil del usuario
  Future<User> updateUserProfile(User user);

  /// Agrega una nueva dirección al perfil del usuario
  Future<User> addAddressToProfile({
    required String country,
    required String state,
    required String city,
    String? streetAddress,
    bool? setAsDefault,
  });

  /// Refresca los datos del perfil desde el storage
  Future<User?> refreshProfile();
}
