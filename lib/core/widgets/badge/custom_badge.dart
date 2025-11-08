import 'package:flutter/material.dart';
import '../../constants/custom_font_weight.dart';

enum CustomBadgeType { primary, secondary, success, warning, error, info }

enum CustomBadgeSize { small, medium, large }

class CustomBadge extends StatelessWidget {
  final String placeholder;
  final CustomBadgeType type;
  final CustomBadgeSize size;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final bool outlined;

  const CustomBadge({
    super.key,
    required this.placeholder,
    this.type = CustomBadgeType.primary,
    this.size = CustomBadgeSize.medium,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.outlined = false,
  });

  // Factory constructors para diferentes tipos
  factory CustomBadge.primary({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.primary,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  factory CustomBadge.secondary({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.secondary,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  factory CustomBadge.success({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.success,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  factory CustomBadge.warning({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.warning,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  factory CustomBadge.error({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.error,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  factory CustomBadge.info({
    Key? key,
    required String placeholder,
    CustomBadgeSize size = CustomBadgeSize.medium,
    Widget? icon,
    bool outlined = false,
  }) {
    return CustomBadge(
      key: key,
      placeholder: placeholder,
      type: CustomBadgeType.info,
      size: size,
      icon: icon,
      outlined: outlined,
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CustomBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case CustomBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case CustomBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (size) {
      case CustomBadgeSize.small:
        return theme.textTheme.labelSmall?.copyWith(
          fontWeight: CustomFontWeight.medium,
        );
      case CustomBadgeSize.medium:
        return theme.textTheme.labelMedium?.copyWith(
          fontWeight: CustomFontWeight.medium,
        );
      case CustomBadgeSize.large:
        return theme.textTheme.labelLarge?.copyWith(
          fontWeight: CustomFontWeight.medium,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomBadgeSize.small:
        return 12;
      case CustomBadgeSize.medium:
        return 14;
      case CustomBadgeSize.large:
        return 16;
    }
  }

  BadgeColors _getColors(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case CustomBadgeType.primary:
        return BadgeColors(
          background: theme.colorScheme.primary,
          foreground: theme.colorScheme.onPrimary,
        );
      case CustomBadgeType.secondary:
        return BadgeColors(
          background: theme.colorScheme.secondary,
          foreground: theme.colorScheme.onSecondary,
        );
      case CustomBadgeType.success:
        return BadgeColors(background: Colors.green, foreground: Colors.white);
      case CustomBadgeType.warning:
        return BadgeColors(background: Colors.orange, foreground: Colors.white);
      case CustomBadgeType.error:
        return BadgeColors(
          background: theme.colorScheme.error,
          foreground: theme.colorScheme.onError,
        );
      case CustomBadgeType.info:
        return BadgeColors(background: Colors.blue, foreground: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final effectiveBackgroundColor =
        backgroundColor ?? (outlined ? Colors.transparent : colors.background);
    final effectiveForegroundColor =
        textColor ?? (outlined ? colors.background : colors.foreground);

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border:
            outlined ? Border.all(color: colors.background, width: 1.5) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: effectiveForegroundColor,
                size: _getIconSize(),
              ),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],

          Text(
            placeholder,
            style: _getTextStyle(
              context,
            )?.copyWith(color: effectiveForegroundColor),
          ),
        ],
      ),
    );
  }
}

class BadgeColors {
  final Color background;
  final Color foreground;

  const BadgeColors({required this.background, required this.foreground});
}
