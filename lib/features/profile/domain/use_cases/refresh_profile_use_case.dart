import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class RefreshProfileUseCase {
  final ProfileRepository repository;

  RefreshProfileUseCase(this.repository);

  Future<User?> call() async {
    return await repository.refreshProfile();
  }
}
