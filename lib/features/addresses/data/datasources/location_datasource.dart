import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart' as entities;
import '../../domain/entities/city.dart';

/// DataSource abstracto para obtener datos de ubicación desde APIs externas
abstract class LocationDataSource {
  /// Obtiene países desde REST Countries API
  Future<List<Country>> fetchCountries();

  /// Obtiene estados desde CountryStateCity API
  Future<List<entities.AddressState>> fetchStatesByCountry(String countryCode);

  /// Obtiene ciudades desde CountryStateCity API
  Future<List<City>> fetchCitiesByState(String countryCode, String stateCode);
}
