/// Entidad de dominio para Ciudad
class City {
  final String name;
  final String stateCode;
  final String countryCode;

  const City({
    required this.name,
    required this.stateCode,
    required this.countryCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          stateCode == other.stateCode &&
          countryCode == other.countryCode;

  @override
  int get hashCode => name.hashCode ^ stateCode.hashCode ^ countryCode.hashCode;

  @override
  String toString() =>
      'City(name: $name, stateCode: $stateCode, countryCode: $countryCode)';
}
