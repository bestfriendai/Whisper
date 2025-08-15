import 'package:flutter/material.dart';
import 'package:whisperdate/models/review.dart';
import 'package:whisperdate/models/user.dart';
import 'package:whisperdate/widgets/custom_text_field.dart';
import 'package:whisperdate/widgets/gradient_button.dart';
import 'package:whisperdate/widgets/enhanced_app_bar.dart';
import 'package:whisperdate/widgets/enhanced_loading.dart';
import 'package:whisperdate/services/review_service.dart';
import 'package:whisperdate/services/image_service.dart';
import 'package:whisperdate/theme.dart';
import 'package:provider/provider.dart';
import 'package:whisperdate/providers/app_state_provider.dart';
import 'package:uuid/uuid.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true;
  
  final PageController _pageController = PageController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectAgeController = TextEditingController();
  
  int _currentPage = 0;
  int _rating = 5;
  Gender? _subjectGender;
  DatingPreference? _category;
  DateDuration? _dateDuration;
  int? _dateYear;
  RelationshipType? _relationshipType;
  bool _wouldRecommend = true;
  
  List<Flag> _selectedGreenFlags = [];
  List<Flag> _selectedRedFlags = [];
  List<String> _imageUrls = [];
  
  late TabController _flagsTabController;
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    _flagsTabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _subjectNameController.dispose();
    _subjectAgeController.dispose();
    _flagsTabController.dispose();
    super.dispose();
  }
  
  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);
    
    try {
      final appState = context.read<AppStateProvider>();
      final currentUser = appState.currentUser;
      
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Create the review
      final review = Review(
        id: const Uuid().v4(), // Will be overridden by Firestore
        authorId: currentUser.id,
        subjectName: _subjectNameController.text.trim(),
        subjectAge: int.tryParse(_subjectAgeController.text),
        subjectGender: _subjectGender!,
        category: _category!,
        dateDuration: _dateDuration!,
        dateYear: _dateYear ?? DateTime.now().year,
        relationshipType: _relationshipType!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        rating: _rating,
        wouldRecommend: _wouldRecommend,
        greenFlags: _selectedGreenFlags,
        redFlags: _selectedRedFlags,
        imageUrls: _imageUrls,
        location: currentUser.location,
        stats: ReviewStats(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Submit the review
      final reviewId = await ReviewService().createReview(review);
      
      setState(() => _isSubmitting = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Review submitted successfully! 🎉'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                Navigator.pushNamed(context, '/review/$reviewId');
              },
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
  
  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _subjectNameController.text.isNotEmpty &&
               _subjectAgeController.text.isNotEmpty &&
               _subjectGender != null;
      case 1:
        return _category != null &&
               _dateDuration != null &&
               _relationshipType != null;
      case 2:
        return _titleController.text.isNotEmpty &&
               _contentController.text.isNotEmpty;
      case 3:
        return true; // Flags are optional
      case 4:
        return _rating > 0;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Share Your Experience',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentPage + 1} of 5',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(((_currentPage + 1) / 5) * 100).round()}% Complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final isActive = index <= _currentPage;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                        height: isActive ? 6 : 4,
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                )
                              : null,
                          color: isActive ? null : theme.colorScheme.outline.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          
          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildBasicInfoPage(theme),
                _buildDetailsPage(theme),
                _buildReviewPage(theme),
                _buildFlagsPage(theme),
                _buildRatingPage(theme),
              ],
            ),
          ),
          
          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 12),
                Expanded(
                  child: _currentPage < 4
                      ? FilledButton(
                          onPressed: _canProceed() ? _nextPage : null,
                          child: const Text('Continue'),
                        )
                      : GradientButton(
                          onPressed: _canProceed() ? _submitReview : null,
                          isLoading: _isSubmitting,
                          child: const Text('Share Experience'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBasicInfoPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.08),
                  theme.colorScheme.secondary.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Who are you reviewing?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral100,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tell us about your dating experience',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.neutral400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _subjectNameController,
            label: 'Their name or username',
            hintText: 'e.g., Alex, SportsFan23',
            prefixIcon: Icons.person,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _subjectAgeController,
            label: 'Age',
            hintText: 'e.g., 25',
            prefixIcon: Icons.cake,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Gender',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: Gender.values.map((gender) {
              final isSelected = _subjectGender == gender;
              return GestureDetector(
                onTap: () => setState(() => _subjectGender = gender),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          )
                        : null,
                    color: isSelected ? null : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(25),
                    border: isSelected
                        ? null
                        : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    gender.name.substring(0, 1).toUpperCase() + gender.name.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
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
  
  Widget _buildDetailsPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us more about your experience',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Sport Category
          _buildSelectionSection(
            theme,
            'Sport/Activity',
            DatingPreference.values.map((pref) {
              String label;
              String emoji;
              switch (pref) {
                case DatingPreference.all:
                  label = 'All Sports';
                  emoji = '🏃';
                  break;
                case DatingPreference.women:
                  label = 'Team Sports';
                  emoji = '⚽';
                  break;
                case DatingPreference.men:
                  label = 'Individual Sports';
                  emoji = '🎾';
                  break;
                case DatingPreference.lgbt:
                  label = 'Fitness/Gym';
                  emoji = '💪';
                  break;
              }
              return SelectionOption(
                value: pref,
                label: label,
                emoji: emoji,
              );
            }).toList(),
            _category,
            (value) => setState(() => _category = value),
          ),
          
          const SizedBox(height: 24),
          
          // Duration
          _buildSelectionSection(
            theme,
            'Activity Duration',
            DateDuration.values.map((duration) {
              String label;
              String emoji;
              switch (duration) {
                case DateDuration.oneHour:
                  label = '1 hour';
                  emoji = '⏱️';
                  break;
                case DateDuration.twoToThreeHours:
                  label = '2-3 hours';
                  emoji = '⏰';
                  break;
                case DateDuration.halfDay:
                  label = 'Half day';
                  emoji = '🌅';
                  break;
                case DateDuration.fullDay:
                  label = 'Full day';
                  emoji = '🌞';
                  break;
                case DateDuration.multiDay:
                  label = 'Multiple days';
                  emoji = '📅';
                  break;
              }
              return SelectionOption(
                value: duration,
                label: label,
                emoji: emoji,
              );
            }).toList(),
            _dateDuration,
            (value) => setState(() => _dateDuration = value),
          ),
          
          const SizedBox(height: 24),
          
          // Relationship Type
          _buildSelectionSection(
            theme,
            'Connection Type',
            RelationshipType.values.map((type) {
              String label;
              String emoji;
              switch (type) {
                case RelationshipType.workout:
                  label = 'Workout Partner';
                  emoji = '🏋️';
                  break;
                case RelationshipType.training:
                  label = 'Training Session';
                  emoji = '🎯';
                  break;
                case RelationshipType.game:
                  label = 'Game/Match';
                  emoji = '🏆';
                  break;
                case RelationshipType.casual:
                  label = 'Casual Activity';
                  emoji = '😊';
                  break;
              }
              return SelectionOption(
                value: type,
                label: label,
                emoji: emoji,
              );
            }).toList(),
            _relationshipType,
            (value) => setState(() => _relationshipType = value),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share Your Experience',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help others by sharing what happened',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _titleController,
            label: 'Title',
            hintText: 'e.g., Great workout partner!',
            prefixIcon: Icons.title,
            maxLines: 1,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _contentController,
            label: 'Your Experience',
            hintText: 'Share details about your sports activity together...',
            prefixIcon: Icons.edit,
            maxLines: 8,
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Writing Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Be honest and respectful\n• Focus on the sports activity\n• Mention what went well or could improve\n• Help others make informed decisions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFlagsPage(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlight Key Points',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What stood out? (Optional)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        Container(
          color: theme.colorScheme.surface,
          child: TabBar(
            controller: _flagsTabController,
            tabs: [
              Tab(text: 'Positive (${_selectedGreenFlags.length})'),
              Tab(text: 'Areas to Improve (${_selectedRedFlags.length})'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _flagsTabController,
            children: [
              _buildFlagSelection(theme, PredefinedFlags.greenFlags, _selectedGreenFlags, true),
              _buildFlagSelection(theme, PredefinedFlags.redFlags, _selectedRedFlags, false),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildFlagSelection(ThemeData theme, List<Flag> flags, List<Flag> selectedFlags, bool isGreen) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: flags.map((flag) {
          final isSelected = selectedFlags.contains(flag);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedFlags.remove(flag);
                } else {
                  selectedFlags.add(flag);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isGreen ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2))
                    : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (isGreen ? Colors.green : Colors.red)
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(flag.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    flag.label,
                    style: TextStyle(
                      color: isSelected
                          ? (isGreen ? Colors.green.shade700 : Colors.red.shade700)
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildRatingPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Rating',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How would you rate this experience overall?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          
          Center(
            child: Column(
              children: [
                Text(
                  _rating.toString(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _rating = index + 1),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_outline,
                          size: 40,
                          color: index < _rating ? Colors.amber : theme.colorScheme.outline,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  _getRatingText(_rating),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Would you connect with them again?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _wouldRecommend = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _wouldRecommend
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up,
                                color: _wouldRecommend ? Colors.white : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Yes',
                                style: TextStyle(
                                  color: _wouldRecommend ? Colors.white : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _wouldRecommend = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_wouldRecommend
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_down,
                                color: !_wouldRecommend ? Colors.white : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No',
                                style: TextStyle(
                                  color: !_wouldRecommend ? Colors.white : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectionSection<T>(
    ThemeData theme,
    String title,
    List<SelectionOption<T>> options,
    T? selectedValue,
    ValueChanged<T> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = selectedValue == option.value;
            return GestureDetector(
              onTap: () => onChanged(option.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        )
                      : null,
                  color: isSelected ? null : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected
                      ? null
                      : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(option.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor Experience';
      case 2:
        return 'Below Average';
      case 3:
        return 'Average';
      case 4:
        return 'Good Experience';
      case 5:
        return 'Excellent Experience';
      default:
        return '';
    }
  }
}

class SelectionOption<T> {
  final T value;
  final String label;
  final String emoji;
  
  SelectionOption({
    required this.value,
    required this.label,
    required this.emoji,
  });
}