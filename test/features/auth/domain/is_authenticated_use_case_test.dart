import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/auth/domain/use_cases/is_authenticated_use_case.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('IsAuthenticatedUseCase', () {
    late IsAuthenticatedUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = IsAuthenticatedUseCase(mockRepository);
    });

    group('call', () {
      test('should return true when user is authenticated', () async {
        // Arrange
        when(mockRepository.isAuthenticated()).thenAnswer((_) async => true);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, true);
        verify(mockRepository.isAuthenticated()).called(1);
      });

      test('should return false when user is not authenticated', () async {
        // Arrange
        when(mockRepository.isAuthenticated()).thenAnswer((_) async => false);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, false);
        verify(mockRepository.isAuthenticated()).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.isAuthenticated(),
        ).thenThrow(Exception('Authentication check failed'));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
