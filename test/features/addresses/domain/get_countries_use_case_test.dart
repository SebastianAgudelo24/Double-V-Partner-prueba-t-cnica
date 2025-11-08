import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../lib/features/addresses/domain/usecases/get_countries_use_case.dart';
import '../../../../lib/features/addresses/domain/entities/country.dart';
import '../../../test_helpers/mock_annotations.mocks.dart';

void main() {
  group('GetCountriesUseCase', () {
    late GetCountriesUseCase useCase;
    late MockLocationRepository mockRepository;

    setUp(() {
      mockRepository = MockLocationRepository();
      useCase = GetCountriesUseCase(mockRepository);
    });

    group('call', () {
      final testCountries = [
        const Country(code: 'CO', name: 'Colombia', flag: '🇨🇴'),
        const Country(code: 'US', name: 'United States', flag: '🇺🇸'),
      ];

      test('should return list of countries from repository', () async {
        // Arrange
        when(
          mockRepository.getCountries(),
        ).thenAnswer((_) async => testCountries);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, testCountries);
        expect(result.length, 2);
        expect(result[0].name, 'Colombia');
        expect(result[1].name, 'United States');
        verify(mockRepository.getCountries()).called(1);
      });

      test('should return empty list when no countries available', () async {
        // Arrange
        when(mockRepository.getCountries()).thenAnswer((_) async => []);

        // Act
        final result = await useCase.call();

        // Assert
        expect(result, []);
        expect(result.length, 0);
        verify(mockRepository.getCountries()).called(1);
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(
          mockRepository.getCountries(),
        ).thenThrow(Exception('Failed to get countries'));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
