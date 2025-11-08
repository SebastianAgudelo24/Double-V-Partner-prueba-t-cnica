import 'package:flutter/material.dart';
import '../../constants/custom_font_weight.dart';

enum CustomButtonType {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  destructive,
  link,
}

enum CustomButtonSize { small, medium, large }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.padding,
    this.borderRadius,
  });

  // Factory constructors para diferentes tipos
  factory CustomButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.primary,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.secondary,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.outline({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.outline,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.ghost({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.ghost,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.danger({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.danger,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.destructive({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.destructive,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  factory CustomButton.link({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    CustomButtonSize size = CustomButtonSize.medium,
    Widget? icon,
    Widget? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.link,
      size: size,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
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
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 40;
      case CustomButtonSize.medium:
        return 48;
      case CustomButtonSize.large:
        return 56;
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (widget.size) {
      case CustomButtonSize.small:
        return theme.textTheme.bodyMedium?.copyWith(
          fontWeight: CustomFontWeight.semiBold,
        );
      case CustomButtonSize.medium:
        return theme.textTheme.bodyLarge?.copyWith(
          fontWeight: CustomFontWeight.semiBold,
        );
      case CustomButtonSize.large:
        return theme.textTheme.titleMedium?.copyWith(
          fontWeight: CustomFontWeight.semiBold,
        );
    }
  }

  ButtonColors _getColors(BuildContext context) {
    final theme = Theme.of(context);

    switch (widget.type) {
      case CustomButtonType.primary:
        return ButtonColors(
          background: theme.colorScheme.primary,
          foreground: theme.colorScheme.onPrimary,
          border: theme.colorScheme.primary,
          shadow: theme.colorScheme.primary.withOpacity(0.3),
        );
      case CustomButtonType.secondary:
        return ButtonColors(
          background: theme.colorScheme.secondary,
          foreground: theme.colorScheme.onSecondary,
          border: theme.colorScheme.secondary,
          shadow: theme.colorScheme.secondary.withOpacity(0.3),
        );
      case CustomButtonType.outline:
        return ButtonColors(
          background: Colors.transparent,
          foreground: theme.colorScheme.primary,
          border: theme.colorScheme.primary,
          shadow: theme.colorScheme.primary.withOpacity(0.1),
        );
      case CustomButtonType.ghost:
        return ButtonColors(
          background: Colors.transparent,
          foreground: theme.colorScheme.onSurface,
          border: Colors.transparent,
          shadow: Colors.transparent,
        );
      case CustomButtonType.danger:
        return ButtonColors(
          background: theme.colorScheme.error,
          foreground: theme.colorScheme.onError,
          border: theme.colorScheme.error,
          shadow: theme.colorScheme.error.withOpacity(0.3),
        );
      case CustomButtonType.destructive:
        return ButtonColors(
          background: theme.colorScheme.error,
          foreground: theme.colorScheme.onError,
          border: theme.colorScheme.error,
          shadow: theme.colorScheme.error.withOpacity(0.3),
        );
      case CustomButtonType.link:
        return ButtonColors(
          background: Colors.transparent,
          foreground: theme.colorScheme.primary,
          border: Colors.transparent,
          shadow: Colors.transparent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

    return AnimatedBuilder(
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
              width: widget.width,
              height: _getHeight(),
              padding: _getPadding(),
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? colors.background
                        : colors.background.withOpacity(0.5),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                border:
                    widget.type == CustomButtonType.outline
                        ? Border.all(
                          color:
                              isEnabled
                                  ? colors.border
                                  : colors.border.withOpacity(0.5),
                          width: 2,
                        )
                        : null,
                boxShadow:
                    widget.type != CustomButtonType.ghost &&
                            widget.type != CustomButtonType.outline &&
                            widget.type != CustomButtonType.link &&
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled
                              ? colors.foreground
                              : colors.foreground.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (widget.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color:
                            isEnabled
                                ? colors.foreground
                                : colors.foreground.withOpacity(0.5),
                        size: widget.size == CustomButtonSize.small ? 16 : 20,
                      ),
                      child: widget.icon!,
                    ),
                    const SizedBox(width: 8),
                  ],

                  Flexible(
                    child: Text(
                      widget.text,
                      style: _getTextStyle(context)?.copyWith(
                        color:
                            isEnabled
                                ? colors.foreground
                                : colors.foreground.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (widget.trailingIcon != null && !widget.isLoading) ...[
                    const SizedBox(width: 8),
                    IconTheme(
                      data: IconThemeData(
                        color:
                            isEnabled
                                ? colors.foreground
                                : colors.foreground.withOpacity(0.5),
                        size: widget.size == CustomButtonSize.small ? 16 : 20,
                      ),
                      child: widget.trailingIcon!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ButtonColors {
  final Color background;
  final Color foreground;
  final Color border;
  final Color shadow;

  const ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.shadow,
  });
}
