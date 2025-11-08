/// Modelo de datos para País desde APIs externas
class CountryApiModel {
  final String code;
  final String name;
  final String flag;

  const CountryApiModel({
    required this.code,
    required this.name,
    required this.flag,
  });

  /// Factory para crear desde JSON de REST Countries API
  factory CountryApiModel.fromJson(Map<String, dynamic> json) {
    return CountryApiModel(
      code: json['cca2'] ?? '',
      name: json['name']['common'] ?? '',
      flag: json['flag'] ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'flag': flag};
  }
}
