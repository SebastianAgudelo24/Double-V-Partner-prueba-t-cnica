import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart' as entities;
import '../../domain/entities/city.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';

/// Implementación concreta del LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<List<Country>> getCountries() async {
    try {
      return await _dataSource.fetchCountries();
    } catch (e) {
      // Aquí se podría agregar logging, caché, etc.
      rethrow;
    }
  }

  @override
  Future<List<entities.AddressState>> getStatesByCountry(
    String countryCode,
  ) async {
    try {
      if (countryCode.isEmpty) {
        throw ArgumentError('Country code cannot be empty');
      }
      return await _dataSource.fetchStatesByCountry(countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<City>> getCitiesByState(
    String countryCode,
    String stateCode,
  ) async {
    try {
      if (countryCode.isEmpty || stateCode.isEmpty) {
        throw ArgumentError('Country code and state code cannot be empty');
      }
      return await _dataSource.fetchCitiesByState(countryCode, stateCode);
    } catch (e) {
      rethrow;
    }
  }
}
