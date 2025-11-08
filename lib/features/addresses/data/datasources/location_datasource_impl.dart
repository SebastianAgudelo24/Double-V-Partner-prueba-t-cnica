import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart' as entities;
import '../../domain/entities/city.dart';
import 'location_datasource.dart';
import 'location_remote_service.dart';
import '../models/country_api_model.dart';
import '../models/state_api_model.dart';
import '../models/city_api_model.dart';

/// Implementación concreta del LocationDataSource usando APIs REST
class LocationDataSourceImpl implements LocationDataSource {
  final LocationRemoteService _apiService;

  LocationDataSourceImpl(this._apiService);

  @override
  Future<List<Country>> fetchCountries() async {
    try {
      final apiModels = await _apiService.getCountries();
      return apiModels
          .map((apiModel) => _countryApiToEntity(apiModel))
          .toList();
    } catch (e) {
      throw Exception('Error loading countries: $e');
    }
  }

  @override
  Future<List<entities.AddressState>> fetchStatesByCountry(
    String countryCode,
  ) async {
    try {
      final apiModels = await _apiService.getStatesByCountry(countryCode);
      return apiModels.map((apiModel) => _stateApiToEntity(apiModel)).toList();
    } catch (e) {
      throw Exception('Error loading states: $e');
    }
  }

  @override
  Future<List<City>> fetchCitiesByState(
    String countryCode,
    String stateCode,
  ) async {
    try {
      final apiModels = await _apiService.getCitiesByState(
        countryCode,
        stateCode,
      );
      return apiModels.map((apiModel) => _cityApiToEntity(apiModel)).toList();
    } catch (e) {
      throw Exception('Error loading cities: $e');
    }
  }

  // Mappers para convertir de API models a domain entities
  Country _countryApiToEntity(CountryApiModel apiModel) {
    return Country(
      code: apiModel.code,
      name: apiModel.name,
      flag: apiModel.flag,
    );
  }

  entities.AddressState _stateApiToEntity(StateApiModel apiModel) {
    return entities.AddressState(
      code: apiModel.code,
      name: apiModel.name,
      countryCode: apiModel.countryCode,
    );
  }

  City _cityApiToEntity(CityApiModel apiModel) {
    return City(
      name: apiModel.name,
      stateCode: apiModel.stateCode,
      countryCode: apiModel.countryCode,
    );
  }
}
