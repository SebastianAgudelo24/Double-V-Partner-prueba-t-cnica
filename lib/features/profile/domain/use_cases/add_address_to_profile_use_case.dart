import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class AddAddressToProfileUseCase {
  final ProfileRepository repository;

  AddAddressToProfileUseCase(this.repository);

  Future<User> call({
    required String country,
    required String state,
    required String city,
    String? streetAddress,
    bool? setAsDefault,
  }) async {
    return await repository.addAddressToProfile(
      country: country,
      state: state,
      city: city,
      streetAddress: streetAddress,
      setAsDefault: setAsDefault,
    );
  }
}
