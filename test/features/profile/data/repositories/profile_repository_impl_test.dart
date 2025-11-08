import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dvp_prueba_tecnica_flutter/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:dvp_prueba_tecnica_flutter/features/auth/domain/entities/user.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/address.dart';
import '../../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('ProfileRepositoryImpl', () {
    late ProfileRepositoryImpl repository;
    late MockAuthLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAuthLocalDataSource();
      repository = ProfileRepositoryImpl(localDataSource: mockDataSource);
    });

    group('getUserProfile', () {
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

      test('should return User profile when data source has user', () async {
        // Arrange
        when(mockDataSource.getUser()).thenAnswer((_) async => testUser);

        // Act
        final result = await repository.getUserProfile();

        // Assert
        expect(result, testUser);
        verify(mockDataSource.getUser()).called(1);
      });

      test('should return null when data source has no user', () async {
        // Arrange
        when(mockDataSource.getUser()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getUserProfile();

        // Assert
        expect(result, null);
        verify(mockDataSource.getUser()).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(mockDataSource.getUser()).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => repository.getUserProfile(), throwsException);
      });
    });

    group('updateUserProfile', () {
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

      test('should update user profile and return updated user', () async {
        // Arrange
        when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.updateUserProfile(testUser);

        // Assert
        expect(result, testUser);
        verify(mockDataSource.saveUser(any)).called(1);
      });

      test('should call saveUser with user having updated timestamp', () async {
        // Arrange
        when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

        // Act
        await repository.updateUserProfile(testUser);

        // Assert
        final captured = verify(mockDataSource.saveUser(captureAny)).captured;
        final savedUser = captured.first as User;
        expect(savedUser.updatedAt.isAfter(testUser.updatedAt), true);
        expect(savedUser.id, testUser.id);
        expect(savedUser.name, testUser.name);
        expect(savedUser.surname, testUser.surname);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(mockDataSource.saveUser(any)).thenThrow(Exception('Save failed'));

        // Act & Assert
        expect(() => repository.updateUserProfile(testUser), throwsException);
      });
    });

    group('addAddressToProfile', () {
      final testCreatedAt = DateTime(2024, 1, 1);
      const testCountry = 'Colombia';
      const testState = 'Cundinamarca';
      const testCity = 'Bogotá';
      const testStreetAddress = 'Calle 123 #45-67';

      final testUserWithoutAddresses = User(
        id: '1',
        name: 'John',
        surname: 'Doe',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
        createdAt: testCreatedAt,
        updatedAt: testCreatedAt,
      );

      final existingAddress = Address(
        id: '1',
        country: 'Ecuador',
        state: 'Pichincha',
        city: 'Quito',
        streetAddress: 'Existing address',
        isDefault: true,
        createdAt: testCreatedAt,
      );

      final testUserWithAddresses = User(
        id: '1',
        name: 'John',
        surname: 'Doe',
        birthDate: DateTime(1990, 1, 1),
        addresses: [existingAddress],
        createdAt: testCreatedAt,
        updatedAt: testCreatedAt,
      );

      test(
        'should add address as default when user has no addresses',
        () async {
          // Arrange
          when(
            mockDataSource.getUser(),
          ).thenAnswer((_) async => testUserWithoutAddresses);
          when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

          // Act
          final result = await repository.addAddressToProfile(
            country: testCountry,
            state: testState,
            city: testCity,
            streetAddress: testStreetAddress,
          );

          // Assert
          expect(result.addresses.length, 1);
          expect(result.addresses.first.country, testCountry);
          expect(result.addresses.first.state, testState);
          expect(result.addresses.first.city, testCity);
          expect(result.addresses.first.streetAddress, testStreetAddress);
          expect(result.addresses.first.isDefault, true); // Should be default

          verify(mockDataSource.getUser()).called(1);
          verify(mockDataSource.saveUser(any)).called(1);
        },
      );

      test(
        'should add address as non-default when user has existing addresses',
        () async {
          // Arrange
          when(
            mockDataSource.getUser(),
          ).thenAnswer((_) async => testUserWithAddresses);
          when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

          // Act
          final result = await repository.addAddressToProfile(
            country: testCountry,
            state: testState,
            city: testCity,
            streetAddress: testStreetAddress,
          );

          // Assert
          expect(result.addresses.length, 2);
          final newAddress = result.addresses.firstWhere(
            (addr) => addr.country == testCountry,
          );
          expect(newAddress.isDefault, false); // Should not be default
          expect(newAddress.country, testCountry);
          expect(newAddress.state, testState);
          expect(newAddress.city, testCity);

          verify(mockDataSource.getUser()).called(1);
          verify(mockDataSource.saveUser(any)).called(1);
        },
      );

      test('should respect setAsDefault parameter when true', () async {
        // Arrange
        when(
          mockDataSource.getUser(),
        ).thenAnswer((_) async => testUserWithAddresses);
        when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.addAddressToProfile(
          country: testCountry,
          state: testState,
          city: testCity,
          setAsDefault: true,
        );

        // Assert
        final newAddress = result.addresses.firstWhere(
          (addr) => addr.country == testCountry,
        );
        expect(newAddress.isDefault, true);

        // All other addresses should be non-default
        final otherAddresses = result.addresses.where(
          (addr) => addr.country != testCountry,
        );
        expect(otherAddresses.every((addr) => !addr.isDefault), true);
      });

      test('should work without streetAddress parameter', () async {
        // Arrange
        when(
          mockDataSource.getUser(),
        ).thenAnswer((_) async => testUserWithoutAddresses);
        when(mockDataSource.saveUser(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.addAddressToProfile(
          country: testCountry,
          state: testState,
          city: testCity,
        );

        // Assert
        expect(result.addresses.length, 1);
        expect(result.addresses.first.streetAddress, null);
        expect(result.addresses.first.country, testCountry);
      });

      test('should throw exception when no user is authenticated', () async {
        // Arrange
        when(mockDataSource.getUser()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => repository.addAddressToProfile(
            country: testCountry,
            state: testState,
            city: testCity,
          ),
          throwsA(isA<Exception>()),
        );

        verifyNever(mockDataSource.saveUser(any));
      });

      test(
        'should throw exception when data source fails to get user',
        () async {
          // Arrange
          when(
            mockDataSource.getUser(),
          ).thenThrow(Exception('Get user failed'));

          // Act & Assert
          expect(
            () => repository.addAddressToProfile(
              country: testCountry,
              state: testState,
              city: testCity,
            ),
            throwsException,
          );
        },
      );

      test(
        'should throw exception when data source fails to save user',
        () async {
          // Arrange
          when(
            mockDataSource.getUser(),
          ).thenAnswer((_) async => testUserWithoutAddresses);
          when(
            mockDataSource.saveUser(any),
          ).thenThrow(Exception('Save failed'));

          // Act & Assert
          expect(
            () => repository.addAddressToProfile(
              country: testCountry,
              state: testState,
              city: testCity,
            ),
            throwsException,
          );
        },
      );
    });
  });
}
