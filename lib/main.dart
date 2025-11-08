import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/utils/app_logger.dart';
import 'core/errors/global_error_handler.dart';
import 'core/di/injection.dart';

void main() {
  // Ejecutar todo en un único zone para evitar "Zone mismatch"
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializar logger antes de otros sistemas que puedan loggear
    AppLogger.minLevel = LogLevel.debug;

    // Configuración global de captura de errores (usa el mismo zone)
    GlobalErrorHandler.init();

    // DI y dependencias
    await initializeDependencies();

    runApp(const ProviderScope(child: MyApp()));
  }, GlobalErrorHandler.onZoneError);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'PDV',
      // Configuración de localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],
      locale: const Locale('es', 'ES'), // Locale por defecto
      theme: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontFamily: 'Manrope', fontSizeFactor: 1),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
      ),
      routerConfig: router,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );

    //
  }
}
