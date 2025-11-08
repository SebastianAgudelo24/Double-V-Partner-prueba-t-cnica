import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final VoidCallback? onTap;
  final bool enableAnimation;
  final bool enableHover;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.onTap,
    this.enableAnimation = true,
    this.enableHover = true,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.enableAnimation) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.enableAnimation) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && widget.enableAnimation) {
      _animationController.reverse();
    }
  }

  void _handleHoverEnter(PointerEvent event) {
    if (widget.enableHover) {
      setState(() => _isHovered = true);
    }
  }

  void _handleHoverExit(PointerEvent event) {
    if (widget.enableHover) {
      setState(() => _isHovered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget card = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.colorScheme.surface,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              border: widget.border,
              boxShadow:
                  widget.boxShadow ??
                  [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius:
                          _isHovered && widget.enableHover
                              ? _elevationAnimation.value
                              : 4,
                      offset: Offset(
                        0,
                        _isHovered && widget.enableHover
                            ? _elevationAnimation.value / 2
                            : 2,
                      ),
                    ),
                  ],
            ),
            child: widget.child,
          ),
        );
      },
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: _handleHoverEnter,
          onExit: _handleHoverExit,
          cursor: SystemMouseCursors.click,
          child: card,
        ),
      );
    } else if (widget.enableHover) {
      card = MouseRegion(
        onEnter: _handleHoverEnter,
        onExit: _handleHoverExit,
        child: card,
      );
    }

    return card;
  }
}
