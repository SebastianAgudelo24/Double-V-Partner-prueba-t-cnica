import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../lib/features/addresses/domain/repositories/location_repository.dart';
import '../../lib/features/profile/domain/repositories/profile_repository.dart';

// Genera los mocks con: flutter packages pub run build_runner build
@GenerateMocks([
  AuthRepository,
  LocationRepository,
  ProfileRepository,
  FlutterSecureStorage,
])
void main() {}
