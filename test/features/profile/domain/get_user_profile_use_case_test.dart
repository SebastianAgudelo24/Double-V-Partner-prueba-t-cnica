import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/profile/domain/use_cases/get_user_profile_use_case.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('GetUserProfileUseCase', () {
    late GetUserProfileUseCase useCase;
    late MockProfileRepository mockRepository;

    setUp(() {
      mockRepository = MockProfileRepository();
      useCase = GetUserProfileUseCase(mockRepository);
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

      test('should return User profile when user exists', () async {
        // Arrange
        when(mockRepository.getUserProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, testUser);
        verify(mockRepository.getUserProfile()).called(1);
      });

      test('should return null when no user profile exists', () async {
        // Arrange
        when(mockRepository.getUserProfile()).thenAnswer((_) async => null);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, null);
        verify(mockRepository.getUserProfile()).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.getUserProfile(),
        ).thenThrow(Exception('Failed to get user profile'));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
