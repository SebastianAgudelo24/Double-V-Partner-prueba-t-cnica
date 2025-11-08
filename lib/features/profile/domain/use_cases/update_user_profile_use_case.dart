import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<User> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}
