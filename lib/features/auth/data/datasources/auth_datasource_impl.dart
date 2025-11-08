import 'dart:convert';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'auth_datasource.dart';
import 'auth_storage_service.dart';
import '../../../../core/utils/app_logger.dart';

/// Implementación concreta del AuthLocalDataSource
/// RESPONSABILIDAD: Usar AuthStorageService + parsear modelos a entidades
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AuthStorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> saveUser(User user) async {
    try {
      AppLogger.i(
        'Procesando usuario: ${user.fullName}',
        tag: 'auth_datasource',
      );

      // 1. Convertir entidad a modelo
      final userModel = UserModel.fromEntity(user);

      // 2. Serializar modelo
      final userData = jsonEncode(userModel.toMap());

      // 3. Guardar usando el servicio de storage
      await _storageService.saveRawUserData(userData);

      AppLogger.i('Usuario procesado exitosamente', tag: 'auth_datasource');
    } catch (e) {
      AppLogger.e('Error al procesar usuario', tag: 'auth_datasource', data: e);
      rethrow;
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      // 1. Obtener datos RAW del storage
      final rawUserData = await _storageService.getRawUserData();
      if (rawUserData == null) return null;

      // 2. Parsear JSON a modelo
      final userMap = jsonDecode(rawUserData) as Map<String, dynamic>;
      final userModel = UserModel.fromMap(userMap);

      // 3. Convertir modelo a entidad
      return userModel.toEntity();
    } catch (e) {
      AppLogger.e('Error al obtener usuario', tag: 'auth_datasource', data: e);
      return null;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _storageService.clearData();
      AppLogger.i('Datos de usuario eliminados', tag: 'auth_datasource');
    } catch (e) {
      AppLogger.e(
        'Error al eliminar datos de usuario',
        tag: 'auth_datasource',
        data: e,
      );
      rethrow;
    }
  }

  @override
  Future<bool> hasUser() async {
    return await _storageService.hasData();
  }

  @override
  Future<User> registerUser({
    required String name,
    required String surname,
    required DateTime birthDate,
  }) async {
    try {
      AppLogger.i(
        'Registrando nuevo usuario: $name $surname',
        tag: 'auth_datasource',
      );

      // 1. Crear entidad de usuario
      final now = DateTime.now();
      final user = User(
        id: now.millisecondsSinceEpoch.toString(),
        name: name,
        surname: surname,
        birthDate: birthDate,
        addresses: [],
        createdAt: now,
        updatedAt: now,
      );

      // 2. Guardar usando el método saveUser (reutilización)
      await saveUser(user);

      AppLogger.i('Usuario registrado exitosamente', tag: 'auth_datasource');
      return user;
    } catch (e) {
      AppLogger.e(
        'Error al registrar usuario',
        tag: 'auth_datasource',
        data: e,
      );
      rethrow;
    }
  }
}
