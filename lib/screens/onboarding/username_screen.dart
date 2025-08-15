import 'package:flutter/material.dart';
import 'package:lockerroomtalk/screens/onboarding/onboarding_flow.dart';
import 'package:lockerroomtalk/widgets/gradient_button.dart';
import 'package:lockerroomtalk/widgets/custom_text_field.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isCheckingAvailability = false;
  bool _isAvailable = false;
  bool _hasChecked = false;
  
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> _suggestedUsernames = [
    'DateReviewer23',
    'HonestDater',
    'RealTalk2024',
    'TruthTeller',
    'DateWise',
  ];

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.length < 3) return;
    
    setState(() {
      _isCheckingAvailability = true;
      _hasChecked = false;
    });
    
    try {
      // TODO: Implement actual username availability check
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate some usernames being taken
      final takenUsernames = ['admin', 'test', 'user', 'moderator'];
      final isAvailable = !takenUsernames.contains(username.toLowerCase());
      
      setState(() {
        _isAvailable = isAvailable;
        _hasChecked = true;
        _isCheckingAvailability = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingAvailability = false;
        _hasChecked = false;
      });
    }
  }

  void _selectSuggestedUsername(String username) {
    _usernameController.text = username;
    _checkUsernameAvailability(username);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboarding = OnboardingProvider.of(context);
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000000),
            Color(0xFF1a0a1a),
            Color(0xFF2a1a2a),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(context, onboarding!),
              
              const SizedBox(height: 32),
              
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Username icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B5CF6),
                              Color(0xFFEC4899),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF8B5CF6),
                            Color(0xFFEC4899),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'Choose Username',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Your username will be visible when\nyou post reviews and comments.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Username form
                      Card(
                        color: Colors.white.withValues(alpha: 0.05),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomTextField(
                                  controller: _usernameController,
                                  label: 'Username',
                                  prefixIcon: Icons.alternate_email,
                                  suffixIcon: _isCheckingAvailability
                                      ? Container(
                                          width: 20,
                                          height: 20,
                                          padding: const EdgeInsets.all(12),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              theme.colorScheme.primary,
                                            ),
                                          ),
                                        )
                                      : _hasChecked
                                          ? Icon(
                                              _isAvailable ? Icons.check_circle : Icons.cancel,
                                              color: _isAvailable 
                                                  ? Colors.green 
                                                  : theme.colorScheme.error,
                                            )
                                          : null,
                                  onChanged: (value) {
                                    if (value.length >= 3) {
                                      // Debounce the availability check
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        if (_usernameController.text == value) {
                                          _checkUsernameAvailability(value);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _hasChecked = false;
                                        _isAvailable = false;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter a username';
                                    }
                                    if (value!.length < 3) {
                                      return 'Username must be at least 3 characters';
                                    }
                                    if (value.length > 20) {
                                      return 'Username must be less than 20 characters';
                                    }
                                    if (!RegExp(r'^[a-zA-Z0-9_]+\$').hasMatch(value)) {
                                      return 'Username can only contain letters, numbers, and underscores';
                                    }
                                    if (_hasChecked && !_isAvailable) {
                                      return 'Username is already taken';
                                    }
                                    return null;
                                  },
                                ),
                                
                                if (_hasChecked) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        _isAvailable ? Icons.check_circle : Icons.cancel,
                                        size: 16,
                                        color: _isAvailable 
                                            ? Colors.green 
                                            : theme.colorScheme.error,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isAvailable 
                                            ? 'Username is available!'
                                            : 'Username is already taken',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _isAvailable 
                                              ? Colors.green 
                                              : theme.colorScheme.error,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Suggested usernames
                      Text(
                        'Suggested usernames:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestedUsernames.map((username) {
                          return ActionChip(
                            label: Text(username),
                            onPressed: () => _selectSuggestedUsername(username),
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Username guidelines
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: const Color(0xFF8B5CF6),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Username Guidelines',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: const Color(0xFF8B5CF6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• 3-20 characters long\n• Letters, numbers, and underscores only\n• Cannot be changed later\n• Keep it respectful',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Navigation buttons
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GradientButton(
                      onPressed: (_hasChecked && _isAvailable && _usernameController.text.isNotEmpty)
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                onboarding.completeOnboarding();
                              }
                            }
                          : null,
                      child: Text(
                        'Complete Setup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: (_hasChecked && _isAvailable && _usernameController.text.isNotEmpty)
                              ? Colors.white 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    TextButton(
                      onPressed: onboarding.previousPage,
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, OnboardingProvider onboarding) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboarding.totalPages,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == onboarding.currentPage
                ? const Color(0xFF8B5CF6)
                : Colors.white30,
          ),
        ),
      ),
    );
  }
}