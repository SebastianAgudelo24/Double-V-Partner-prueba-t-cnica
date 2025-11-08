import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/register_user_use_case.dart';
import '../../domain/use_cases/get_current_user_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/is_authenticated_use_case.dart';
import '../../domain/use_cases/update_user_use_case.dart';

/// Provider para acceder al AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

/// Providers para los Use Cases de autenticación
final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  return IsAuthenticatedUseCase(ref.read(authRepositoryProvider));
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  return UpdateUserUseCase(ref.read(authRepositoryProvider));
});

/// Provider principal de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    registerUserUseCase: ref.read(registerUserUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    isAuthenticatedUseCase: ref.read(isAuthenticatedUseCaseProvider),
    updateUserUseCase: ref.read(updateUserUseCaseProvider),
  );
});

/// Notificador para el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterUserUseCase registerUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AuthNotifier({
    required this.registerUserUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.isAuthenticatedUseCase,
    required this.updateUserUseCase,
  }) : super(AuthState.initial());

  Future<void> initializeAuth() async {
    // Si ya está en loading, esperar a que termine
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final isAuthenticated = await isAuthenticatedUseCase();

      if (isAuthenticated) {
        final user = await getCurrentUserUseCase();

        state = state.copyWith(
          user: user,
          isAuthenticated: user != null,
          isLoading: false,
        );
        AppLogger.i('Usuario autenticado: ${user?.fullName}', tag: 'auth');
      } else {
        state = state.copyWith(
          user: null,
          isAuthenticated: false,
          isLoading: false,
        );
        AppLogger.i('No hay usuario autenticado', tag: 'auth');
      }
    } catch (e) {
      AppLogger.e('Error al inicializar auth', tag: 'auth', data: e);
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<void> registerUser({
    required String name,
    required String surname,
    required DateTime birthDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await registerUserUseCase(
        name: name,
        surname: surname,
        birthDate: birthDate,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      state = AuthState.initial();
    } catch (e) {
      AppLogger.e('Error al cerrar sesión', tag: 'auth', data: e);
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Estado de autenticación
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  factory AuthState.initial() {
    return const AuthState();
  }
}
