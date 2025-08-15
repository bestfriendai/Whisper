import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme_modern.dart';
import '../../widgets/modern_input_field.dart';
import '../../widgets/modern_buttons.dart';
import '../onboarding/onboarding_flow.dart';

class ModernSignUpScreen extends StatefulWidget {
  const ModernSignUpScreen({super.key});

  @override
  State<ModernSignUpScreen> createState() => _ModernSignUpScreenState();
}

class _ModernSignUpScreenState extends State<ModernSignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _agreeToTerms = false;
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
      duration: const Duration(seconds: 25),
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
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = 'Please agree to the Terms of Service and Privacy Policy';
      });
      HapticFeedback.notificationFeedback(NotificationFeedbackType.error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    HapticFeedback.mediumImpact();
    
    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final success = await appState.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        HapticFeedback.heavyImpact();
        // Navigate to onboarding flow
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                const OnboardingFlow(),
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
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Sign up failed. Please try again.';
        });
        HapticFeedback.notificationFeedback(NotificationFeedbackType.error);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Sign up failed: ${e.toString()}';
        });
        HapticFeedback.notificationFeedback(NotificationFeedbackType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
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
        // Navigate to onboarding flow for new users
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                const OnboardingFlow(),
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
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Google sign up failed. Please try again.';
        });
        HapticFeedback.notificationFeedback(NotificationFeedbackType.error);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Google sign up failed: ${e.toString()}';
        });
        HapticFeedback.notificationFeedback(NotificationFeedbackType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateBack() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ModernColors.secondaryGradient.colors.first.withOpacity(0.1),
                  ModernColors.accentGradient.colors.first.withOpacity(0.05),
                  theme.scaffoldBackgroundColor,
                  ModernColors.primaryGradient.colors.first.withOpacity(0.05),
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
              child: Column(
                children: [
                  _buildAppBar(theme),
                  Expanded(
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
                                  _buildSignUpCard(theme),
                                  const SizedBox(height: ModernSpacing.lg),
                                  _buildSignInLink(theme),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(ModernSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: _navigateBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: ModernShadows.small,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onSurface,
                size: 18,
              ),
            ),
          ),
        ],
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
            gradient: ModernColors.secondaryGradient,
            borderRadius: BorderRadius.circular(ModernRadius.xl),
            boxShadow: ModernShadows.large,
          ),
          child: Icon(
            Icons.person_add,
            size: 40,
            color: ModernColors.white,
          ),
        ),
        
        const SizedBox(height: ModernSpacing.lg),
        
        // Title
        Text(
          'Join WhisperDate',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -1.0,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: ModernSpacing.sm),
        
        // Subtitle
        Text(
          'Share your dating experiences and help others make better connections',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpCard(ThemeData theme) {
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
              
              // Google Sign Up (First)
              ModernSocialButton(
                text: 'Continue with Google',
                iconPath: 'https://developers.google.com/identity/images/g-logo.png',
                provider: ModernSocialProvider.google,
                onPressed: _isLoading ? null : _signUpWithGoogle,
                isLoading: _isLoading,
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
                hint: 'Create a password',
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.next,
                helperText: 'Password must be at least 6 characters',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please create a password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Confirm Password Field
              ModernPasswordField(
                label: 'Confirm Password',
                hint: 'Confirm your password',
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSubmitted: (_) => _signUpWithEmail(),
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: ModernSpacing.lg),
              
              // Terms Agreement
              GestureDetector(
                onTap: () {
                  setState(() {
                    _agreeToTerms = !_agreeToTerms;
                  });
                  HapticFeedback.selectionClick();
                },
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: ModernDuration.fast,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: _agreeToTerms 
                            ? ModernColors.primaryGradient 
                            : null,
                        color: _agreeToTerms 
                            ? null 
                            : Colors.transparent,
                        border: Border.all(
                          color: _agreeToTerms 
                              ? Colors.transparent 
                              : theme.colorScheme.outline,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _agreeToTerms
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: ModernColors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: ModernSpacing.sm),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: ModernColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: ModernColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: ModernSpacing.xl),
              
              // Sign Up Button
              ModernButton(
                text: 'Create Account',
                onPressed: _isLoading ? null : _signUpWithEmail,
                isLoading: _isLoading,
                size: ModernButtonSize.large,
                style: ModernButtonStyle.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: _isLoading ? null : _navigateBack,
          child: Text(
            'Sign In',
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