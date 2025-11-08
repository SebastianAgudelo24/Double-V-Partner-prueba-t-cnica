import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_countries_use_case.dart';
import '../../domain/usecases/get_states_by_country_use_case.dart';
import '../../domain/usecases/get_cities_by_state_use_case.dart';

/// Provider para acceder al LocationRepository
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return getIt<LocationRepository>();
});

/// Providers para los Use Cases de ubicación
final getCountriesUseCaseProvider = Provider<GetCountriesUseCase>((ref) {
  return GetCountriesUseCase(ref.read(locationRepositoryProvider));
});

final getStatesByCountryUseCaseProvider = Provider<GetStatesByCountryUseCase>((
  ref,
) {
  return GetStatesByCountryUseCase(ref.read(locationRepositoryProvider));
});

final getCitiesByStateUseCaseProvider = Provider<GetCitiesByStateUseCase>((
  ref,
) {
  return GetCitiesByStateUseCase(ref.read(locationRepositoryProvider));
});
