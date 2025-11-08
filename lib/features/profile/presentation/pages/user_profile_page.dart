import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/button/custom_button.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/widgets.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  void _refreshUserData() {
    // Asegurar que los datos del usuario estén cargados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initializeAuth();
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Mostrar loading si no hay usuario
    if (authState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Mostrar error si no hay usuario
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedUserRemove02,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay usuario registrado',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton.primary(
                onPressed: () => context.go(AppRoutes.userRegistrationPath),
                text: 'Registrar Usuario',
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Header modular
                ProfileHeader(
                  user: user,
                  onOptionsPressed: () => _showOptionsMenu(context, user),
                ),

                const SizedBox(height: 32),

                // Información personal usando widgets modulares
                ProfileSection(
                  title: 'Información Personal',
                  icon: HugeIcons.strokeRoundedUser,
                  iconColor: Colors.blue[700]!,
                  children: [
                    ProfileInfoCard(
                      label: 'Nombre completo',
                      value: user.fullName,
                      icon: HugeIcons.strokeRoundedUser,
                    ),
                    const SizedBox(height: 16),
                    ProfileInfoCard(
                      label: 'Fecha de nacimiento',
                      value: DateFormat('dd/MM/yyyy').format(user.birthDate),
                      icon: HugeIcons.strokeRoundedCalendar03,
                    ),
                    const SizedBox(height: 16),
                    ProfileInfoCard(
                      label: 'Edad',
                      value: '${_calculateAge(user.birthDate)} años',
                      icon: HugeIcons.strokeRoundedCalendar03,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Direcciones usando widgets modulares
                ProfileSection(
                  title: 'Direcciones',
                  icon: HugeIcons.strokeRoundedLocation01,
                  iconColor: Colors.green[700]!,
                  actionButton: IconButton(
                    onPressed: () => context.go(AppRoutes.addAddressPath),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        HugeIcons.strokeRoundedAdd01,
                        color: Colors.green[700],
                        size: 20,
                      ),
                    ),
                  ),
                  children: [
                    if (user.addresses.isNotEmpty)
                      ...user.addresses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final address = entry.value;
                        return Column(
                          children: [
                            if (index > 0) const SizedBox(height: 16),
                            ProfileInfoCard(
                              label: 'Dirección ${index + 1}',
                              value: address.fullAddress,
                              icon: HugeIcons.strokeRoundedLocation01,
                            ),
                          ],
                        );
                      })
                    else
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedLocation04,
                              size: 48,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay direcciones registradas',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Agrega tu primera dirección para completar tu perfil',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            CustomButton.primary(
                              onPressed:
                                  () => context.go(AppRoutes.addAddressPath),
                              text: 'Agregar Dirección',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showOptionsMenu(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      HugeIcons.strokeRoundedLogout01,
                      color: Colors.red[600],
                    ),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    Navigator.pop(context); // Cerrar el bottom sheet
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar Sesión'),
            content: const Text('¿Estás seguro que deseas cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                  if (mounted) {
                    context.go(AppRoutes.userRegistrationPath);
                  }
                },
                child: Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.red[600]),
                ),
              ),
            ],
          ),
    );
  }
}
