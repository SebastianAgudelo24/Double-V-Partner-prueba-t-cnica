import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/widgets/input/custom_input.dart';

class UserRegistrationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController dateController;
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  const UserRegistrationForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.lastNameController,
    required this.dateController,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  /// Valida que el texto solo contenga letras, espacios y tildes
  bool _isValidName(String name) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-ZÀ-ÿ\u00f1\u00d1\s]+$');
    return nameRegExp.hasMatch(name);
  }

  /// Formatter que solo permite letras, espacios y tildes
  final TextInputFormatter _nameFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-ZÀ-ÿ\u00f1\u00d1\s]'),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información personal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 32),

            // Campo de Nombre
            CustomInput(
              controller: widget.nameController,
              label: 'Nombre',
              hintText: 'Ingresa tu nombre',
              prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
              inputFormatters: [_nameFormatter],
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'El nombre es requerido';
                }
                if ((value?.trim().length ?? 0) < 2) {
                  return 'El nombre debe tener al menos 2 caracteres';
                }
                if (!_isValidName(value!.trim())) {
                  return 'El nombre solo puede contener letras y espacios';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Campo de Apellido
            CustomInput(
              controller: widget.lastNameController,
              label: 'Apellido',
              hintText: 'Ingresa tu apellido',
              prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
              inputFormatters: [_nameFormatter],
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'El apellido es requerido';
                }
                if ((value?.trim().length ?? 0) < 2) {
                  return 'El apellido debe tener al menos 2 caracteres';
                }
                if (!_isValidName(value!.trim())) {
                  return 'El apellido solo puede contener letras y espacios';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Campo de Fecha de Nacimiento
            CustomInput(
              controller: widget.dateController,
              label: 'Fecha de Nacimiento',
              hintText: 'Selecciona tu fecha de nacimiento',
              prefixIcon: const Icon(HugeIcons.strokeRoundedCalendar03),
              readOnly: true,
              onTap: widget.onDateTap,
              validator: (value) {
                if (widget.selectedDate == null) {
                  return 'La fecha de nacimiento es requerida';
                }

                // Validar que sea mayor de edad (18 años)
                final now = DateTime.now();
                final age = now.year - widget.selectedDate!.year;
                if (age < 18) {
                  return 'Debes ser mayor de 18 años';
                }

                return null;
              },
            ),

            const SizedBox(height: 32),

            // Información adicional con diseño moderno
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              HugeIcons.strokeRoundedInformationCircle,
              color: Colors.blue[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Después podrás agregar tu dirección y completar tu perfil.',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
