import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/profile/domain/use_cases/refresh_profile_use_case.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('RefreshProfileUseCase', () {
    late RefreshProfileUseCase useCase;
    late MockProfileRepository mockRepository;

    setUp(() {
      mockRepository = MockProfileRepository();
      useCase = RefreshProfileUseCase(mockRepository);
    });

    group('call', () {
      final testCreatedAt = DateTime(2024, 1, 1);
      final testUpdatedAt = DateTime(2024, 1, 2); // Different from created

      final testUser = User(
        id: '1',
        name: 'John',
        surname: 'Doe',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
        createdAt: testCreatedAt,
        updatedAt: testUpdatedAt, // Updated timestamp
      );

      test('should return refreshed User profile when successful', () async {
        // Arrange
        when(mockRepository.getUserProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, testUser);
        verify(mockRepository.getUserProfile()).called(1);
      });

      test(
        'should return null when no user profile exists after refresh',
        () async {
          // Arrange
          when(mockRepository.getUserProfile()).thenAnswer((_) async => null);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, null);
          verify(mockRepository.getUserProfile()).called(1);
        },
      );

      test('should handle multiple refresh calls independently', () async {
        // Arrange
        when(mockRepository.getUserProfile()).thenAnswer((_) async => testUser);

        // Act
        final result1 = await useCase.call();
        final result2 = await useCase.call();

        // Assert
        expect(result1, testUser);
        expect(result2, testUser);
        verify(mockRepository.getUserProfile()).called(2);
      });

      test(
        'should throw exception when repository fails during refresh',
        () async {
          // Arrange
          when(
            mockRepository.getUserProfile(),
          ).thenThrow(Exception('Network error during refresh'));

          // Act & Assert
          expect(() => useCase.call(), throwsException);
        },
      );

      test(
        'should handle repository returning different user data on refresh',
        () async {
          // Arrange
          final updatedUser = User(
            id: '1',
            name: 'John Updated',
            surname: 'Doe Updated',
            birthDate: DateTime(1990, 1, 1),
            addresses: [],
            createdAt: testCreatedAt,
            updatedAt: DateTime(2024, 1, 3), // Even newer timestamp
          );

          when(
            mockRepository.getUserProfile(),
          ).thenAnswer((_) async => updatedUser);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, updatedUser);
          expect(result?.name, 'John Updated');
          expect(result?.surname, 'Doe Updated');
          verify(mockRepository.getUserProfile()).called(1);
        },
      );
    });
  });
}
