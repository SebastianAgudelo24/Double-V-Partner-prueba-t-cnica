import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<User> call({
    required String name,
    required String surname,
    required DateTime birthDate,
  }) async {
    return await repository.registerUser(
      name: name,
      surname: surname,
      birthDate: birthDate,
    );
  }
}
