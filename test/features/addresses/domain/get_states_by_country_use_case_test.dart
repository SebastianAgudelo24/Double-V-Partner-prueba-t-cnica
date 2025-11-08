import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/addresses/domain/usecases/get_states_by_country_use_case.dart';
import '../../../../lib/features/addresses/domain/entities/state.dart'
    as entities;
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('GetStatesByCountryUseCase', () {
    late GetStatesByCountryUseCase useCase;
    late MockLocationRepository mockRepository;

    setUp(() {
      mockRepository = MockLocationRepository();
      useCase = GetStatesByCountryUseCase(mockRepository);
    });

    group('call', () {
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
        const entities.AddressState(
          code: 'VAL',
          name: 'Valle del Cauca',
          countryCode: testCountryCode,
        ),
      ];

      test(
        'should return list of states for given country from repository',
        () async {
          // Arrange
          when(
            mockRepository.getStatesByCountry(testCountryCode),
          ).thenAnswer((_) async => testStates);

          // Act
          final result = await useCase.call(testCountryCode);

          // Assert
          expect(result, testStates);
          expect(result.length, 3);
          expect(result[0].name, 'Cundinamarca');
          expect(result[1].name, 'Antioquia');
          expect(result[2].name, 'Valle del Cauca');
          verify(mockRepository.getStatesByCountry(testCountryCode)).called(1);
        },
      );

      test(
        'should return empty list when no states available for country',
        () async {
          // Arrange
          when(
            mockRepository.getStatesByCountry(testCountryCode),
          ).thenAnswer((_) async => []);

          // Act
          final result = await useCase.call(testCountryCode);

          // Assert
          expect(result, []);
          expect(result.length, 0);
          verify(mockRepository.getStatesByCountry(testCountryCode)).called(1);
        },
      );

      test('should call repository with correct country code', () async {
        // Arrange
        const differentCountryCode = 'US';
        when(
          mockRepository.getStatesByCountry(differentCountryCode),
        ).thenAnswer((_) async => []);

        // Act
        await useCase.call(differentCountryCode);

        // Assert
        verify(
          mockRepository.getStatesByCountry(differentCountryCode),
        ).called(1);
        verifyNever(mockRepository.getStatesByCountry(testCountryCode));
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.getStatesByCountry(testCountryCode),
        ).thenThrow(Exception('Failed to get states'));

        // Act & Assert
        expect(() => useCase.call(testCountryCode), throwsException);
      });

      test('should handle different country codes independently', () async {
        // Arrange
        const usCountryCode = 'US';
        final usStates = [
          const entities.AddressState(
            code: 'CA',
            name: 'California',
            countryCode: usCountryCode,
          ),
          const entities.AddressState(
            code: 'TX',
            name: 'Texas',
            countryCode: usCountryCode,
          ),
        ];

        when(
          mockRepository.getStatesByCountry(testCountryCode),
        ).thenAnswer((_) async => testStates);
        when(
          mockRepository.getStatesByCountry(usCountryCode),
        ).thenAnswer((_) async => usStates);

        // Act
        final colombianStates = await useCase.call(testCountryCode);
        final americanStates = await useCase.call(usCountryCode);

        // Assert
        expect(colombianStates.length, 3);
        expect(americanStates.length, 2);
        expect(colombianStates[0].name, 'Cundinamarca');
        expect(americanStates[0].name, 'California');

        verify(mockRepository.getStatesByCountry(testCountryCode)).called(1);
        verify(mockRepository.getStatesByCountry(usCountryCode)).called(1);
      });
    });
  });
}
