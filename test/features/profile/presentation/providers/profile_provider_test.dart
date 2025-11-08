import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dvp_prueba_tecnica_flutter/features/profile/presentation/providers/profile_providers.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/entities/user.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/address.dart';
import '../../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('ProfileNotifier', () {
    late ProviderContainer container;
    late MockGetUserProfileUseCase mockGetUserProfileUseCase;
    late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
    late MockAddAddressToProfileUseCase mockAddAddressToProfileUseCase;
    late MockRefreshProfileUseCase mockRefreshProfileUseCase;

    setUp(() {
      mockGetUserProfileUseCase = MockGetUserProfileUseCase();
      mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
      mockAddAddressToProfileUseCase = MockAddAddressToProfileUseCase();
      mockRefreshProfileUseCase = MockRefreshProfileUseCase();

      container = ProviderContainer(
        overrides: [
          getUserProfileUseCaseProvider.overrideWithValue(
            mockGetUserProfileUseCase,
          ),
          updateUserProfileUseCaseProvider.overrideWithValue(
            mockUpdateUserProfileUseCase,
          ),
          addAddressToProfileUseCaseProvider.overrideWithValue(
            mockAddAddressToProfileUseCase,
          ),
          refreshProfileUseCaseProvider.overrideWithValue(
            mockRefreshProfileUseCase,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('loadProfile', () {
      test('debe cargar perfil exitosamente y actualizar el estado', () async {
        // Arrange
        final user = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(mockGetUserProfileUseCase.call()).thenAnswer((_) async => user);

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.loadProfile();

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, equals(user));
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });

      test('debe manejar perfil null', () async {
        // Arrange
        when(mockGetUserProfileUseCase.call()).thenAnswer((_) async => null);

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.loadProfile();

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });

      test('debe manejar error al cargar perfil', () async {
        // Arrange
        const errorMessage = 'Error loading profile';
        when(
          mockGetUserProfileUseCase.call(),
        ).thenThrow(Exception(errorMessage));

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.loadProfile();

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, contains(errorMessage));
      });

      test('debe mostrar loading durante la carga', () async {
        // Arrange
        when(mockGetUserProfileUseCase.call()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return null;
        });

        // Act
        final notifier = container.read(profileProvider.notifier);
        final future = notifier.loadProfile();

        // Assert - durante el loading
        await Future.delayed(const Duration(milliseconds: 50));
        final loadingState = container.read(profileProvider);
        expect(loadingState.isLoading, isTrue);

        // Esperar a que termine
        await future;
        final finalState = container.read(profileProvider);
        expect(finalState.isLoading, isFalse);
      });
    });

    group('updateProfile', () {
      test('debe actualizar perfil exitosamente', () async {
        // Arrange
        final user = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final updatedUser = User(
          id: '1',
          name: 'Juan Carlos',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: user.createdAt,
          updatedAt: DateTime.now(),
        );

        when(
          mockUpdateUserProfileUseCase.call(any),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.updateProfile(user);

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, equals(updatedUser));
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);

        verify(mockUpdateUserProfileUseCase.call(user)).called(1);
      });

      test('debe manejar error al actualizar perfil', () async {
        // Arrange
        final user = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        const errorMessage = 'Update failed';
        when(
          mockUpdateUserProfileUseCase.call(any),
        ).thenThrow(Exception(errorMessage));

        // Act & Assert
        final notifier = container.read(profileProvider.notifier);
        expect(() => notifier.updateProfile(user), throwsException);

        final state = container.read(profileProvider);
        expect(state.isLoading, isFalse);
        expect(state.error, contains(errorMessage));
      });
    });

    group('addAddress', () {
      test('debe agregar dirección exitosamente', () async {
        // Arrange
        final address = Address(
          id: '1',
          country: 'Colombia',
          state: 'Antioquia',
          city: 'Medellín',
          streetAddress: 'Calle 123 #45-67',
          isDefault: false,
          createdAt: DateTime.now(),
        );

        final initialUser = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final updatedUser = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: [address],
          createdAt: initialUser.createdAt,
          updatedAt: DateTime.now(),
        );

        // Primero configurar el estado inicial con un usuario
        container.read(profileProvider.notifier).state = container
            .read(profileProvider.notifier)
            .state
            .copyWith(user: initialUser);

        when(
          mockAddAddressToProfileUseCase.call(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
            streetAddress: anyNamed('streetAddress'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => updatedUser);

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.addAddress(
          country: 'Colombia',
          state: 'Antioquia',
          city: 'Medellín',
          streetAddress: 'Calle 123 #45-67',
          setAsDefault: false,
        );

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, equals(updatedUser));
        expect(state.user?.addresses.length, equals(1));
      });

      test('debe fallar si no hay usuario', () async {
        // Arrange - no establecer usuario en el estado

        // Act & Assert
        final notifier = container.read(profileProvider.notifier);
        expect(
          () => notifier.addAddress(
            country: 'Colombia',
            state: 'Antioquia',
            city: 'Medellín',
          ),
          throwsException,
        );
      });

      test('debe manejar error al agregar dirección', () async {
        // Arrange
        final user = User(
          id: '1',
          name: 'Juan',
          surname: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        container.read(profileProvider.notifier).state = container
            .read(profileProvider.notifier)
            .state
            .copyWith(user: user);

        when(
          mockAddAddressToProfileUseCase.call(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
            streetAddress: anyNamed('streetAddress'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenThrow(Exception('Add address failed'));

        // Act & Assert
        final notifier = container.read(profileProvider.notifier);
        expect(
          () => notifier.addAddress(
            country: 'Colombia',
            state: 'Antioquia',
            city: 'Medellín',
          ),
          throwsException,
        );
      });
    });

    group('refreshProfile', () {
      test('debe refrescar perfil exitosamente', () async {
        // Arrange
        final refreshedUser = User(
          id: '1',
          name: 'Juan Carlos',
          surname: 'Pérez García',
          birthDate: DateTime(1990, 1, 1),
          addresses: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(
          mockRefreshProfileUseCase.call(),
        ).thenAnswer((_) async => refreshedUser);

        // Act
        final notifier = container.read(profileProvider.notifier);
        await notifier.refreshProfile();

        // Assert
        final state = container.read(profileProvider);
        expect(state.user, equals(refreshedUser));

        verify(mockRefreshProfileUseCase.call()).called(1);
      });

      test('debe manejar error al refrescar perfil', () async {
        // Arrange
        when(
          mockRefreshProfileUseCase.call(),
        ).thenThrow(Exception('Refresh failed'));

        // Act & Assert
        final notifier = container.read(profileProvider.notifier);
        expect(() => notifier.refreshProfile(), throwsException);
      });
    });

    group('clearError', () {
      test('debe limpiar mensaje de error', () {
        // Arrange - establecer un estado con error
        final notifier = container.read(profileProvider.notifier);
        notifier.state = notifier.state.copyWith(error: 'Test error');

        // Verificar que hay error
        expect(container.read(profileProvider).error, equals('Test error'));

        // Act
        notifier.clearError();

        // Assert
        final state = container.read(profileProvider);
        expect(state.error, isNull);
      });
    });

    group('estado inicial', () {
      test('debe tener estado inicial correcto', () {
        // Assert
        final state = container.read(profileProvider);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });
    });
  });
}
