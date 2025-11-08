/// Modelo de datos para Estado/Departamento desde APIs externas
class StateApiModel {
  final String code;
  final String name;
  final String countryCode;

  const StateApiModel({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  /// Factory para crear desde JSON de CountryStateCity API
  factory StateApiModel.fromJson(Map<String, dynamic> json) {
    return StateApiModel(
      code: json['iso2'] ?? '',
      name: json['name'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'countryCode': countryCode};
  }
}
