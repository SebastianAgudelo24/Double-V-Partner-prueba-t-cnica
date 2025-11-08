import 'package:dio/dio.dart';
import '../models/country_api_model.dart';
import '../models/state_api_model.dart';
import '../models/city_api_model.dart';

class LocationRemoteService {
  final Dio _dio;

  LocationRemoteService() : _dio = Dio();

  /// Obtiene todos los países usando REST Countries API
  Future<List<CountryApiModel>> getCountries() async {
    try {
      final response = await _dio.get(
        'https://restcountries.com/v3.1/all',
        queryParameters: {'fields': 'name,cca2,flag'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CountryApiModel.fromJson(json))
            .where((country) => country.name.isNotEmpty)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }

      throw Exception('Failed to load countries');
    } catch (e) {
      throw Exception('Error loading countries: $e');
    }
  }

  /// Obtiene departamentos/estados de un país específico
  Future<List<StateApiModel>> getStatesByCountry(String countryCode) async {
    try {
      final response = await _dio.get(
        'https://api.countrystatecity.in/v1/countries/$countryCode/states',
        options: Options(headers: {'X-CSCAPI-KEY': 'YOUR_API_KEY_HERE'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => StateApiModel.fromJson(json))
            .where((state) => state.name.isNotEmpty)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }

      throw Exception('Failed to load states');
    } catch (e) {
      // Fallback: datos estáticos para algunos países
      return _getFallbackStates(countryCode);
    }
  }

  /// Obtiene ciudades de un departamento/estado específico
  Future<List<CityApiModel>> getCitiesByState(
    String countryCode,
    String stateCode,
  ) async {
    try {
      final response = await _dio.get(
        'https://api.countrystatecity.in/v1/countries/$countryCode/states/$stateCode/cities',
        options: Options(headers: {'X-CSCAPI-KEY': 'YOUR_API_KEY_HERE'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CityApiModel.fromJson(json))
            .where((city) => city.name.isNotEmpty)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }

      throw Exception('Failed to load cities');
    } catch (e) {
      // Fallback: datos estáticos para algunas combinaciones
      return _getFallbackCities(countryCode, stateCode);
    }
  }

  /// Datos de respaldo para estados (Colombia como ejemplo)
  List<StateApiModel> _getFallbackStates(String countryCode) {
    if (countryCode.toLowerCase() == 'co') {
      return [
        StateApiModel(code: 'ANT', name: 'Antioquia', countryCode: 'CO'),
        StateApiModel(code: 'BOG', name: 'Bogotá D.C.', countryCode: 'CO'),
        StateApiModel(code: 'VAC', name: 'Valle del Cauca', countryCode: 'CO'),
        StateApiModel(code: 'CUN', name: 'Cundinamarca', countryCode: 'CO'),
        StateApiModel(code: 'ATL', name: 'Atlántico', countryCode: 'CO'),
      ];
    }

    return [];
  }

  /// Datos de respaldo para ciudades
  List<CityApiModel> _getFallbackCities(String countryCode, String stateCode) {
    if (countryCode.toLowerCase() == 'co') {
      switch (stateCode.toLowerCase()) {
        case 'ant':
          return [
            CityApiModel(name: 'Medellín', stateCode: 'ANT', countryCode: 'CO'),
            CityApiModel(name: 'Bello', stateCode: 'ANT', countryCode: 'CO'),
            CityApiModel(name: 'Itagüí', stateCode: 'ANT', countryCode: 'CO'),
            CityApiModel(name: 'Envigado', stateCode: 'ANT', countryCode: 'CO'),
          ];
        case 'bog':
          return [
            CityApiModel(name: 'Bogotá', stateCode: 'BOG', countryCode: 'CO'),
          ];
        case 'vac':
          return [
            CityApiModel(name: 'Cali', stateCode: 'VAC', countryCode: 'CO'),
            CityApiModel(name: 'Palmira', stateCode: 'VAC', countryCode: 'CO'),
            CityApiModel(
              name: 'Buenaventura',
              stateCode: 'VAC',
              countryCode: 'CO',
            ),
          ];
      }
    }

    return [];
  }
}
