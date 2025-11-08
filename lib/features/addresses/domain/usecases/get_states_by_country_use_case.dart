import '../entities/state.dart' as entities;
import '../repositories/location_repository.dart';

class GetStatesByCountryUseCase {
  final LocationRepository repository;

  GetStatesByCountryUseCase(this.repository);

  Future<List<entities.AddressState>> call(String countryCode) async {
    return await repository.getStatesByCountry(countryCode);
  }
}
