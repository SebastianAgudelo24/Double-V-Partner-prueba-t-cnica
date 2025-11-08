import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../utils/app_logger.dart';

/// 🏛️ Repositorio base que proporciona funcionalidades comunes para todos los data sources
/// Siguiendo el patrón de Clean Architecture manteniendo las capas bien separadas
abstract class BaseRemoteDataSource {
  final Dio dio;

  BaseRemoteDataSource(this.dio);

  /// 🔧 GET request con manejo automático de errores
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? parser,
  }) async {
    try {
  AppLogger.d('GET $endpoint', tag: 'http');
      
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      if (response.statusCode == 200) {
  AppLogger.d('GET OK $endpoint', tag: 'http', data: response.data);
        
        if (parser != null) {
          return parser(response.data);
        }
        
        return response.data as T;
      } else {
        throw Exception(response.data?['message'] ?? 'Error en GET request');
      }
    } catch (e, st) {
  AppLogger.e('GET FAIL $endpoint', tag: 'http', data: {'e': e, 'st': st.toString().split('\n').first});
      throw AppException.from(e);
    }
  }

  /// 🔧 POST request con manejo automático de errores
  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> data, {
    T Function(dynamic data)? parser,
    List<int> successCodes = const [200, 201],
  }) async {
    try {
  AppLogger.d('POST $endpoint', tag: 'http', data: data);
      
      final response = await dio.post(endpoint, data: data);
      
      if (successCodes.contains(response.statusCode)) {
  AppLogger.d('POST OK $endpoint', tag: 'http', data: response.data);
        
        if (parser != null) {
          return parser(response.data);
        }
        
        return response.data as T;
      } else {
        throw Exception(response.data?['message'] ?? 'Error en POST request');
      }
    } catch (e, st) {
  AppLogger.e('POST FAIL $endpoint', tag: 'http', data: {'e': e, 'st': st.toString().split('\n').first});
      throw AppException.from(e);
    }
  }

  /// 🔧 PUT request con manejo automático de errores
  Future<T> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic data)? parser,
  }) async {
    try {
  AppLogger.d('PUT $endpoint', tag: 'http', data: data);
      if (data != null) {
        final preview = data.toString();
        AppLogger.d('PUT data: ${preview.length > 200 ? '${preview.substring(0, 200)}...' : preview}', tag: 'http');
      }
      
      final response = await dio.put(endpoint, data: data);
      
      if (response.statusCode == 200) {
  AppLogger.d('PUT OK $endpoint', tag: 'http', data: response.data);
        
        if (parser != null) {
          return parser(response.data);
        }
        
        return response.data as T;
      } else {
        throw Exception(response.data?['message'] ?? 'Error en PUT request');
      }
    } catch (e, st) {
  AppLogger.e('PUT FAIL $endpoint', tag: 'http', data: {'e': e, 'st': st.toString().split('\n').first});
      throw AppException.from(e);
    }
  }

  /// 🔧 PATCH request con manejo automático de errores
  Future<T> patch<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic data)? parser,
  }) async {
    try {
  AppLogger.d('PATCH $endpoint', tag: 'http', data: data);
      if (data != null) {
        final preview = data.toString();
        AppLogger.d('PATCH data: ${preview.length > 200 ? '${preview.substring(0, 200)}...' : preview}', tag: 'http');
      }
      
      final response = await dio.patch(endpoint, data: data);
      
      if (response.statusCode == 200) {
  AppLogger.d('PATCH OK $endpoint', tag: 'http', data: response.data);
        
        if (parser != null) {
          return parser(response.data);
        }
        
        return response.data as T;
      } else {
        throw Exception(response.data?['message'] ?? 'Error en PATCH request');
      }
    } catch (e, st) {
  AppLogger.e('PATCH FAIL $endpoint', tag: 'http', data: {'e': e, 'st': st.toString().split('\n').first});
      throw AppException.from(e);
    }
  }

  /// 🔧 DELETE request con manejo automático de errores
  Future<T?> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic data)? parser,
    List<int> successCodes = const [200, 204],
  }) async {
    try {
  AppLogger.d('DELETE $endpoint', tag: 'http', data: data);
      if (data != null) {
        final preview = data.toString();
        AppLogger.d('DELETE data: ${preview.length > 200 ? '${preview.substring(0, 200)}...' : preview}', tag: 'http');
      }
      
      final response = await dio.delete(endpoint, data: data);
      
      if (successCodes.contains(response.statusCode)) {
  AppLogger.d('DELETE OK $endpoint', tag: 'http');
        
        // Para DELETE 204 (No Content), no hay data que parsear
        if (response.statusCode == 204 || response.data == null) {
          return null;
        }
        
        if (parser != null) {
          return parser(response.data);
        }
        
        return response.data as T;
      } else {
        throw Exception(response.data?['message'] ?? 'Error en DELETE request');
      }
    } catch (e, st) {
  AppLogger.e('DELETE FAIL $endpoint', tag: 'http', data: {'e': e, 'st': st.toString().split('\n').first});
      throw AppException.from(e);
    }
  }
}
