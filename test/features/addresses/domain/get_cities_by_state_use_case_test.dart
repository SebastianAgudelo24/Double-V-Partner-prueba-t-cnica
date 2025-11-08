import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/addresses/domain/usecases/get_cities_by_state_use_case.dart';
import '../../../../lib/features/addresses/domain/entities/city.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('GetCitiesByStateUseCase', () {
    late GetCitiesByStateUseCase useCase;
    late MockLocationRepository mockRepository;

    setUp(() {
      mockRepository = MockLocationRepository();
      useCase = GetCitiesByStateUseCase(mockRepository);
    });

    group('call', () {
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
        const City(
          name: 'Chía',
          stateCode: testStateCode,
          countryCode: testCountryCode,
        ),
      ];

      test(
        'should return list of cities for given state from repository',
        () async {
          // Arrange
          when(
            mockRepository.getCitiesByState(testCountryCode, testStateCode),
          ).thenAnswer((_) async => testCities);

          // Act
          final result = await useCase.call(testCountryCode, testStateCode);

          // Assert
          expect(result, testCities);
          expect(result.length, 3);
          expect(result[0].name, 'Bogotá');
          expect(result[1].name, 'Soacha');
          expect(result[2].name, 'Chía');
          verify(
            mockRepository.getCitiesByState(testCountryCode, testStateCode),
          ).called(1);
        },
      );

      test(
        'should return empty list when no cities available for state',
        () async {
          // Arrange
          when(
            mockRepository.getCitiesByState(testCountryCode, testStateCode),
          ).thenAnswer((_) async => []);

          // Act
          final result = await useCase.call(testCountryCode, testStateCode);

          // Assert
          expect(result, []);
          expect(result.length, 0);
          verify(
            mockRepository.getCitiesByState(testCountryCode, testStateCode),
          ).called(1);
        },
      );

      test(
        'should call repository with correct country and state codes',
        () async {
          // Arrange
          const differentCountryCode = 'US';
          const differentStateCode = 'CA';
          when(
            mockRepository.getCitiesByState(
              differentCountryCode,
              differentStateCode,
            ),
          ).thenAnswer((_) async => []);

          // Act
          await useCase.call(differentCountryCode, differentStateCode);

          // Assert
          verify(
            mockRepository.getCitiesByState(
              differentCountryCode,
              differentStateCode,
            ),
          ).called(1);
          verifyNever(
            mockRepository.getCitiesByState(testCountryCode, testStateCode),
          );
        },
      );

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.getCitiesByState(testCountryCode, testStateCode),
        ).thenThrow(Exception('Failed to get cities'));

        // Act & Assert
        expect(
          () => useCase.call(testCountryCode, testStateCode),
          throwsException,
        );
      });

      test('should handle different states in same country', () async {
        // Arrange
        const anotherStateCode = 'ANT';
        final antioquiaCities = [
          const City(
            name: 'Medellín',
            stateCode: anotherStateCode,
            countryCode: testCountryCode,
          ),
          const City(
            name: 'Bello',
            stateCode: anotherStateCode,
            countryCode: testCountryCode,
          ),
        ];

        when(
          mockRepository.getCitiesByState(testCountryCode, testStateCode),
        ).thenAnswer((_) async => testCities);
        when(
          mockRepository.getCitiesByState(testCountryCode, anotherStateCode),
        ).thenAnswer((_) async => antioquiaCities);

        // Act
        final cundinamarcaCities = await useCase.call(
          testCountryCode,
          testStateCode,
        );
        final antioquiaCitiesResult = await useCase.call(
          testCountryCode,
          anotherStateCode,
        );

        // Assert
        expect(cundinamarcaCities.length, 3);
        expect(antioquiaCitiesResult.length, 2);
        expect(cundinamarcaCities[0].name, 'Bogotá');
        expect(antioquiaCitiesResult[0].name, 'Medellín');

        verify(
          mockRepository.getCitiesByState(testCountryCode, testStateCode),
        ).called(1);
        verify(
          mockRepository.getCitiesByState(testCountryCode, anotherStateCode),
        ).called(1);
      });

      test('should validate both parameters are required', () async {
        // Arrange
        when(
          mockRepository.getCitiesByState(any, any),
        ).thenAnswer((_) async => testCities);

        // Act
        await useCase.call(testCountryCode, testStateCode);

        // Assert - Both parameters should be passed
        verify(
          mockRepository.getCitiesByState(
            argThat(equals(testCountryCode)),
            argThat(equals(testStateCode)),
          ),
        ).called(1);
      });
    });
  });
}
