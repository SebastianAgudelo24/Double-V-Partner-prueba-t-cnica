import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/addresses/addresses.dart';
import '../../features/auth/presentation/pages/auth_check_screen.dart';
import '../../features/auth/presentation/pages/user_registration_page.dart';
import '../../features/profile/profile.dart';

class AppRoutes {
  // Route names
  static const String authCheck = 'auth-check';
  static const String userRegistration = 'user-registration';
  static const String addAddress = 'add-address';
  static const String userProfile = 'user-profile';

  // Route paths
  static const String authCheckPath = '/';
  static const String userRegistrationPath = '/register';
  static const String addAddressPath = '/add-address';
  static const String userProfilePath = '/user-profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.authCheckPath,
    routes: [
      // Auth check (Pantalla inicial para verificar autenticación)
      GoRoute(
        path: AppRoutes.authCheckPath,
        name: AppRoutes.authCheck,
        builder: (context, state) => const AuthCheckScreen(),
      ),

      // User registration (Pantalla 1)
      GoRoute(
        path: AppRoutes.userRegistrationPath,
        name: AppRoutes.userRegistration,
        builder: (context, state) => const UserRegistrationPage(),
      ),

      // Add address (Pantalla 2)
      GoRoute(
        path: AppRoutes.addAddressPath,
        name: AppRoutes.addAddress,
        builder: (context, state) => const AddAddressPage(),
      ),

      // User profile (Pantalla 3)
      GoRoute(
        path: AppRoutes.userProfilePath,
        name: AppRoutes.userProfile,
        builder: (context, state) => const UserProfilePage(),
      ),
    ],

    // Las redirecciones ahora se manejan por AuthCheckScreen
    // Dejamos el router sin redirecciones automáticas
    redirect: (context, state) => null,
  );
});
