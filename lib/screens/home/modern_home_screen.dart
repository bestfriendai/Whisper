import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:lockerroomtalk/theme/modern_theme.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/models/user.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;
  
  // Sample data
  final List<Review> _reviews = _generateSampleReviews();
  final List<String> _categories = ['All', 'Trending', 'Recent', 'Top Rated', 'Near You'];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _pulseAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  static List<Review> _generateSampleReviews() {
    return [
      Review(
        id: '1',
        authorId: 'user1',
        subjectName: 'Alexandra Chen',
        subjectAge: 28,
        subjectGender: Gender.female,
        category: DatingPreference.women,
        dateDuration: DateDuration.twoToThreeHours,
        dateYear: 2024,
        relationshipType: RelationshipType.casual,
        title: 'Amazing coffee date experience!',
        content: 'We met at this cozy coffee shop downtown. Great conversation, lots of laughs, and she has an amazing sense of humor. Highly recommend!',
        rating: 5,
        wouldRecommend: true,
        location: Location(
          city: 'San Francisco',
          state: 'CA',
          country: 'US',
        ),
        stats: ReviewStats(likes: 234, comments: 45, views: 1203),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['Coffee Date', 'Great Conversation', 'Funny'],
        imageUrls: ['https://images.unsplash.com/photo-1494790108377-be9c29b29330'],
      ),
      Review(
        id: '2',
        authorId: 'user2',
        subjectName: 'Michael Torres',
        subjectAge: 32,
        subjectGender: Gender.male,
        category: DatingPreference.men,
        dateDuration: DateDuration.halfDay,
        dateYear: 2024,
        relationshipType: RelationshipType.casual,
        title: 'Perfect dinner date!',
        content: 'Took me to this amazing Italian restaurant. He was a perfect gentleman, great listener, and we connected on so many levels.',
        rating: 5,
        wouldRecommend: true,
        location: Location(
          city: 'New York',
          state: 'NY',
          country: 'US',
        ),
        stats: ReviewStats(likes: 189, comments: 32, views: 890),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['Dinner', 'Romantic', 'Gentleman'],
        imageUrls: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'],
      ),
      Review(
        id: '3',
        authorId: 'user3',
        subjectName: 'Sophie Martinez',
        subjectAge: 26,
        subjectGender: Gender.female,
        category: DatingPreference.women,
        dateDuration: DateDuration.oneHour,
        dateYear: 2024,
        relationshipType: RelationshipType.casual,
        title: 'Fun activity date!',
        content: 'We went mini golfing and had a blast! She\'s super competitive but in a fun way. Great energy and positivity.',
        rating: 4,
        wouldRecommend: true,
        location: Location(
          city: 'Los Angeles',
          state: 'CA',
          country: 'US',
        ),
        stats: ReviewStats(likes: 156, comments: 28, views: 723),
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        tags: ['Activity', 'Fun', 'Energetic'],
        imageUrls: ['https://images.unsplash.com/photo-1438761681033-6461ffad8d80'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ModernTheme.lightBackground,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategoryChips(),
              _buildStatsCards(),
              _buildReviewCards(),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: ModernTheme.primaryGradient,
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
              Text(
                'Real dating experiences',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIcon(Icons.search_rounded, () {
                // Handle search
              }),
              const SizedBox(width: 12),
              _buildHeaderIcon(Icons.notifications_outlined, () {
                // Handle notifications
              }, showBadge: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap, {bool showBadge = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                color: Colors.grey.shade700,
                size: 24,
              ),
            ),
            if (showBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ModernTheme.primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(colors: ModernTheme.primaryGradient)
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: ModernTheme.primaryPink.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildStatCard(
            icon: Icons.favorite_rounded,
            value: '2.3K',
            label: 'Matches',
            gradient: ModernTheme.primaryGradient,
          ),
          _buildStatCard(
            icon: Icons.star_rounded,
            value: '4.8',
            label: 'Avg Rating',
            gradient: ModernTheme.warmGradient,
          ),
          _buildStatCard(
            icon: Icons.trending_up_rounded,
            value: '89%',
            label: 'Success Rate',
            gradient: ModernTheme.coolGradient,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> gradient,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCards() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0;
              if (_pageController.position.haveDimensions) {
                value = index - (_pageController.page ?? 0);
                value = (value * 0.038).clamp(-1, 1);
              }
              return Center(
                child: Transform.rotate(
                  angle: math.pi * value,
                  child: _buildReviewCard(_reviews[index], index == _currentIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(Review review, bool isActive) {
    return GestureDetector(
      onTap: () {
        // Navigate to review detail
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? ModernTheme.primaryPink.withOpacity(0.2)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isActive ? 30 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ModernTheme.primaryPink.withOpacity(0.3),
                          ModernTheme.primaryPurple.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: review.imageUrls.isNotEmpty
                        ? Image.network(
                            review.imageUrls.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 80,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            review.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Name and age
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${review.subjectName}, ${review.subjectAge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${review.location.city}, ${review.location.state}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.content,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    if (review.tags != null && review.tags!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: review.tags!.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ModernTheme.primaryPink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: ModernTheme.primaryPink,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      children: [
                        _buildStatIcon(
                          Icons.favorite_outline_rounded,
                          review.stats.likes.toString(),
                        ),
                        const SizedBox(width: 20),
                        _buildStatIcon(
                          Icons.chat_bubble_outline_rounded,
                          review.stats.comments.toString(),
                        ),
                        const SizedBox(width: 20),
                        _buildStatIcon(
                          Icons.remove_red_eye_outlined,
                          review.stats.views.toString(),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.bookmark_outline_rounded),
                          onPressed: () {
                            // Handle bookmark
                          },
                        ),
                      ],
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

  Widget _buildStatIcon(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', true),
          _buildNavItem(Icons.explore_rounded, 'Explore', false),
          _buildFloatingActionButton(),
          _buildNavItem(Icons.chat_rounded, 'Chat', false),
          _buildNavItem(Icons.person_rounded, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        // Handle navigation
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? ModernTheme.primaryPink : Colors.grey.shade400,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? ModernTheme.primaryPink : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: ModernTheme.primaryGradient,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ModernTheme.primaryPink.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                // Handle create review
              },
            ),
          ),
        );
      },
    );
  }
}