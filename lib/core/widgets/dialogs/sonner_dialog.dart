import 'package:flutter/material.dart';
import '../../constants/custom_font_weight.dart';
import '../button/custom_button.dart';

enum SonnerType { success, error, warning, info }

class SonnerDialog {
  static void showSuccess(BuildContext context, String message) {
    _showSonner(context, message, SonnerType.success);
  }

  static void showError(BuildContext context, String message) {
    _showSonner(context, message, SonnerType.error);
  }

  static void showWarning(BuildContext context, String message) {
    _showSonner(context, message, SonnerType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    _showSonner(context, message, SonnerType.info);
  }

  static void show(BuildContext context, {String? title, String? description}) {
    _showSonner(
      context,
      description ?? title ?? 'Notificación',
      SonnerType.info,
    );
  }

  static void destructive(
    BuildContext context, {
    String? title,
    String? description,
  }) {
    _showSonner(context, description ?? title ?? 'Error', SonnerType.error);
  }

  static void _showSonner(
    BuildContext context,
    String message,
    SonnerType type,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => _SonnerDialogWidget(message: message, type: type),
    );
  }
}

class _SonnerDialogWidget extends StatefulWidget {
  final String message;
  final SonnerType type;

  const _SonnerDialogWidget({required this.message, required this.type});

  @override
  State<_SonnerDialogWidget> createState() => _SonnerDialogWidgetState();
}

class _SonnerDialogWidgetState extends State<_SonnerDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.type) {
      case SonnerType.success:
        return Colors.green;
      case SonnerType.error:
        return theme.colorScheme.error;
      case SonnerType.warning:
        return Colors.orange;
      case SonnerType.info:
        return theme.colorScheme.primary;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SonnerType.success:
        return Icons.check_circle;
      case SonnerType.error:
        return Icons.error;
      case SonnerType.warning:
        return Icons.warning;
      case SonnerType.info:
        return Icons.info;
    }
  }

  String _getTitle() {
    switch (widget.type) {
      case SonnerType.success:
        return 'Éxito';
      case SonnerType.error:
        return 'Error';
      case SonnerType.warning:
        return 'Atención';
      case SonnerType.info:
        return 'Información';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(), color: color, size: 32),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _getTitle(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: CustomFontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: CustomFontWeight.regular,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  CustomButton.primary(
                    text: 'Entendido',
                    onPressed: () => Navigator.of(context).pop(),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
