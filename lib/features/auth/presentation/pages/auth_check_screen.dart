import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_providers.dart';

class AuthCheckScreen extends ConsumerStatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  ConsumerState<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> {
  bool _hasNavigated = false;
  bool _initializationStarted = false;

  @override
  void initState() {
    super.initState();
    // Inicializar auth de inmediato
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_initializationStarted) {
        _initializationStarted = true;
        await _checkAuthStatus();
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      await ref.read(authProvider.notifier).initializeAuth();
    } catch (e) {
      // Error silencioso, se maneja en el provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          // Mostrar loading mientras se verifica la autenticación O si no se ha inicializado
          if (authState.isLoading || (!_initializationStarted)) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Verificando sesión...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Si hay error, mostrar pantalla de error con opción de reintentar
          if (authState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al verificar sesión',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authState.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _checkAuthStatus,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Solo navegar cuando la inicialización esté completa y no esté cargando
          if (_initializationStarted && !authState.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateBasedOnAuthState(authState);
            });
          }

          // Pantalla de loading mientras se decide la navegación
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _navigateBasedOnAuthState(AuthState authState) {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final user = authState.user;

    // Si no está autenticado, ir a registro
    if (!authState.isAuthenticated || user == null) {
      context.go(AppRoutes.userRegistrationPath);
      return;
    }

    // Si está autenticado pero no tiene direcciones, ir a agregar dirección
    if (user.addresses.isEmpty) {
      context.go(AppRoutes.addAddressPath);
      return;
    }

    // Si está completamente autenticado con direcciones, ir al perfil
    context.go(AppRoutes.userProfilePath);
  }
}
