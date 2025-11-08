import 'package:dio/dio.dart';
import '../utils/app_logger.dart';
import 'app_failure.dart';

/// Exception estándar que envuelve un AppFailure
class AppException implements Exception {
  final AppFailure failure;
  const AppException(this.failure);

  @override
  String toString() => failure.message;

  static AppException from(dynamic error) {
    if (error is AppException) return error; // ya envuelto
    if (error is DioException) {
      return _fromDio(error);
    }
    final raw = error.toString();
    return AppException(AppFailure.unknown(raw));
  }

  static AppException _fromDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String? backendMessage;
    if (data is Map<String, dynamic>) {
      backendMessage = (data['message'] ?? data['error'])?.toString();
    } else if (data is List && data.isNotEmpty) {
      backendMessage = data.first.toString();
    }
    // Clasificación por tipo
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(AppFailure.timeout(backendMessage, status, data));
      case DioExceptionType.cancel:
        return AppException(AppFailure.cancelled(backendMessage, status, data));
      case DioExceptionType.badResponse:
        return AppException(_mapStatus(status, backendMessage, data));
      case DioExceptionType.badCertificate:
        return AppException(AppFailure.server('Certificado no válido', status, data));
      case DioExceptionType.connectionError:
        return AppException(AppFailure.network(backendMessage, status, data));
      case DioExceptionType.unknown:
        // Podría ser network offline
        if (backendMessage == null && e.message?.contains('SocketException') == true) {
          return AppException(AppFailure.network('Sin conexión a internet', status, data));
        }
        return AppException(AppFailure.unknown(backendMessage ?? e.message, status, data));
    }
  }

  static AppFailure _mapStatus(int? status, String? message, dynamic raw) {
    switch (status) {
      case 400:
        // Puede ser validación según contenido
        if (_looksLikeValidation(raw)) {
          return AppFailure.validation(message, status, raw);
        }
        return AppFailure.validation(message ?? 'Solicitud incorrecta', status, raw);
      case 401:
        return AppFailure.unauthorized(message, status, raw);
      case 403:
        return AppFailure.forbidden(message, status, raw);
      case 404:
        return AppFailure.notFound(message, status, raw);
      case 409:
        return AppFailure.conflict(message, status, raw);
      case 422:
        return AppFailure.validation(message, status, raw);
      case 429:
        return AppFailure.network('Demasiadas solicitudes', status, raw);
      case 500:
      case 502:
      case 503:
      case 504:
        return AppFailure.server(message, status, raw);
      default:
        return AppFailure.unknown(message, status, raw);
    }
  }

  static bool _looksLikeValidation(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw['errors'] != null || raw['validation'] != null;
    }
    return false;
  }
}

/// Helper para ejecutar operaciones y mapear automáticamente a AppException
Future<T> guard<T>(Future<T> Function() fn, {String? op}) async {
  try {
    return await fn();
  } catch (e, st) {
    AppLogger.e('op fail ${op ?? ''}', tag: 'error', data: {'e': e, 'st': st.toString().split('\n').first});
    throw AppException.from(e);
  }
}
