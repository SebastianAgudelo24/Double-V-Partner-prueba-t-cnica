/// Representa un fallo de dominio normalizado para la capa de presentación
/// Mantiene un mensaje amigable + metadatos opcionales.
class AppFailure {
  final AppFailureType type;
  final String message;
  final int? statusCode;
  final String? code; // código específico backend si existe
  final dynamic raw; // respuesta cruda para logging/debug

  const AppFailure({
    required this.type,
    required this.message,
    this.statusCode,
    this.code,
    this.raw,
  });

  factory AppFailure.network([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.network,
        message: message ?? 'Error de conexión. Verifique su internet',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.timeout([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.timeout,
        message: message ?? 'Tiempo de espera agotado',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.cancelled([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.cancelled,
        message: message ?? 'Solicitud cancelada',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.unauthorized([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.unauthorized,
        message: message ?? 'No autorizado',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.forbidden([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.forbidden,
        message: message ?? 'Acceso denegado',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.notFound([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.notFound,
        message: message ?? 'Recurso no encontrado',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.validation([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.validation,
        message: message ?? 'Datos inválidos',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.conflict([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.conflict,
        message: message ?? 'Conflicto de datos',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.server([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.server,
        message: message ?? 'Error interno del servidor',
        statusCode: status,
        raw: raw,
      );
  factory AppFailure.unknown([String? message, int? status, dynamic raw]) => AppFailure(
        type: AppFailureType.unknown,
        message: message ?? 'Ha ocurrido un error inesperado',
        statusCode: status,
        raw: raw,
      );
}

enum AppFailureType {
  network,
  timeout,
  cancelled,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  server,
  unknown,
}
