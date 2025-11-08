import '../entities/city.dart';
import '../repositories/location_repository.dart';

class GetCitiesByStateUseCase {
  final LocationRepository repository;

  GetCitiesByStateUseCase(this.repository);

  Future<List<City>> call(String countryCode, String stateCode) async {
    return await repository.getCitiesByState(countryCode, stateCode);
  }
}
