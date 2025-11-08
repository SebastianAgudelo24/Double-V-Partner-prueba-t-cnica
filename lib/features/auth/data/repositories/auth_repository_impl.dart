import '../../../../core/utils/app_logger.dart';
import '../datasources/auth_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUserData();
    AppLogger.d('Sesión cerrada localmente', tag: 'auth');
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.hasUser();
  }

  @override
  Future<User> registerUser({
    required String name,
    required String surname,
    required DateTime birthDate,
  }) async {
    AppLogger.d('Registrando usuario: $name $surname', tag: 'auth');
    return await localDataSource.registerUser(
      name: name,
      surname: surname,
      birthDate: birthDate,
    );
  }

  @override
  Future<void> updateUser(User user) async {
    await localDataSource.saveUser(user);
    AppLogger.d('Usuario actualizado', tag: 'auth');
  }
}
