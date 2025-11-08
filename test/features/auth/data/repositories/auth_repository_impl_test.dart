import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/entities/user.dart';
import '../../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAuthLocalDataSource();
      repository = AuthRepositoryImpl(localDataSource: mockDataSource);
    });

    group('getCurrentUser', () {
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

      test('should return User when data source has user', () async {
        // Arrange
        when(mockDataSource.getUser()).thenAnswer((_) async => testUser);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, testUser);
        verify(mockDataSource.getUser()).called(1);
      });

      test('should return null when data source has no user', () async {
        // Arrange
        when(mockDataSource.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, null);
        verify(mockDataSource.getUser()).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(mockDataSource.getUser()).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => repository.getCurrentUser(), throwsException);
      });
    });

    group('logout', () {
      test('should call clearUserData on data source', () async {
        // Arrange
        when(mockDataSource.clearUserData()).thenAnswer((_) async {});

        // Act
        await repository.logout();

        // Assert
        verify(mockDataSource.clearUserData()).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(
          mockDataSource.clearUserData(),
        ).thenThrow(Exception('Clear data failed'));

        // Act & Assert
        expect(() => repository.logout(), throwsException);
      });
    });

    group('isAuthenticated', () {
      test('should return true when data source has user', () async {
        // Arrange
        when(mockDataSource.hasUser()).thenAnswer((_) async => true);

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, true);
        verify(mockDataSource.hasUser()).called(1);
      });

      test('should return false when data source has no user', () async {
        // Arrange
        when(mockDataSource.hasUser()).thenAnswer((_) async => false);

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        expect(result, false);
        verify(mockDataSource.hasUser()).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(
          mockDataSource.hasUser(),
        ).thenThrow(Exception('Check user failed'));

        // Act & Assert
        expect(() => repository.isAuthenticated(), throwsException);
      });
    });

    group('registerUser', () {
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

      test('should register user successfully and return User', () async {
        // Arrange
        when(
          mockDataSource.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await repository.registerUser(
          name: testName,
          surname: testSurname,
          birthDate: testBirthDate,
        );

        // Assert
        expect(result, testUser);
        verify(
          mockDataSource.registerUser(
            name: testName,
            surname: testSurname,
            birthDate: testBirthDate,
          ),
        ).called(1);
      });

      test('should pass correct parameters to data source', () async {
        // Arrange
        when(
          mockDataSource.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        await repository.registerUser(
          name: testName,
          surname: testSurname,
          birthDate: testBirthDate,
        );

        // Assert
        verify(
          mockDataSource.registerUser(
            name: testName,
            surname: testSurname,
            birthDate: testBirthDate,
          ),
        ).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(
          mockDataSource.registerUser(
            name: anyNamed('name'),
            surname: anyNamed('surname'),
            birthDate: anyNamed('birthDate'),
          ),
        ).thenThrow(Exception('Registration failed'));

        // Act & Assert
        expect(
          () => repository.registerUser(
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
