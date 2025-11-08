import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/auth/domain/use_cases/logout_use_case.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('LogoutUseCase', () {
    late LogoutUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LogoutUseCase(mockRepository);
    });

    group('call', () {
      test('should call repository logout method', () async {
        // Arrange
        when(mockRepository.logout()).thenAnswer((_) async {});

        // Act
        await useCase.call();

        // Assert
        verify(mockRepository.logout()).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(mockRepository.logout()).thenThrow(Exception('Logout failed'));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
