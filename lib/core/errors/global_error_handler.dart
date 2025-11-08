import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../utils/app_logger.dart';

/// Configura capturas globales de errores para registrar y (futuro) reportar.
/// Centraliza: FlutterError, errores de PlatformDispatcher e in-scope runZonedGuarded.
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static bool _initialized = false;

  /// Debe llamarse lo antes posible en `main()` tras `WidgetsFlutterBinding.ensureInitialized()`
  static void init() {
    if (_initialized) return;
    _initialized = true;

    // Errores sin capturar en el framework Flutter (ciclo de render / build)
    FlutterError.onError = (details) {
      AppLogger.e('FlutterError', tag: 'fatal', data: {
        'exception': details.exceptionAsString(),
        'stack': details.stack?.toString().split('\n').first,
      });
      // Mantener el comportamiento por defecto (imprime en consola) si se requiere:
      FlutterError.presentError(details);
    };

    // Errores asíncronos fuera del árbol de widgets (plataforma / isolates principales)
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.e('PlatformError', tag: 'fatal', data: {
        'e': error.toString(),
        'st': stack.toString().split('\n').first,
      });
      return true; // indicar que fue gestionado
    };
  }

  /// Handler para `runZonedGuarded`.
  static void onZoneError(Object error, StackTrace stack) {
    AppLogger.e('ZoneError', tag: 'fatal', data: {
      'e': error.toString(),
      'st': stack.toString().split('\n').first,
    });
  }
}
