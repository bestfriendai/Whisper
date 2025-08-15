import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/review.dart';
import '../../theme_modern.dart';
import '../../widgets/modern_input_field.dart';
import '../../services/review_service.dart';
import '../../services/image_service.dart';

class ModernCreateReview extends StatefulWidget {
  const ModernCreateReview({super.key});

  @override
  State<ModernCreateReview> createState() => _ModernCreateReviewState();
}

class _ModernCreateReviewState extends State<ModernCreateReview>
    with TickerProviderStateMixin {
  final ReviewService _reviewService = ReviewService();
  final ImageService _imageService = ImageService();
  
  late AnimationController _progressController;
  late AnimationController _slideController;
  late PageController _pageController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Form controllers
  final _subjectNameController = TextEditingController();
  final _subjectAgeController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  // Form state
  int _currentStep = 0;
  int _rating = 0;
  String _category = 'Dating';
  List<String> _selectedGreenFlags = [];
  List<String> _selectedRedFlags = [];
  List<String> _selectedImages = [];
  bool _isSubmitting = false;
  
  final List<String> _steps = [
    'Basic Info',
    'Rating',
    'Details',
    'Flags',
    'Photos',
    'Review',
  ];
  
  final List<String> _categories = [
    'Dating',
    'Hookup',
    'Relationship',
    'Other',
  ];
  
  final List<FlagOption> _greenFlagOptions = [
    FlagOption('Good Communication', Icons.chat_bubble),
    FlagOption('Respectful', Icons.favorite),
    FlagOption('Funny', Icons.sentiment_very_satisfied),
    FlagOption('Attractive', Icons.star),
    FlagOption('Reliable', Icons.verified),
    FlagOption('Good Listener', Icons.hearing),
    FlagOption('Ambitious', Icons.trending_up),
    FlagOption('Kind', Icons.volunteer_activism),
  ];
  
  final List<FlagOption> _redFlagOptions = [
    FlagOption('Poor Communication', Icons.chat_bubble_outline),
    FlagOption('Disrespectful', Icons.report),
    FlagOption('Aggressive', Icons.warning),
    FlagOption('Unreliable', Icons.schedule),
    FlagOption('Dishonest', Icons.block),
    FlagOption('Self-centered', Icons.person_off),
    FlagOption('Controlling', Icons.lock),
    FlagOption('Inappropriate', Icons.dangerous),
  ];

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _pageController = PageController();
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ModernCurves.easeInOutQuart,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    _subjectNameController.dispose();
    _subjectAgeController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      
      _progressController.animateTo(_currentStep / (_steps.length - 1));
      
      _pageController.nextPage(
        duration: ModernDuration.normal,
        curve: ModernCurves.easeInOutQuart,
      );
      
      HapticFeedback.lightImpact();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      
      _progressController.animateTo(_currentStep / (_steps.length - 1));
      
      _pageController.previousPage(
        duration: ModernDuration.normal,
        curve: ModernCurves.easeInOutQuart,
      );
      
      HapticFeedback.lightImpact();
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _subjectNameController.text.isNotEmpty &&
               _subjectAgeController.text.isNotEmpty;
      case 1:
        return _rating > 0;
      case 2:
        return _titleController.text.isNotEmpty &&
               _contentController.text.isNotEmpty;
      case 3:
        return true; // Flags are optional
      case 4:
        return true; // Photos are optional
      case 5:
        return true; // Review step
      default:
        return false;
    }
  }

  Future<void> _submitReview() async {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: 'current_user_id', // Get from auth service
        subjectName: _subjectNameController.text,
        subjectAge: int.parse(_subjectAgeController.text),
        title: _titleController.text,
        content: _contentController.text,
        rating: _rating,
        category: ReviewCategory.values.firstWhere(
          (c) => c.toString().split('.').last.toLowerCase() == _category.toLowerCase(),
        ),
        greenFlags: _selectedGreenFlags.map((flag) => Flag(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: flag,
          type: FlagType.green,
        )).toList(),
        redFlags: _selectedRedFlags.map((flag) => Flag(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: flag,
          type: FlagType.red,
        )).toList(),
        imageUrls: _selectedImages,
        stats: ReviewStats(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _reviewService.createReview(review);
      
      if (mounted) {
        HapticFeedback.heavyImpact();
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Review posted successfully!'),
            backgroundColor: ModernColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ModernRadius.md),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to post review. Please try again.'),
            backgroundColor: ModernColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ModernRadius.md),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safePadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                left: ModernSpacing.sm,
                right: ModernSpacing.lg,
                top: safePadding.top + ModernSpacing.sm,
                bottom: ModernSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Create Review',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_currentStep + 1} of ${_steps.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (_currentStep == _steps.length - 1)
                    _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton(
                            onPressed: _submitReview,
                            child: Text(
                              'Post',
                              style: TextStyle(
                                color: ModernColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                ],
              ),
            ),
            
            // Progress indicator
            _buildProgressIndicator(theme),
            
            // Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                  _progressController.animateTo(index / (_steps.length - 1));
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildStepContent(index, theme);
                },
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(theme, safePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        children: [
          // Steps indicator
          Row(
            children: _steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isActive = index <= _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: isActive ? ModernColors.primaryGradient : null,
                              color: isActive ? null : theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                              border: isActive
                                  ? null
                                  : Border.all(
                                      color: theme.colorScheme.outline.withOpacity(0.2),
                                    ),
                            ),
                            child: Center(
                              child: isActive
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isActive
                                  ? ModernColors.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (index < _steps.length - 1)
                      Container(
                        width: 20,
                        height: 2,
                        color: isActive
                            ? ModernColors.primary
                            : theme.colorScheme.outline.withOpacity(0.2),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: ModernSpacing.md),
          
          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(ModernColors.primary),
                minHeight: 4,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step, ThemeData theme) {
    switch (step) {
      case 0:
        return _buildBasicInfoStep(theme);
      case 1:
        return _buildRatingStep(theme);
      case 2:
        return _buildDetailsStep(theme);
      case 3:
        return _buildFlagsStep(theme);
      case 4:
        return _buildPhotosStep(theme);
      case 5:
        return _buildReviewStep(theme);
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about them',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Basic information about the person you\'re reviewing.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          ModernInputField(
            controller: _subjectNameController,
            label: 'First Name',
            hintText: 'Enter their first name',
            prefixIcon: Icons.person_outline,
          ),
          
          const SizedBox(height: ModernSpacing.lg),
          
          ModernInputField(
            controller: _subjectAgeController,
            label: 'Age',
            hintText: 'Enter their age',
            prefixIcon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: ModernSpacing.lg),
          
          Text(
            'Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          
          Wrap(
            spacing: ModernSpacing.sm,
            runSpacing: ModernSpacing.sm,
            children: _categories.map((category) {
              final isSelected = category == _category;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _category = category;
                  });
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernSpacing.lg,
                    vertical: ModernSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? ModernColors.primaryGradient : null,
                    color: isSelected ? null : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(ModernRadius.full),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How would you rate them?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Give an overall rating based on your experience.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: ModernSpacing.xxxl),
          
          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final isSelected = index < _rating;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 48,
                    color: isSelected ? ModernColors.warning : theme.colorScheme.outline,
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: ModernSpacing.lg),
          
          if (_rating > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ModernSpacing.lg,
                vertical: ModernSpacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: _getRatingGradient(),
                borderRadius: BorderRadius.circular(ModernRadius.full),
              ),
              child: Text(
                _getRatingText(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share your experience',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Write a detailed review about your experience.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          ModernInputField(
            controller: _titleController,
            label: 'Title',
            hintText: 'Give your review a catchy title',
            prefixIcon: Icons.title,
          ),
          
          const SizedBox(height: ModernSpacing.lg),
          
          ModernInputField(
            controller: _contentController,
            label: 'Your Review',
            hintText: 'Share details about your experience...',
            prefixIcon: Icons.edit_outlined,
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildFlagsStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Highlights & Concerns',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Select the green and red flags that apply.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          // Green flags
          Text(
            'Green Flags ✅',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: ModernColors.success,
            ),
          ),
          const SizedBox(height: ModernSpacing.md),
          
          Wrap(
            spacing: ModernSpacing.sm,
            runSpacing: ModernSpacing.sm,
            children: _greenFlagOptions.map((flag) {
              final isSelected = _selectedGreenFlags.contains(flag.name);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedGreenFlags.remove(flag.name);
                    } else {
                      _selectedGreenFlags.add(flag.name);
                    }
                  });
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernSpacing.md,
                    vertical: ModernSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ModernColors.success.withOpacity(0.1)
                        : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(ModernRadius.full),
                    border: Border.all(
                      color: isSelected
                          ? ModernColors.success
                          : theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        flag.icon,
                        size: 16,
                        color: isSelected
                            ? ModernColors.success
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        flag.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? ModernColors.success
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          // Red flags
          Text(
            'Red Flags 🚩',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: ModernColors.error,
            ),
          ),
          const SizedBox(height: ModernSpacing.md),
          
          Wrap(
            spacing: ModernSpacing.sm,
            runSpacing: ModernSpacing.sm,
            children: _redFlagOptions.map((flag) {
              final isSelected = _selectedRedFlags.contains(flag.name);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedRedFlags.remove(flag.name);
                    } else {
                      _selectedRedFlags.add(flag.name);
                    }
                  });
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernSpacing.md,
                    vertical: ModernSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ModernColors.error.withOpacity(0.1)
                        : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(ModernRadius.full),
                    border: Border.all(
                      color: isSelected
                          ? ModernColors.error
                          : theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        flag.icon,
                        size: 16,
                        color: isSelected
                            ? ModernColors.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        flag.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? ModernColors.error
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Photos (Optional)',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Add photos to make your review more engaging.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          // Photo upload area
          GestureDetector(
            onTap: () async {
              // Handle photo selection
              final images = await _imageService.pickImages();
              if (images != null) {
                setState(() {
                  _selectedImages.addAll(images);
                });
              }
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(ModernRadius.card),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: ModernSpacing.sm),
                    Text(
                      'Tap to add photos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Up to 5 photos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Selected photos
          if (_selectedImages.isNotEmpty) ...[
            const SizedBox(height: ModernSpacing.lg),
            Text(
              'Selected Photos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ModernSpacing.sm),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: ModernSpacing.sm,
                mainAxisSpacing: ModernSpacing.sm,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(ModernRadius.md),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ModernRadius.md),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.image,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
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
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Post',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: ModernSpacing.sm),
          Text(
            'Make sure everything looks good before posting.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: ModernSpacing.xl),
          
          // Review preview card
          Container(
            padding: const EdgeInsets.all(ModernSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(ModernRadius.card),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
              ),
              boxShadow: ModernShadows.small,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ModernSpacing.sm,
                        vertical: ModernSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(ModernRadius.sm),
                      ),
                      child: Text(
                        '${_subjectNameController.text}, ${_subjectAgeController.text}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ModernSpacing.sm,
                        vertical: ModernSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        gradient: _getRatingGradient(),
                        borderRadius: BorderRadius.circular(ModernRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _rating.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: ModernSpacing.md),
                
                // Title
                Text(
                  _titleController.text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: ModernSpacing.sm),
                
                // Content
                Text(
                  _contentController.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                
                // Flags
                if (_selectedGreenFlags.isNotEmpty || _selectedRedFlags.isNotEmpty) ...[
                  const SizedBox(height: ModernSpacing.md),
                  
                  if (_selectedGreenFlags.isNotEmpty) ...[
                    Wrap(
                      spacing: ModernSpacing.xs,
                      runSpacing: ModernSpacing.xs,
                      children: _selectedGreenFlags.take(3).map((flag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ModernSpacing.sm,
                            vertical: ModernSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: ModernColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ModernRadius.full),
                            border: Border.all(
                              color: ModernColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            flag,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ModernColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: ModernSpacing.xs),
                  ],
                  
                  if (_selectedRedFlags.isNotEmpty) ...[
                    Wrap(
                      spacing: ModernSpacing.xs,
                      runSpacing: ModernSpacing.xs,
                      children: _selectedRedFlags.take(3).map((flag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ModernSpacing.sm,
                            vertical: ModernSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: ModernColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ModernRadius.full),
                            border: Border.all(
                              color: ModernColors.error.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            flag,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ModernColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
                
                // Photo count
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: ModernSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ModernSpacing.sm,
                      vertical: ModernSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(ModernRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_selectedImages.length} photo${_selectedImages.length != 1 ? 's' : ''}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme, EdgeInsets safePadding) {
    if (_currentStep == _steps.length - 1) {
      return const SizedBox.shrink(); // Hide navigation buttons on review step
    }
    
    return Container(
      padding: EdgeInsets.only(
        left: ModernSpacing.lg,
        right: ModernSpacing.lg,
        top: ModernSpacing.md,
        bottom: ModernSpacing.md + safePadding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Back'),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: ModernSpacing.md),
          
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getRatingGradient() {
    if (_rating >= 4) {
      return const LinearGradient(
        colors: [ModernColors.success, ModernColors.successDark],
      );
    } else if (_rating >= 3) {
      return const LinearGradient(
        colors: [ModernColors.warning, ModernColors.warningDark],
      );
    } else {
      return const LinearGradient(
        colors: [ModernColors.error, ModernColors.errorDark],
      );
    }
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}

class FlagOption {
  final String name;
  final IconData icon;

  FlagOption(this.name, this.icon);
}