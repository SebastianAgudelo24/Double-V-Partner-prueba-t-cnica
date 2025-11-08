import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/custom_font_weight.dart';

class CustomInputOTP extends StatefulWidget {
  final int length;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final String? errorText;
  final bool autoFocus;
  final TextInputType keyboardType;

  const CustomInputOTP({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.errorText,
    this.autoFocus = true,
    this.keyboardType = TextInputType.number,
  });

  @override
  State<CustomInputOTP> createState() => _CustomInputOTPState();
}

class _CustomInputOTPState extends State<CustomInputOTP>
    with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String _currentValue = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );

    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomInputOTP oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != null && oldWidget.errorText == null) {
      _hasError = true;
      _shakeController.forward().then((_) {
        _shakeController.reverse();
      });
    } else if (widget.errorText == null && oldWidget.errorText != null) {
      _hasError = false;
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    _updateCurrentValue();
  }

  void _updateCurrentValue() {
    _currentValue = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_currentValue);

    if (_currentValue.length == widget.length) {
      widget.onCompleted?.call(_currentValue);
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
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.length, (index) {
                  return Container(
                    width: 56,
                    height: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (_focusNodes[index].hasFocus && !_hasError)
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        if (_hasError)
                          BoxShadow(
                            color: theme.colorScheme.error.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: widget.keyboardType,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: CustomFontWeight.bold,
                        color:
                            _hasError
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                      ),
                      inputFormatters: [
                        if (widget.keyboardType == TextInputType.number)
                          FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.length > 1) {
                          // Si se pega texto, distribuir caracteres
                          final chars = value.split('');
                          for (
                            int i = 0;
                            i < chars.length && (index + i) < widget.length;
                            i++
                          ) {
                            _controllers[index + i].text = chars[i];
                          }
                          if ((index + value.length - 1) < widget.length) {
                            _focusNodes[index + value.length - 1]
                                .requestFocus();
                          }
                          _updateCurrentValue();
                        } else {
                          _onChanged(value, index);
                        }
                      },
                      onSubmitted: (value) {
                        if (index < widget.length - 1) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color:
                                _hasError
                                    ? theme.colorScheme.error.withOpacity(0.5)
                                    : theme.colorScheme.outline.withOpacity(
                                      0.3,
                                    ),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color:
                                _hasError
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.primary,
                            width: 2.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),

        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: CustomFontWeight.medium,
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
