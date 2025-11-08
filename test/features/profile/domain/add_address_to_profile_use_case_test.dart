import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/profile/domain/use_cases/add_address_to_profile_use_case.dart';
import '../../../../lib/features/auth/domain/entities/user.dart';
import '../../../../lib/features/addresses/domain/entities/address.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('AddAddressToProfileUseCase', () {
    late AddAddressToProfileUseCase useCase;
    late MockProfileRepository mockRepository;

    setUp(() {
      mockRepository = MockProfileRepository();
      useCase = AddAddressToProfileUseCase(mockRepository);
    });

    group('call', () {
      const testCountry = 'Colombia';
      const testState = 'Cundinamarca';
      const testCity = 'Bogotá';
      const testStreetAddress = 'Calle 123 #45-67';
      const setAsDefault = true;

      final testCreatedAt = DateTime(2024, 1, 1);
      final testAddress = Address(
        id: '1',
        country: testCountry,
        state: testState,
        city: testCity,
        streetAddress: testStreetAddress,
        isDefault: setAsDefault,
        createdAt: testCreatedAt,
      );

      final testUser = User(
        id: '1',
        name: 'John',
        surname: 'Doe',
        birthDate: DateTime(1990, 1, 1),
        addresses: [testAddress],
        createdAt: testCreatedAt,
        updatedAt: testCreatedAt,
      );

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          mockRepository.addAddressToProfile(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
            streetAddress: anyNamed('streetAddress'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        await useCase.call(
          country: testCountry,
          state: testState,
          city: testCity,
          streetAddress: testStreetAddress,
          setAsDefault: setAsDefault,
        );

        // Assert
        verify(
          mockRepository.addAddressToProfile(
            country: testCountry,
            state: testState,
            city: testCity,
            streetAddress: testStreetAddress,
            setAsDefault: setAsDefault,
          ),
        ).called(1);
      });

      test('should return User with added address when successful', () async {
        // Arrange
        when(
          mockRepository.addAddressToProfile(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
            streetAddress: anyNamed('streetAddress'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase.call(
          country: testCountry,
          state: testState,
          city: testCity,
          streetAddress: testStreetAddress,
          setAsDefault: setAsDefault,
        );

        // Assert
        expect(result, testUser);
        expect(result.addresses.length, 1);
        expect(result.addresses.first.country, testCountry);
        expect(result.addresses.first.state, testState);
        expect(result.addresses.first.city, testCity);
        expect(result.addresses.first.streetAddress, testStreetAddress);
        expect(result.addresses.first.isDefault, setAsDefault);
      });

      test('should work without optional parameters', () async {
        // Arrange
        final userWithoutStreetAddress = User(
          id: '1',
          name: 'John',
          surname: 'Doe',
          birthDate: DateTime(1990, 1, 1),
          addresses: [
            Address(
              id: '1',
              country: testCountry,
              state: testState,
              city: testCity,
              streetAddress: null,
              isDefault: false,
              createdAt: testCreatedAt,
            ),
          ],
          createdAt: testCreatedAt,
          updatedAt: testCreatedAt,
        );

        when(
          mockRepository.addAddressToProfile(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
          ),
        ).thenAnswer((_) async => userWithoutStreetAddress);

        // Act
        final result = await useCase.call(
          country: testCountry,
          state: testState,
          city: testCity,
        );

        // Assert
        expect(result, userWithoutStreetAddress);
        verify(
          mockRepository.addAddressToProfile(
            country: testCountry,
            state: testState,
            city: testCity,
          ),
        ).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.addAddressToProfile(
            country: anyNamed('country'),
            state: anyNamed('state'),
            city: anyNamed('city'),
            streetAddress: anyNamed('streetAddress'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenThrow(Exception('Failed to add address'));

        // Act & Assert
        expect(
          () => useCase.call(
            country: testCountry,
            state: testState,
            city: testCity,
            streetAddress: testStreetAddress,
            setAsDefault: setAsDefault,
          ),
          throwsException,
        );
      });
    });
  });
}
