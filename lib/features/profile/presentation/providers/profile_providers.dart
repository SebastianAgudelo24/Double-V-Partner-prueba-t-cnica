import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/datasources/auth_datasource.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/use_cases/get_user_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';
import '../../domain/use_cases/add_address_to_profile_use_case.dart';
import '../../domain/use_cases/refresh_profile_use_case.dart';
import '../../data/repositories/profile_repository_impl.dart';

/// Provider para acceder al ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(localDataSource: getIt<AuthLocalDataSource>());
});

/// Providers para los Use Cases del perfil
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(ref.read(profileRepositoryProvider));
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  return UpdateUserProfileUseCase(ref.read(profileRepositoryProvider));
});

final addAddressToProfileUseCaseProvider = Provider<AddAddressToProfileUseCase>(
  (ref) {
    return AddAddressToProfileUseCase(ref.read(profileRepositoryProvider));
  },
);

final refreshProfileUseCaseProvider = Provider<RefreshProfileUseCase>((ref) {
  return RefreshProfileUseCase(ref.read(profileRepositoryProvider));
});

/// Provider principal del perfil
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(
    getUserProfileUseCase: ref.read(getUserProfileUseCaseProvider),
    updateUserProfileUseCase: ref.read(updateUserProfileUseCaseProvider),
    addAddressToProfileUseCase: ref.read(addAddressToProfileUseCaseProvider),
    refreshProfileUseCase: ref.read(refreshProfileUseCaseProvider),
  );
});

/// Notificador para el estado del perfil
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final AddAddressToProfileUseCase addAddressToProfileUseCase;
  final RefreshProfileUseCase refreshProfileUseCase;

  ProfileNotifier({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.addAddressToProfileUseCase,
    required this.refreshProfileUseCase,
  }) : super(ProfileState.initial());

  /// Inicializa y carga el perfil del usuario
  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await getUserProfileUseCase();

      state = state.copyWith(user: user, isLoading: false);

      if (user != null) {
        AppLogger.i('Perfil cargado: ${user.fullName}', tag: 'profile');
      } else {
        AppLogger.i('No hay perfil de usuario', tag: 'profile');
      }
    } catch (e) {
      AppLogger.e('Error al cargar perfil', tag: 'profile', data: e);
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Actualiza el perfil del usuario
  Future<void> updateProfile(User user) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedUser = await updateUserProfileUseCase(user);

      state = state.copyWith(user: updatedUser, isLoading: false);

      AppLogger.i(
        'Perfil actualizado: ${updatedUser.fullName}',
        tag: 'profile',
      );
    } catch (e) {
      AppLogger.e('Error al actualizar perfil', tag: 'profile', data: e);
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  /// Agrega una dirección al perfil
  Future<void> addAddress({
    required String country,
    required String state,
    required String city,
    String? streetAddress,
    bool? setAsDefault,
  }) async {
    if (this.state.user == null) {
      throw Exception('No hay usuario para agregar dirección');
    }

    try {
      final updatedUser = await addAddressToProfileUseCase(
        country: country,
        state: state,
        city: city,
        streetAddress: streetAddress,
        setAsDefault: setAsDefault,
      );

      this.state = this.state.copyWith(user: updatedUser);

      AppLogger.i(
        'Dirección agregada al perfil: ${updatedUser.addresses.last.fullAddress}',
        tag: 'profile',
      );
    } catch (e) {
      AppLogger.e(
        'Error al agregar dirección al perfil',
        tag: 'profile',
        data: e,
      );
      rethrow;
    }
  }

  /// Refresca el perfil desde el storage
  Future<void> refreshProfile() async {
    try {
      final user = await refreshProfileUseCase();
      state = state.copyWith(user: user);
      AppLogger.i('Perfil refrescado', tag: 'profile');
    } catch (e) {
      AppLogger.e('Error al refrescar perfil', tag: 'profile', data: e);
      rethrow;
    }
  }

  /// Limpia los errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Estado del perfil
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;

  const ProfileState({this.user, this.isLoading = false, this.error});

  ProfileState copyWith({User? user, bool? isLoading, String? error}) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState();
  }
}
