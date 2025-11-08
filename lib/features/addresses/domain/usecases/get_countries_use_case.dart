import '../entities/country.dart';
import '../repositories/location_repository.dart';

class GetCountriesUseCase {
  final LocationRepository repository;

  GetCountriesUseCase(this.repository);

  Future<List<Country>> call() async {
    return await repository.getCountries();
  }
}
