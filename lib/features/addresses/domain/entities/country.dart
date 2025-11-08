/// Entidad de dominio para País
class Country {
  final String code;
  final String name;
  final String flag;

  const Country({required this.code, required this.name, required this.flag});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Country(code: $code, name: $name)';
}
