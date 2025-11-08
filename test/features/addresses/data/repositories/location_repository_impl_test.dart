import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/data/repositories/location_repository_impl.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/country.dart';
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/state.dart'
    as entities;
import 'package:dvp_prueba_tecnica_flutter/features/addresses/domain/entities/city.dart';
import '../../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('LocationRepositoryImpl', () {
    late LocationRepositoryImpl repository;
    late MockLocationDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockLocationDataSource();
      repository = LocationRepositoryImpl(mockDataSource);
    });

    group('getCountries', () {
      final testCountries = [
        const Country(code: 'CO', name: 'Colombia', flag: '🇨🇴'),
        const Country(code: 'US', name: 'United States', flag: '🇺🇸'),
        const Country(code: 'MX', name: 'Mexico', flag: '🇲🇽'),
      ];

      test(
        'should return countries from data source when successful',
        () async {
          // Arrange
          when(
            mockDataSource.fetchCountries(),
          ).thenAnswer((_) async => testCountries);

          // Act
          final result = await repository.getCountries();

          // Assert
          expect(result, testCountries);
          expect(result.length, 3);
          verify(mockDataSource.fetchCountries()).called(1);
        },
      );

      test('should rethrow exception when data source fails', () async {
        // Arrange
        final exception = Exception('Network error');
        when(mockDataSource.fetchCountries()).thenThrow(exception);

        // Act & Assert
        expect(() => repository.getCountries(), throwsA(exception));
      });

      test('should return empty list when data source returns empty', () async {
        // Arrange
        when(mockDataSource.fetchCountries()).thenAnswer((_) async => []);

        // Act
        final result = await repository.getCountries();

        // Assert
        expect(result, []);
        expect(result.length, 0);
        verify(mockDataSource.fetchCountries()).called(1);
      });
    });

    group('getStatesByCountry', () {
      const testCountryCode = 'CO';
      final testStates = [
        const entities.AddressState(
          code: 'CUN',
          name: 'Cundinamarca',
          countryCode: testCountryCode,
        ),
        const entities.AddressState(
          code: 'ANT',
          name: 'Antioquia',
          countryCode: testCountryCode,
        ),
      ];

      test('should return states from data source when successful', () async {
        // Arrange
        when(
          mockDataSource.fetchStatesByCountry(testCountryCode),
        ).thenAnswer((_) async => testStates);

        // Act
        final result = await repository.getStatesByCountry(testCountryCode);

        // Assert
        expect(result, testStates);
        expect(result.length, 2);
        verify(mockDataSource.fetchStatesByCountry(testCountryCode)).called(1);
      });

      test('should throw ArgumentError when country code is empty', () async {
        // Act & Assert
        expect(() => repository.getStatesByCountry(''), throwsArgumentError);

        // Should not call data source
        verifyNever(mockDataSource.fetchStatesByCountry(any));
      });

      test('should rethrow exception when data source fails', () async {
        // Arrange
        final exception = Exception('API error');
        when(
          mockDataSource.fetchStatesByCountry(testCountryCode),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.getStatesByCountry(testCountryCode),
          throwsA(exception),
        );
      });

      test('should return empty list when no states found', () async {
        // Arrange
        when(
          mockDataSource.fetchStatesByCountry(testCountryCode),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getStatesByCountry(testCountryCode);

        // Assert
        expect(result, []);
        verify(mockDataSource.fetchStatesByCountry(testCountryCode)).called(1);
      });
    });

    group('getCitiesByState', () {
      const testCountryCode = 'CO';
      const testStateCode = 'CUN';
      final testCities = [
        const City(
          name: 'Bogotá',
          stateCode: testStateCode,
          countryCode: testCountryCode,
        ),
        const City(
          name: 'Soacha',
          stateCode: testStateCode,
          countryCode: testCountryCode,
        ),
      ];

      test('should return cities from data source when successful', () async {
        // Arrange
        when(
          mockDataSource.fetchCitiesByState(testCountryCode, testStateCode),
        ).thenAnswer((_) async => testCities);

        // Act
        final result = await repository.getCitiesByState(
          testCountryCode,
          testStateCode,
        );

        // Assert
        expect(result, testCities);
        expect(result.length, 2);
        verify(
          mockDataSource.fetchCitiesByState(testCountryCode, testStateCode),
        ).called(1);
      });

      test('should throw ArgumentError when country code is empty', () async {
        // Act & Assert
        expect(
          () => repository.getCitiesByState('', testStateCode),
          throwsArgumentError,
        );

        verifyNever(mockDataSource.fetchCitiesByState(any, any));
      });

      test('should throw ArgumentError when state code is empty', () async {
        // Act & Assert
        expect(
          () => repository.getCitiesByState(testCountryCode, ''),
          throwsArgumentError,
        );

        verifyNever(mockDataSource.fetchCitiesByState(any, any));
      });

      test('should rethrow exception when data source fails', () async {
        // Arrange
        final exception = Exception('API timeout');
        when(
          mockDataSource.fetchCitiesByState(testCountryCode, testStateCode),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.getCitiesByState(testCountryCode, testStateCode),
          throwsA(exception),
        );
      });

      test('should return empty list when no cities found', () async {
        // Arrange
        when(
          mockDataSource.fetchCitiesByState(testCountryCode, testStateCode),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getCitiesByState(
          testCountryCode,
          testStateCode,
        );

        // Assert
        expect(result, []);
        verify(
          mockDataSource.fetchCitiesByState(testCountryCode, testStateCode),
        ).called(1);
      });

      test('should handle different parameter combinations', () async {
        // Arrange
        const usCountryCode = 'US';
        const caStateCode = 'CA';
        final usCities = [
          const City(
            name: 'Los Angeles',
            stateCode: caStateCode,
            countryCode: usCountryCode,
          ),
        ];

        when(
          mockDataSource.fetchCitiesByState(usCountryCode, caStateCode),
        ).thenAnswer((_) async => usCities);

        // Act
        final result = await repository.getCitiesByState(
          usCountryCode,
          caStateCode,
        );

        // Assert
        expect(result, usCities);
        verify(
          mockDataSource.fetchCitiesByState(usCountryCode, caStateCode),
        ).called(1);
      });
    });
  });
}
