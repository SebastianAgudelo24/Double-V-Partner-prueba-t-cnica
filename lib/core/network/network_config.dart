import 'dart:io';

/// Permite override vía --dart-define=API_BASE_URL y APP_ENV (dev|prod)
const String _kDefineBaseUrl = String.fromEnvironment('API_BASE_URL');
const String _kDefineEnv = String.fromEnvironment('APP_ENV');

/// 🌐 Configuración centralizada de red
class NetworkConfig {
  // 🏭 URLs de entorno
  static const String _devBaseUrl = 'http://localhost:3000/api/v1';
  static const String _androidDevUrl = 'http://10.0.2.2:3000/api/v1';
  static const String _prodBaseUrl = 'https://api.pass121.com/api/v1';
  
  // 🎯 Environment flags
  static bool get _isDevelopment {
    if (_kDefineEnv.isNotEmpty) {
      return _kDefineEnv.toLowerCase().startsWith('dev');
    }
    return true; // default
  }
  
  static String get baseUrl {
    if (_kDefineBaseUrl.isNotEmpty) return _kDefineBaseUrl;
    if (_isDevelopment) {
      return Platform.isAndroid ? _androidDevUrl : _devBaseUrl;
    }
    return _prodBaseUrl;
  }
  
  // ⏱️ Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 📝 Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // 🔍 Rutas públicas (no requieren autenticación)
  static const List<String> publicRoutes = [
    '/client-auth/login',
    '/client-auth/send-sms-otp',
    '/client-auth/verify-otp',
    '/client-auth/refresh-token',
    '/client-auth/countries',
    '/client-auth/resend-sms-otp',
  ];
  
  static bool isPublicRoute(String path) {
    return publicRoutes.any((route) => path.contains(route));
  }
}
