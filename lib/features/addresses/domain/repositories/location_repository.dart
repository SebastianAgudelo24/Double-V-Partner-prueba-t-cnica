import '../entities/country.dart';
import '../entities/state.dart' as entities;
import '../entities/city.dart';

/// Repositorio abstracto para obtener datos de ubicación
abstract class LocationRepository {
  /// Obtiene todos los países disponibles
  Future<List<Country>> getCountries();

  /// Obtiene los estados/departamentos de un país específico
  Future<List<entities.AddressState>> getStatesByCountry(String countryCode);

  /// Obtiene las ciudades de un estado específico
  Future<List<City>> getCitiesByState(String countryCode, String stateCode);
}
