import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/button/custom_button.dart';
import '../providers/auth_providers.dart';
import '../widgets/widgets.dart';

class UserRegistrationPage extends ConsumerStatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  ConsumerState<UserRegistrationPage> createState() =>
      _UserRegistrationPageState();
}

class _UserRegistrationPageState extends ConsumerState<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;
  DateTime? _selectedDate;

  /// Método para quitar el enfoque de todos los campos de texto
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header moderno usando widget modular
                  const RegistrationHeader(
                    title: '¡Bienvenido!',
                    subtitle: 'Prueba tecnica DVP',
                  ),

                  const SizedBox(height: 32),

                  // Formulario modular
                  UserRegistrationForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    lastNameController: _lastNameController,
                    dateController: _dateController,
                    selectedDate: _selectedDate,
                    onDateTap: _selectBirthDate,
                  ),

                  const SizedBox(height: 40),

                  // Botón de registro
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton.primary(
                      onPressed: _isLoading ? null : _registerUser,
                      text: _isLoading ? 'Registrando...' : 'Crear Cuenta',
                      isLoading: _isLoading,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 años atrás
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    // Formato DD/MM/YYYY para español
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Registrar usuario usando el provider
      await ref
          .read(authProvider.notifier)
          .registerUser(
            name: _nameController.text.trim(),
            surname: _lastNameController.text.trim(),
            birthDate: _selectedDate!,
          );

      // Esperar un frame para que el estado se propague
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 100));

        // Navegar a la siguiente pantalla
        context.go(AppRoutes.addAddressPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar usuario: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
