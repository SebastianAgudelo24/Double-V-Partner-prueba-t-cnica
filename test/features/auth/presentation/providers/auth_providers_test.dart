import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/presentation/providers/auth_providers.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/entities/user.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/address.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/use_cases/register_user_use_case.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/use_cases/is_authenticated_use_case.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/use_cases/update_user_use_case.dart';
import '../../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;
    late MockRegisterUserUseCase mockRegisterUserUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockIsAuthenticatedUseCase mockIsAuthenticatedUseCase;
    late MockUpdateUserUseCase mockUpdateUserUseCase;

    setUp(() {
      mockRegisterUserUseCase = MockRegisterUserUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockIsAuthenticatedUseCase = MockIsAuthenticatedUseCase();
      mockUpdateUserUseCase = MockUpdateUserUseCase();

      container = ProviderContainer(
        overrides: [
          registerUserUseCaseProvider.overrideWithValue(
            mockRegisterUserUseCase,
          ),
          getCurrentUserUseCaseProvider.overrideWithValue(
            mockGetCurrentUserUseCase,
          ),
          logoutUseCaseProvider.overrideWithValue(mockLogoutUseCase),
          isAuthenticatedUseCaseProvider.overrideWithValue(
            mockIsAuthenticatedUseCase,
          ),
          updateUserUseCaseProvider.overrideWithValue(mockUpdateUserUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('registerUser', () {
      test(
        'debe registrar usuario exitosamente y actualizar el estado',
        () async {
          // Arrange
          const name = 'Juan';
          const surname = 'Pérez';
          final birthDate = DateTime(1990, 1, 1);
          final user = User(
            id: '1',
            name: name,
            surname: surname,
            birthDate: birthDate,
            addresses: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          when(
            mockRegisterUserUseCase.call(
              name: anyNamed('name'),
              surname: anyNamed('surname'),
              birthDate: anyNamed('birthDate'),
            ),
          ).thenAnswer((_) async => user);

          // Act
          final notifier = container.read(authProvider.notifier);
          await notifier.registerUser(
            name: name,
            surname: surname,
            birthDate: birthDate,
          );

          // Assert
          final state = container.read(authProvider);
          expect(state.isAuthenticated, isTrue);
          expect(state.user, equals(user));
          expect(state.isLoading, isFalse);
          expect(state.error, isNull);
        },
      );

      test(
        'debe manejar error de registro y actualizar el estado con error',
        () async {
          // Arrange
          const name = 'Juan';
          const surname = 'Pérez';
          final birthDate = DateTime(1990, 1, 1);
          const errorMessage = 'Error de registro';

          when(
            mockRegisterUserUseCase.call(
              name: anyNamed('name'),
              surname: anyNamed('surname'),
              birthDate: anyNamed('birthDate'),
            ),
          ).thenThrow(Exception(errorMessage));

          // Act & Assert
          final notifier = container.read(authProvider.notifier);

          expect(
            () => notifier.registerUser(
              name: name,
              surname: surname,
              birthDate: birthDate,
            ),
            throwsException,
          );

          final state = container.read(authProvider);
          expect(state.isAuthenticated, isFalse);
          expect(state.user, isNull);
          expect(state.isLoading, isFalse);
          expect(state.error, contains(errorMessage));
        },
      );
    });

    group('initializeAuth', () {
      test(
        'debe inicializar auth exitosamente cuando usuario está autenticado',
        () async {
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

          when(mockIsAuthenticatedUseCase.call()).thenAnswer((_) async => true);
          when(mockGetCurrentUserUseCase.call()).thenAnswer((_) async => user);

          // Act
          final notifier = container.read(authProvider.notifier);
          await notifier.initializeAuth();

          // Assert
          final state = container.read(authProvider);
          expect(state.isAuthenticated, isTrue);
          expect(state.user, equals(user));
          expect(state.isLoading, isFalse);
          expect(state.error, isNull);
        },
      );

      test('debe manejar usuario no autenticado', () async {
        // Arrange
        when(mockIsAuthenticatedUseCase.call()).thenAnswer((_) async => false);

        // Act
        final notifier = container.read(authProvider.notifier);
        await notifier.initializeAuth();

        // Assert
        final state = container.read(authProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);

        verifyNever(mockGetCurrentUserUseCase.call());
      });

      test('debe manejar error al verificar estado de autenticación', () async {
        // Arrange
        const errorMessage = 'Auth check failed';
        when(
          mockIsAuthenticatedUseCase.call(),
        ).thenThrow(Exception(errorMessage));

        // Act
        final notifier = container.read(authProvider.notifier);
        await notifier.initializeAuth();

        // Assert
        final state = container.read(authProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.error, contains(errorMessage));
        expect(state.isLoading, isFalse);
      });
    });

    group('logout', () {
      test('debe cerrar sesión exitosamente y limpiar el estado', () async {
        // Arrange
        when(mockLogoutUseCase.call()).thenAnswer((_) async {});

        // Act
        final notifier = container.read(authProvider.notifier);
        await notifier.logout();

        // Assert
        final state = container.read(authProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);

        verify(mockLogoutUseCase.call()).called(1);
      });

      test('debe manejar error durante logout', () async {
        // Arrange
        const errorMessage = 'Logout failed';
        when(mockLogoutUseCase.call()).thenThrow(Exception(errorMessage));

        // Act & Assert
        final notifier = container.read(authProvider.notifier);
        expect(() => notifier.logout(), throwsException);
      });
    });

    group('clearError', () {
      test('debe limpiar mensaje de error', () {
        // Arrange - directamente usar el notifier para simular un estado con error
        final notifier = container.read(authProvider.notifier);

        // Acceder directamente al state y modificarlo para simular un error
        // Esto es más directo que intentar generar un error real
        const errorMessage = 'Test error message';

        // Simulamos manualmente un estado con error
        // En un escenario real, clearError se llamaría después de una operación fallida
        notifier.state = notifier.state.copyWith(error: errorMessage);

        // Verificar que hay error
        expect(container.read(authProvider).error, equals(errorMessage));

        // Act
        notifier.clearError();

        // Assert - el error debe haberse limpiado
        final state = container.read(authProvider);
        expect(state.error, isNull);
      });
    });

    group('estado inicial', () {
      test('debe tener estado inicial correcto', () {
        // Assert
        final state = container.read(authProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);
        expect(state.isLoading, isFalse);
        expect(state.error, isNull);
      });
    });
  });
}
