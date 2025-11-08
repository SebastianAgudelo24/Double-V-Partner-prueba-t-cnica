import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<User> registerUser({
    required String name,
    required String surname,
    required DateTime birthDate,
  });

  Future<void> updateUser(User user);
}
