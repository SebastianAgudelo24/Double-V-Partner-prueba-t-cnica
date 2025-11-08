import 'package:flutter/material.dart';
import '../../constants/custom_font_weight.dart';

enum AvatarSize { small, medium, large, extraLarge }

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? child;
  final bool showBorder;
  final Color? borderColor;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.child,
    this.showBorder = false,
    this.borderColor,
  });

  double _getSize() {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 48;
      case AvatarSize.large:
        return 64;
      case AvatarSize.extraLarge:
        return 96;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AvatarSize.small:
        return 14;
      case AvatarSize.medium:
        return 18;
      case AvatarSize.large:
        return 24;
      case AvatarSize.extraLarge:
        return 36;
    }
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '';

    final words = name!.trim().split(' ');
    if (words.isEmpty) return '';

    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = _getSize();
    final fontSize = _getFontSize();

    Widget avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? theme.colorScheme.primary.withOpacity(0.1),
        border:
            showBorder
                ? Border.all(
                  color:
                      borderColor ?? theme.colorScheme.outline.withOpacity(0.2),
                  width: 2,
                )
                : null,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child:
            child ??
            (imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitialsWidget(theme, fontSize);
                  },
                )
                : _buildInitialsWidget(theme, fontSize)),
      ),
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildInitialsWidget(ThemeData theme, double fontSize) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? theme.colorScheme.primary.withOpacity(0.8),
            backgroundColor ?? theme.colorScheme.primary,
          ],
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: CustomFontWeight.semiBold,
            color: textColor ?? theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
