import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Name Input Validation', () {
    group('Validation functions', () {
      // Recreamos las funciones de validación usadas en la aplicación
      String? validateName(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }

        if (value.trim().length < 2) {
          return 'Debe tener al menos 2 caracteres';
        }

        if (!RegExp(r'^[a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]+$').hasMatch(value.trim())) {
          return 'Solo se permiten letras y espacios';
        }

        return null;
      }

      test('should validate required field', () {
        expect(validateName(null), 'Este campo es obligatorio');
        expect(validateName(''), 'Este campo es obligatorio');
        expect(validateName('   '), 'Este campo es obligatorio');
      });

      test('should validate minimum length', () {
        expect(validateName('A'), 'Debe tener al menos 2 caracteres');
        expect(validateName(' B '), 'Debe tener al menos 2 caracteres');
      });

      test('should validate character restrictions', () {
        expect(validateName('Juan123'), 'Solo se permiten letras y espacios');
        expect(validateName('María@'), 'Solo se permiten letras y espacios');
        expect(validateName('José-Luis'), 'Solo se permiten letras y espacios');
        expect(validateName('Ana_Clara'), 'Solo se permiten letras y espacios');
      });

      test('should accept valid names', () {
        expect(validateName('Juan'), null);
        expect(validateName('María'), null);
        expect(validateName('José Luis'), null);
        expect(validateName('Ángela Sofía'), null);
        expect(validateName('Niño'), null);
        expect(validateName('Peña González'), null);
      });

      test('should handle edge cases', () {
        expect(validateName('  Juan  '), null); // Trimming whitespace
        expect(validateName('A B'), null); // Short but valid
        expect(validateName('Ñoño'), null); // Special Spanish characters
      });
    });

    group('RegExp pattern validation', () {
      final namePattern = RegExp(r'^[a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]+$');

      test('should match valid Spanish names', () {
        const validNames = [
          'Juan',
          'María',
          'José Luis',
          'Ángela',
          'Sofía',
          'Niño',
          'Peña',
          'González',
          'Núñez',
          'Muñoz',
        ];

        for (final name in validNames) {
          expect(
            namePattern.hasMatch(name),
            true,
            reason: 'Should match valid name: $name',
          );
        }
      });

      test('should not match names with invalid characters', () {
        const invalidNames = [
          'Juan123',
          'María@email.com',
          'José-Luis',
          'Ana_Clara',
          'Pedro.',
          'Luis,',
          'Carlos;',
          'Ana:',
          'Test!',
          'Name#',
          'User\$',
          'Test%',
          'Name&',
          'Test*',
        ];

        for (final name in invalidNames) {
          expect(
            namePattern.hasMatch(name),
            false,
            reason: 'Should not match invalid name: $name',
          );
        }
      });

      test('should handle empty and whitespace strings correctly', () {
        // Empty string should not match
        expect(namePattern.hasMatch(''), false);

        // Newlines and tabs should not match (not in our pattern)
        expect(namePattern.hasMatch('\n'), false);
        expect(namePattern.hasMatch('\t'), false);
        expect(namePattern.hasMatch('\r'), false);

        // Spaces are allowed in our pattern, so this would match
        expect(
          namePattern.hasMatch('   '),
          true,
          reason: 'Spaces are allowed in name pattern',
        );
      });
    });
  });
}
