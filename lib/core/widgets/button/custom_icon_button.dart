import 'package:flutter/material.dart';

enum CustomIconButtonType { primary, secondary, outline, ghost, danger }

enum CustomIconButtonSize { small, medium, large }

class CustomIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final CustomIconButtonType type;
  final CustomIconButtonSize size;
  final String? tooltip;
  final bool isLoading;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.type = CustomIconButtonType.primary,
    this.size = CustomIconButtonSize.medium,
    this.tooltip,
    this.isLoading = false,
    this.isDisabled = false,
    this.padding,
    this.borderRadius,
  });

  // Factory constructors para diferentes tipos
  factory CustomIconButton.primary({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    CustomIconButtonSize size = CustomIconButtonSize.medium,
    String? tooltip,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CustomIconButtonType.primary,
      size: size,
      tooltip: tooltip,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  factory CustomIconButton.secondary({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    CustomIconButtonSize size = CustomIconButtonSize.medium,
    String? tooltip,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CustomIconButtonType.secondary,
      size: size,
      tooltip: tooltip,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  factory CustomIconButton.outline({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    CustomIconButtonSize size = CustomIconButtonSize.medium,
    String? tooltip,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CustomIconButtonType.outline,
      size: size,
      tooltip: tooltip,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  factory CustomIconButton.ghost({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    CustomIconButtonSize size = CustomIconButtonSize.medium,
    String? tooltip,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CustomIconButtonType.ghost,
      size: size,
      tooltip: tooltip,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  factory CustomIconButton.danger({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    CustomIconButtonSize size = CustomIconButtonSize.medium,
    String? tooltip,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CustomIconButtonType.danger,
      size: size,
      tooltip: tooltip,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case CustomIconButtonSize.small:
        return const EdgeInsets.all(8);
      case CustomIconButtonSize.medium:
        return const EdgeInsets.all(12);
      case CustomIconButtonSize.large:
        return const EdgeInsets.all(16);
    }
  }

  double _getSize() {
    switch (widget.size) {
      case CustomIconButtonSize.small:
        return 40;
      case CustomIconButtonSize.medium:
        return 48;
      case CustomIconButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case CustomIconButtonSize.small:
        return 16;
      case CustomIconButtonSize.medium:
        return 20;
      case CustomIconButtonSize.large:
        return 24;
    }
  }

  IconButtonColors _getColors(BuildContext context) {
    final theme = Theme.of(context);

    switch (widget.type) {
      case CustomIconButtonType.primary:
        return IconButtonColors(
          background: theme.colorScheme.primary,
          foreground: theme.colorScheme.onPrimary,
          border: theme.colorScheme.primary,
          shadow: theme.colorScheme.primary.withOpacity(0.3),
        );
      case CustomIconButtonType.secondary:
        return IconButtonColors(
          background: theme.colorScheme.secondary,
          foreground: theme.colorScheme.onSecondary,
          border: theme.colorScheme.secondary,
          shadow: theme.colorScheme.secondary.withOpacity(0.3),
        );
      case CustomIconButtonType.outline:
        return IconButtonColors(
          background: Colors.transparent,
          foreground: theme.colorScheme.primary,
          border: theme.colorScheme.primary,
          shadow: theme.colorScheme.primary.withOpacity(0.1),
        );
      case CustomIconButtonType.ghost:
        return IconButtonColors(
          background: theme.colorScheme.surface.withOpacity(0.5),
          foreground: theme.colorScheme.onSurface,
          border: Colors.transparent,
          shadow: Colors.transparent,
        );
      case CustomIconButtonType.danger:
        return IconButtonColors(
          background: theme.colorScheme.error,
          foreground: theme.colorScheme.onError,
          border: theme.colorScheme.error,
          shadow: theme.colorScheme.error.withOpacity(0.3),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

    Widget button = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: Container(
              width: _getSize(),
              height: _getSize(),
              padding: _getPadding(),
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? colors.background
                        : colors.background.withOpacity(0.5),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                border:
                    widget.type == CustomIconButtonType.outline
                        ? Border.all(
                          color:
                              isEnabled
                                  ? colors.border
                                  : colors.border.withOpacity(0.5),
                          width: 2,
                        )
                        : null,
                boxShadow:
                    widget.type != CustomIconButtonType.ghost &&
                            widget.type != CustomIconButtonType.outline &&
                            isEnabled
                        ? [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: _elevationAnimation.value,
                            offset: Offset(0, _elevationAnimation.value / 2),
                          ),
                        ]
                        : [],
              ),
              child:
                  widget.isLoading
                      ? SizedBox(
                        width: _getIconSize(),
                        height: _getIconSize(),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isEnabled
                                ? colors.foreground
                                : colors.foreground.withOpacity(0.5),
                          ),
                        ),
                      )
                      : IconTheme(
                        data: IconThemeData(
                          color:
                              isEnabled
                                  ? colors.foreground
                                  : colors.foreground.withOpacity(0.5),
                          size: _getIconSize(),
                        ),
                        child: widget.icon,
                      ),
            ),
          ),
        );
      },
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

class IconButtonColors {
  final Color background;
  final Color foreground;
  final Color border;
  final Color shadow;

  const IconButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.shadow,
  });
}
