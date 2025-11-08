import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../lib/features/auth/data/datasources/auth_datasource.dart';
import '../../lib/features/addresses/domain/repositories/location_repository.dart';
import '../../lib/features/addresses/data/datasources/location_datasource.dart';
import '../../lib/features/profile/domain/repositories/profile_repository.dart';
import '../../lib/features/auth/domain/use_cases/register_user_use_case.dart';
import '../../lib/features/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../lib/features/auth/domain/use_cases/logout_use_case.dart';
import '../../lib/features/auth/domain/use_cases/is_authenticated_use_case.dart';
import '../../lib/features/auth/domain/use_cases/update_user_use_case.dart';
import '../../lib/features/profile/domain/use_cases/get_user_profile_use_case.dart';
import '../../lib/features/profile/domain/use_cases/update_user_profile_use_case.dart';
import '../../lib/features/profile/domain/use_cases/add_address_to_profile_use_case.dart';
import '../../lib/features/profile/domain/use_cases/refresh_profile_use_case.dart';

// Genera los mocks con: flutter packages pub run build_runner build
@GenerateMocks([
  AuthRepository,
  AuthLocalDataSource,
  LocationRepository,
  LocationDataSource,
  ProfileRepository,
  FlutterSecureStorage,
  // Auth Use Cases
  RegisterUserUseCase,
  GetCurrentUserUseCase,
  LogoutUseCase,
  IsAuthenticatedUseCase,
  UpdateUserUseCase,
  // Profile Use Cases
  GetUserProfileUseCase,
  UpdateUserProfileUseCase,
  AddAddressToProfileUseCase,
  RefreshProfileUseCase,
])
void main() {}
