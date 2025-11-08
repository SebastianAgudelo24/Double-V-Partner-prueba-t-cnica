import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/auth/domain/use_cases/register_user_use_case.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('RegisterUserUseCase', () {
    late RegisterUserUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = RegisterUserUseCase(mockRepository);
    });

    group('call', () {
      const testName = 'John';
      const testSurname = 'Doe';
      final testBirthDate = DateTime(1990, 1, 1);
      final testCreatedAt = DateTime(2024, 1, 1);

      final testUser = User(
        id: '1',
        name: testName,
        surname: testSurname,
        birthDate: testBirthDate,
        addresses: [],
        createdAt: testCreatedAt,
        updatedAt: testCreatedAt,
      );

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          mockRepository.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        await useCase.call(
          name: testName,
          surname: testSurname,
          birthDate: testBirthDate,
        );

        // Assert
        verify(
          mockRepository.registerUser(
            name: testName,
            surname: testSurname,
            birthDate: testBirthDate,
          ),
        ).called(1);
      });

      test('should return User when registration is successful', () async {
        // Arrange
        when(
          mockRepository.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase.call(
          name: testName,
          surname: testSurname,
          birthDate: testBirthDate,
        );

        // Assert
        expect(result, testUser);
        expect(result.name, testName);
        expect(result.surname, testSurname);
        expect(result.birthDate, testBirthDate);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenThrow(Exception('Registration failed'));

        // Act & Assert
        expect(
          () => useCase.call(
            name: testName,
            surname: testSurname,
            birthDate: testBirthDate,
          ),
          throwsException,
        );
      });
    });
  });
}
