/// Entidad de dominio para Estado/Departamento
class AddressState {
  final String code;
  final String name;
  final String countryCode;

  const AddressState({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressState &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          countryCode == other.countryCode;

  @override
  int get hashCode => code.hashCode ^ countryCode.hashCode;

  @override
  String toString() =>
      'State(code: $code, name: $name, countryCode: $countryCode)';
}
