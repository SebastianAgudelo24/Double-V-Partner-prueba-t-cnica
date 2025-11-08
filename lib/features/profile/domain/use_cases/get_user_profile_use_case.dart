import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getUserProfile();
  }
}
