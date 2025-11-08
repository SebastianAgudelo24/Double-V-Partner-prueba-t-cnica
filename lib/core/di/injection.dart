import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/datasources/auth_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_storage_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

// Addresses imports
import '../../features/addresses/data/datasources/location_datasource.dart';
import '../../features/addresses/data/datasources/location_datasource_impl.dart';
import '../../features/addresses/data/repositories/location_repository_impl.dart';
import '../../features/addresses/data/datasources/location_remote_service.dart';
import '../../features/addresses/domain/repositories/location_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // === CORE SERVICES ===

  // 🔐 Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // === AUTH MODULE ===

  // Storage service
  getIt.registerLazySingleton<AuthStorageService>(
    () => AuthStorageService(secureStorage: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: getIt()),
  );

  // Providers are now handled by Riverpod directly

  // === ADDRESSES MODULE ===

  // API Service
  getIt.registerLazySingleton<LocationRemoteService>(
    () => LocationRemoteService(),
  );

  // Data sources
  getIt.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(getIt<LocationRemoteService>()),
  );

  // Repositories
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(getIt()),
  );
}
