import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_modern.dart';

class ModernInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;
  final bool filled;
  final Color? fillColor;
  final bool showCounter;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool autoFocus;
  final TextCapitalization textCapitalization;
  
  const ModernInputField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.filled = true,
    this.fillColor,
    this.showCounter = false,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _focusAnimation;
  late Animation<double> _shakeAnimation;
  
  bool _isFocused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    
    _animationController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));
    
    _focusNode.addListener(_onFocusChange);
    
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else {
      _animationController.reverse();
    }
  }

  void _showError() {
    setState(() {
      _hasError = true;
    });
    
    _shakeController.forward().then((_) {
      _shakeController.reverse();
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _hasError = false;
          });
        }
      });
    });
    
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null || _hasError;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_focusAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 10 * (_shakeController.status == AnimationStatus.forward
                ? (1 - _shakeAnimation.value)
                : _shakeAnimation.value) * 
                ((_shakeAnimation.value * 4).floor() % 2 == 0 ? 1 : -1),
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              if (widget.label != null) ...[
                AnimatedDefaultTextStyle(
                  duration: ModernDuration.fast,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: _isFocused
                        ? ModernColors.primary
                        : hasError
                            ? ModernColors.error
                            : ModernColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(widget.label!),
                ),
                const SizedBox(height: ModernSpacing.sm),
              ],
              
              // Input Field Container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ModernRadius.input),
                  boxShadow: [
                    if (_isFocused && !hasError) ...ModernShadows.primary,
                    if (!_isFocused && !hasError) ...ModernShadows.small,
                    if (hasError) ...[
                      BoxShadow(
                        color: ModernColors.error.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ],
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    if (error != null && !_hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showError();
                      });
                    }
                    return error;
                  },
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  textInputAction: widget.textInputAction,
                  onFieldSubmitted: widget.onSubmitted,
                  textCapitalization: widget.textCapitalization,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    filled: widget.filled,
                    fillColor: widget.fillColor ?? 
                        (theme.isLight ? ModernColors.white : ModernColors.dark100),
                    
                    // Borders
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: BorderSide(
                        color: hasError 
                            ? ModernColors.error 
                            : ModernColors.gray200,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: BorderSide(
                        color: hasError 
                            ? ModernColors.error 
                            : ModernColors.gray200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: BorderSide(
                        color: hasError 
                            ? ModernColors.error 
                            : ModernColors.primary,
                        width: 2.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: const BorderSide(
                        color: ModernColors.error,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: const BorderSide(
                        color: ModernColors.error,
                        width: 2.5,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ModernRadius.input),
                      borderSide: const BorderSide(
                        color: ModernColors.gray300,
                        width: 1.0,
                      ),
                    ),
                    
                    // Content styling
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: ModernSpacing.lg,
                      vertical: ModernSpacing.md,
                    ),
                    
                    // Hint text
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: ModernColors.gray400,
                      fontWeight: FontWeight.w400,
                    ),
                    
                    // Icons
                    prefixIcon: widget.prefixIcon != null 
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: ModernSpacing.md,
                              right: ModernSpacing.sm,
                            ),
                            child: AnimatedContainer(
                              duration: ModernDuration.fast,
                              child: Icon(
                                widget.prefixIcon,
                                color: _isFocused
                                    ? ModernColors.primary
                                    : hasError
                                        ? ModernColors.error
                                        : ModernColors.gray400,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    
                    suffixIcon: widget.suffixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              right: ModernSpacing.md,
                            ),
                            child: widget.suffixIcon,
                          )
                        : null,
                    
                    // Remove default error text (we'll show it separately)
                    errorText: null,
                    
                    // Counter
                    counterText: widget.showCounter && widget.maxLength != null
                        ? null
                        : '',
                  ),
                ),
              ),
              
              // Helper/Error Text
              if (widget.helperText != null || widget.errorText != null) ...[
                const SizedBox(height: ModernSpacing.sm),
                AnimatedSwitcher(
                  duration: ModernDuration.fast,
                  child: Text(
                    widget.errorText ?? widget.helperText ?? '',
                    key: ValueKey(widget.errorText ?? widget.helperText),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: widget.errorText != null
                          ? ModernColors.error
                          : ModernColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// Modern Password Input Field with visibility toggle
class ModernPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool autoFocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const ModernPasswordField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.autoFocus = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<ModernPasswordField> createState() => _ModernPasswordFieldState();
}

class _ModernPasswordFieldState extends State<ModernPasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      label: widget.label,
      hint: widget.hint ?? 'Enter your password',
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscured,
      validator: widget.validator,
      onChanged: widget.onChanged,
      helperText: widget.helperText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      autoFocus: widget.autoFocus,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      prefixIcon: Icons.lock_outline_rounded,
      suffixIcon: IconButton(
        icon: AnimatedSwitcher(
          duration: ModernDuration.fast,
          child: Icon(
            _isObscured 
                ? Icons.visibility_outlined 
                : Icons.visibility_off_outlined,
            key: ValueKey(_isObscured),
            size: 20,
          ),
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
          HapticFeedback.selectionClick();
        },
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        splashRadius: 20,
      ),
    );
  }
}

// Modern Search Field
class ModernSearchField extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onClear;
  final bool enabled;
  final bool autoFocus;
  final FocusNode? focusNode;

  const ModernSearchField({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autoFocus = false,
    this.focusNode,
  });

  @override
  State<ModernSearchField> createState() => _ModernSearchFieldState();
}

class _ModernSearchFieldState extends State<ModernSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      controller: _controller,
      hint: widget.hint ?? 'Search...',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      autoFocus: widget.autoFocus,
      focusNode: widget.focusNode,
      prefixIcon: Icons.search_rounded,
      fillColor: Theme.of(context).colorScheme.surfaceVariant,
      suffixIcon: AnimatedScale(
        scale: _hasText ? 1.0 : 0.0,
        duration: ModernDuration.fast,
        curve: ModernCurves.easeOutQuart,
        child: IconButton(
          icon: const Icon(
            Icons.clear_rounded,
            size: 18,
          ),
          onPressed: _hasText ? _clear : null,
          color: ModernColors.gray500,
          splashRadius: 16,
        ),
      ),
    );
  }
}