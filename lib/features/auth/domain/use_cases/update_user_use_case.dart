import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call(User user) async {
    await repository.updateUser(user);
  }
}
