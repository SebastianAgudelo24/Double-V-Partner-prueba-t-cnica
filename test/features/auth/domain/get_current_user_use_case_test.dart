import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('GetCurrentUserUseCase', () {
    late GetCurrentUserUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = GetCurrentUserUseCase(mockRepository);
    });

    group('call', () {
      final testCreatedAt = DateTime(2024, 1, 1);

      final testUser = User(
        id: '1',
        name: 'John',
        surname: 'Doe',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
        createdAt: testCreatedAt,
        updatedAt: testCreatedAt,
      );

      test('should return User when user exists', () async {
        // Arrange
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, testUser);
        verify(mockRepository.getCurrentUser()).called(1);
      });

      test('should return null when no user exists', () async {
        // Arrange
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, null);
        verify(mockRepository.getCurrentUser()).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.getCurrentUser(),
        ).thenThrow(Exception('Failed to get user'));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
