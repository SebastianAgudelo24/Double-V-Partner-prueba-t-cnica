import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../constants/custom_font_weight.dart';
import 'custom_input.dart';

class CustomPhoneInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  final String? initialValue;
  final String countryCode;

  const CustomPhoneInput({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.initialValue,
    this.countryCode = '+57',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomInput(
      label: label,
      hintText: hintText ?? 'Ingresa tu número de teléfono',
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      focusNode: focusNode,
      initialValue: initialValue,
      keyboardType: TextInputType.phone,
      prefixIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(HugeIcons.strokeRoundedSmartPhone01),
            const SizedBox(width: 8),
            Text(
              countryCode,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: CustomFontWeight.semiBold,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.only(left: 8),
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ],
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        // Formato: 300 123 4567
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) return newValue;

          final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
          final buffer = StringBuffer();

          for (int i = 0; i < digitsOnly.length; i++) {
            if (i == 3 || i == 6) {
              buffer.write(' ');
            }
            buffer.write(digitsOnly[i]);
          }

          return TextEditingValue(
            text: buffer.toString(),
            selection: TextSelection.collapsed(offset: buffer.length),
          );
        }),
      ],
    );
  }
}
