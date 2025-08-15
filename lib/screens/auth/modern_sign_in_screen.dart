import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme_modern.dart';
import '../../widgets/modern_input_field.dart';
import '../../widgets/modern_buttons.dart';
import '../../widgets/modern_loading_states.dart';
import 'modern_sign_up_screen.dart';

class ModernSignInScreen extends StatefulWidget {
  final VoidCallback? onGuestMode;
  
  const ModernSignInScreen({super.key, this.onGuestMode});

  @override
  State<ModernSignInScreen> createState() => _ModernSignInScreenState();
}

class _ModernSignInScreenState extends State<ModernSignInScreen>
    with TickerProviderStateMixin {
  
  // Helper function to safely trigger haptic feedback on non-web platforms
  void _triggerHapticFeedback([String type = 'error']) {
    if (!kIsWeb) {
      try {
        switch (type) {
          case 'error':
            HapticFeedback.heavyImpact();
            break;
          case 'selection':
          default:
            HapticFeedback.selectionClick();
            break;
        }
      } catch (e) {
        // Silently ignore haptic feedback errors
      }
    }
  }
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isLoading = false;
  String? _errorMessage;
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController, 
      curve: ModernCurves.easeOutQuart,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController, 
      curve: Curves.easeInOut,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _backgroundController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    HapticFeedback.mediumImpact();
    
    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final success = await appState.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        HapticFeedback.heavyImpact();
        // Navigation is handled by AuthWrapper
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Sign in failed. Please check your credentials.';
        });
        _triggerHapticFeedback('error');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Sign in failed: ${e.toString()}';
        });
        _triggerHapticFeedback('error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    HapticFeedback.mediumImpact();
    
    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final success = await appState.signInWithGoogle();
      
      if (success && mounted) {
        HapticFeedback.heavyImpact();
        // Navigation is handled by AuthWrapper
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Google sign in failed. Please try again.';
        });
        _triggerHapticFeedback('error');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Google sign in failed: ${e.toString()}';
        });
        _triggerHapticFeedback('error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _continueAsGuest() {
    HapticFeedback.selectionClick();
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.continueAsGuest();
  }

  void _navigateToSignUp() {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const ModernSignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: ModernCurves.easeOutQuart,
            )),
            child: child,
          );
        },
        transitionDuration: ModernDuration.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ModernColors.primaryGradient.colors.first.withOpacity(0.1),
                  ModernColors.secondaryGradient.colors.first.withOpacity(0.05),
                  theme.scaffoldBackgroundColor,
                  ModernColors.accentGradient.colors.first.withOpacity(0.05),
                ],
                stops: [
                  0.0 + (_backgroundAnimation.value * 0.1),
                  0.3 + (_backgroundAnimation.value * 0.1),
                  0.7 + (_backgroundAnimation.value * 0.1),
                  1.0,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(ModernSpacing.screenPadding),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(theme),
                            const SizedBox(height: ModernSpacing.xxxl),
                            _buildSignInCard(theme),
                            const SizedBox(height: ModernSpacing.xl),
                            _buildGuestOption(theme),
                            const SizedBox(height: ModernSpacing.lg),
                            _buildSignUpLink(theme),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: ModernColors.instagramGradient,
            borderRadius: BorderRadius.circular(ModernRadius.xl),
            boxShadow: ModernShadows.large,
          ),
          child: Icon(
            Icons.favorite,
            size: 40,
            color: ModernColors.white,
          ),
        ),
        
        const SizedBox(height: ModernSpacing.lg),
        
        // App Name
        ShaderMask(
          shaderCallback: (bounds) => ModernColors.instagramGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'WhisperDate',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ),
        
        const SizedBox(height: ModernSpacing.sm),
        
        // Tagline
        Text(
          'Honest dating reviews & real experiences',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignInCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: theme.isLight 
            ? ModernColors.surfaceGradient
            : ModernColors.surfaceGradientDark,
        borderRadius: BorderRadius.circular(ModernRadius.card),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: ModernShadows.large,
      ),
      child: Padding(
        padding: const EdgeInsets.all(ModernSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              Text(
                'Welcome Back',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ModernSpacing.xs),
              
              Text(
                'Sign in to continue your journey',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ModernSpacing.xl),
              
              // Error Message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(ModernSpacing.md),
                  decoration: BoxDecoration(
                    color: ModernColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernRadius.md),
                    border: Border.all(
                      color: ModernColors.error.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: ModernColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: ModernSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ModernColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ModernSpacing.lg),
              ],
              
              // Email Field
              ModernInputField(
                label: 'Email Address',
                hint: 'Enter your email',
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Password Field
              ModernPasswordField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSubmitted: (_) => _signInWithEmail(),
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: ModernSpacing.sm),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () {
                    // TODO: Implement forgot password
                    HapticFeedback.selectionClick();
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: ModernColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Sign In Button
              ModernButton(
                text: 'Sign In',
                onPressed: _isLoading ? null : _signInWithEmail,
                isLoading: _isLoading,
                size: ModernButtonSize.large,
                style: ModernButtonStyle.primary,
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.md),
                    child: Text(
                      'OR',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Google Sign In
              ModernSocialButton(
                text: 'Continue with Google',
                iconPath: 'https://developers.google.com/identity/images/g-logo.png',
                provider: ModernSocialProvider.google,
                onPressed: _isLoading ? null : _signInWithGoogle,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestOption(ThemeData theme) {
    return ModernButton(
      text: 'Browse as Guest',
      onPressed: _isLoading ? null : _continueAsGuest,
      size: ModernButtonSize.large,
      style: ModernButtonStyle.outlined,
      icon: Icons.visibility_outlined,
    );
  }

  Widget _buildSignUpLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: _isLoading ? null : _navigateToSignUp,
          child: Text(
            'Sign Up',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ModernColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}