import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../constants/custom_font_weight.dart';

class CustomInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final Color? fillColor;
  final bool filled;

  const CustomInput({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.initialValue,
    this.isDense = false,
    this.contentPadding,
    this.border,
    this.fillColor,
    this.filled = true,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isFocused = false;
  bool _hasError = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);

    _colorAnimation = ColorTween(
      begin: theme.colorScheme.outline.withOpacity(0.5),
      end: theme.colorScheme.primary,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: CustomFontWeight.medium,
              color:
                  _hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],

        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow:
                      _isFocused && !_hasError
                          ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : _hasError
                          ? [
                            BoxShadow(
                              color: theme.colorScheme.error.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                child: Focus(
                  onFocusChange: _handleFocusChange,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    onChanged: widget.onChanged,
                    onTap: widget.onTap,
                    obscureText: _obscureText,
                    readOnly: widget.readOnly,
                    enabled: widget.enabled,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    textCapitalization: widget.textCapitalization,
                    initialValue: widget.initialValue,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: CustomFontWeight.medium,
                      color:
                          widget.enabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: CustomFontWeight.regular,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      prefixIcon:
                          widget.prefixIcon != null
                              ? Container(
                                margin: const EdgeInsets.only(
                                  left: 4,
                                  right: 8,
                                ),
                                child: widget.prefixIcon,
                              )
                              : null,
                      suffixIcon:
                          widget.obscureText
                              ? IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? HugeIcons.strokeRoundedView
                                      : HugeIcons.strokeRoundedViewOff,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )
                              : widget.suffixIcon,
                      contentPadding:
                          widget.contentPadding ??
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                      isDense: widget.isDense,
                      filled: widget.filled,
                      fillColor:
                          widget.fillColor ??
                          (widget.enabled
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface.withOpacity(0.5)),

                      // Borders
                      border:
                          widget.border ??
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color:
                              _colorAnimation.value ??
                              theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.error,
                          width: 2.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: CustomFontWeight.medium,
                color:
                    _hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Widget específico para inputs alfabéticos
class CustomAlphabeticInput extends StatelessWidget {
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
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool allowSpaces;

  const CustomAlphabeticInput({
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
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.initialValue,
    this.allowSpaces = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      maxLines: maxLines,
      maxLength: maxLength,
      focusNode: focusNode,
      initialValue: initialValue,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowSpaces
              ? RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]')
              : RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]'),
        ),
      ],
    );
  }
}
