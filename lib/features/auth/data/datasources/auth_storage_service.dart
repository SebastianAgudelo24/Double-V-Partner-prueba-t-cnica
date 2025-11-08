import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/utils/app_logger.dart';

/// Servicio de almacenamiento seguro local
/// RESPONSABILIDAD: Solo operaciones de storage + manejo de FlutterSecureStorage
class AuthStorageService {
  final FlutterSecureStorage secureStorage;
  static const String _userKey = 'user_data';

  AuthStorageService({required this.secureStorage});

  /// Guarda datos RAW en storage seguro
  Future<void> saveRawUserData(String userData) async {
    try {
      AppLogger.i('Guardando datos de usuario', tag: 'auth_storage');
      await secureStorage.write(key: _userKey, value: userData);
      AppLogger.i('Datos guardados exitosamente', tag: 'auth_storage');
    } catch (e) {
      AppLogger.e('Error al guardar datos', tag: 'auth_storage', data: e);
      rethrow;
    }
  }

  /// Obtiene datos RAW del storage seguro
  Future<String?> getRawUserData() async {
    try {
      return await secureStorage.read(key: _userKey);
    } catch (e) {
      AppLogger.e('Error al leer datos', tag: 'auth_storage', data: e);
      return null;
    }
  }

  /// Elimina datos del storage
  Future<void> clearData() async {
    try {
      await secureStorage.delete(key: _userKey);
      AppLogger.i('Datos eliminados', tag: 'auth_storage');
    } catch (e) {
      AppLogger.e('Error al eliminar datos', tag: 'auth_storage', data: e);
      rethrow;
    }
  }

  /// Verifica si existen datos en storage
  Future<bool> hasData() async {
    try {
      final userData = await secureStorage.read(key: _userKey);
      return userData != null;
    } catch (e) {
      return false;
    }
  }
}
