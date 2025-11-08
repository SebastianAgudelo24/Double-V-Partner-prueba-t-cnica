import '../../domain/entities/user.dart';

/// DataSource abstracto para operaciones de autenticación local
abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUserData();
  Future<bool> hasUser();
  Future<User> registerUser({
    required String name,
    required String surname,
    required DateTime birthDate,
  });
}
