/// Modelo de datos para Ciudad desde APIs externas
class CityApiModel {
  final String name;
  final String stateCode;
  final String countryCode;

  const CityApiModel({
    required this.name,
    required this.stateCode,
    required this.countryCode,
  });

  /// Factory para crear desde JSON de CountryStateCity API
  factory CityApiModel.fromJson(Map<String, dynamic> json) {
    return CityApiModel(
      name: json['name'] ?? '',
      stateCode: json['state_code'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'stateCode': stateCode, 'countryCode': countryCode};
  }
}
