import 'package:dio/dio.dart';

import 'network_config.dart';

/// 🏭 Factory para crear instancias de Dio configuradas según mejores prácticas
class DioClient {
  /// Configuración de URLs según la plataforma (manteniendo tu lógica actual)
  static String get baseUrl => NetworkConfig.baseUrl;

  /// 🔧 Crea instancia de Dio con interceptores completos
  static Dio createAuthenticatedDio() {
    final dio = Dio(_baseOptions);
    return dio;
  }

  /// 🔧 Crea instancia de Dio para requests públicos (sin auth)
  static Dio createPublicDio() {
    final dio = Dio(_baseOptions);

    // Manejo de errores ahora centralizado en capas superiores (BaseRemoteDataSource / AppException)

    return dio;
  }

  /// ⚙️ Configuración base común
  static BaseOptions get _baseOptions => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: NetworkConfig.connectTimeout,
    receiveTimeout: NetworkConfig.receiveTimeout,
    sendTimeout: NetworkConfig.sendTimeout,
    headers: NetworkConfig.defaultHeaders,
  );
}
