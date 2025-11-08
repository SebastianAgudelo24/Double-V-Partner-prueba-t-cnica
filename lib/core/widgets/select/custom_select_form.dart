import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../constants/custom_font_weight.dart';

class CustomSelectForm<T> extends StatefulWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const CustomSelectForm({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
  });

  // Factory constructor para usar como formfield
  factory CustomSelectForm.formField({
    Key? key,
    String? label,
    String? hintText,
    T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    void Function(T?)? onChanged,
    String? Function(T?)? validator,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return CustomSelectForm<T>(
      key: key,
      label: label,
      hintText: hintText,
      value: value,
      items: items,
      itemLabel: itemLabel,
      onChanged: onChanged,
      validator: validator,
      prefixIcon: prefixIcon,
      enabled: enabled,
    );
  }

  @override
  State<CustomSelectForm<T>> createState() => _CustomSelectFormState<T>();
}

class _CustomSelectFormState<T> extends State<CustomSelectForm<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

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

  void _showBottomSheet() {
    if (!widget.enabled) return;

    _handleFocusChange(true);

    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _SelectBottomSheet<T>(
            items: widget.items,
            itemLabel: widget.itemLabel,
            selectedValue: widget.value,
            onSelected: (value) {
              widget.onChanged?.call(value);
              _handleFocusChange(false);
              Navigator.of(context).pop();
            },
          ),
    ).then((_) {
      _handleFocusChange(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Validar si es necesario
    if (widget.validator != null) {
      _errorText = widget.validator!(widget.value);
      _hasError = _errorText != null;
    }

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
                child: GestureDetector(
                  onTap: _showBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.enabled
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            _hasError
                                ? theme.colorScheme.error
                                : _isFocused
                                ? (_colorAnimation.value ??
                                    theme.colorScheme.primary)
                                : theme.colorScheme.outline.withOpacity(0.2),
                        width: _isFocused || _hasError ? 2.0 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (widget.prefixIcon != null) ...[
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: widget.prefixIcon,
                          ),
                        ],

                        Expanded(
                          child: Text(
                            widget.value != null
                                ? widget.itemLabel(widget.value!)
                                : widget.hintText ?? 'Seleccionar...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight:
                                  widget.value != null
                                      ? CustomFontWeight.medium
                                      : CustomFontWeight.regular,
                              color:
                                  widget.value != null
                                      ? (widget.enabled
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurface
                                              .withOpacity(0.6))
                                      : theme.colorScheme.onSurface.withOpacity(
                                        0.5,
                                      ),
                            ),
                          ),
                        ),

                        Icon(
                          HugeIcons.strokeRoundedArrowDown01,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: CustomFontWeight.medium,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SelectBottomSheet<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final T? selectedValue;
  final void Function(T) onSelected;

  const _SelectBottomSheet({
    required this.items,
    required this.itemLabel,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Seleccionar opción',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: CustomFontWeight.semiBold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(HugeIcons.strokeRoundedCancel01),
                ),
              ],
            ),
          ),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedValue;

                return ListTile(
                  title: Text(
                    itemLabel(item),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected
                              ? CustomFontWeight.semiBold
                              : CustomFontWeight.medium,
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? Icon(
                            HugeIcons.strokeRoundedTick01,
                            color: theme.colorScheme.primary,
                          )
                          : null,
                  onTap: () => onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
