import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lockerroomtalk/theme/modern_theme.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/models/user.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';

enum ViewType { masonry, swipe, list }

class ModernHomeFeed extends StatefulWidget {
  const ModernHomeFeed({super.key});

  @override
  State<ModernHomeFeed> createState() => _ModernHomeFeedState();
}

class _ModernHomeFeedState extends State<ModernHomeFeed> 
    with TickerProviderStateMixin {
  ViewType _currentView = ViewType.masonry;
  String _selectedFilter = 'All';
  final PageController _swipeController = PageController(viewportFraction: 0.85);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<String> _filters = ['All', 'Recent', 'Popular', 'Following', 'Nearby'];
  
  // Sample data
  final List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateSampleReviews();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  void _generateSampleReviews() {
    final random = math.Random();
    final names = ['Emma Wilson', 'Alex Chen', 'Sarah Johnson', 'Mike Davis', 'Lisa Brown'];
    final locations = ['New York', 'Los Angeles', 'Chicago', 'San Francisco', 'Miami'];
    final activities = ['Coffee Date', 'Dinner', 'Beach Walk', 'Movie Night', 'Hiking'];
    
    for (int i = 0; i < 20; i++) {
      _reviews.add(Review(
        id: 'review_$i',
        authorId: 'user_$i',
        subjectName: names[random.nextInt(names.length)],
        subjectAge: 20 + random.nextInt(15),
        subjectGender: Gender.other,
        category: DatingPreference.all,
        dateDuration: DateDuration.oneHour,
        dateYear: DateTime.now().year,
        relationshipType: RelationshipType.casual,
        title: '${activities[random.nextInt(activities.length)]} Experience',
        content: 'Had an amazing time! Really enjoyed the conversation and the atmosphere was perfect. Would definitely recommend this place for a first date. The vibes were immaculate and everything went smoothly.',
        rating: 3 + random.nextInt(3),
        wouldRecommend: random.nextBool(),
        location: Location(
          city: locations[random.nextInt(locations.length)],
          state: 'State',
          country: 'USA',
        ),
        stats: ReviewStats(
          views: random.nextInt(1000),
          likes: random.nextInt(500),
          comments: random.nextInt(100),
          shares: random.nextInt(50),
          helpful: random.nextInt(200),
          notHelpful: random.nextInt(20),
        ),
        tags: ['FirstDate', 'Coffee', 'Romantic'],
        imageUrls: random.nextBool() 
          ? ['https://picsum.photos/400/${300 + random.nextInt(200)}'] 
          : [],
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        updatedAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _changeView(ViewType type) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentView = type;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildCurrentView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: ModernTheme.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Locker Room Talk',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: ModernTheme.primaryGradient,
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildViewToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildViewButton(
            icon: Icons.grid_view_rounded,
            type: ViewType.masonry,
            tooltip: 'Masonry',
          ),
          _buildViewButton(
            icon: Icons.style_rounded,
            type: ViewType.swipe,
            tooltip: 'Swipe',
          ),
          _buildViewButton(
            icon: Icons.format_list_bulleted_rounded,
            type: ViewType.list,
            tooltip: 'List',
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton({
    required IconData icon,
    required ViewType type,
    required String tooltip,
  }) {
    final isSelected = _currentView == type;
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _changeView(type),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? ModernTheme.primaryPink : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: ModernTheme.primaryPink.withOpacity(0.1),
              checkmarkColor: ModernTheme.primaryPink,
              labelStyle: TextStyle(
                color: isSelected ? ModernTheme.primaryPink : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? ModernTheme.primaryPink : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case ViewType.masonry:
        return _buildMasonryView();
      case ViewType.swipe:
        return _buildSwipeView();
      case ViewType.list:
        return _buildListView();
    }
  }

  Widget _buildMasonryView() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: _reviews.length,
          itemBuilder: (context, index) {
            return _buildMasonryCard(_reviews[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildMasonryCard(Review review, int index) {
    final hasImage = review.imageUrls.isNotEmpty;
    final cardHeight = hasImage 
        ? 280.0 + (index % 3 == 0 ? 50.0 : 0.0)
        : 200.0 + (index % 2 == 0 ? 30.0 : 0.0);
    
    return GestureDetector(
      onTap: () => _navigateToReviewDetail(review),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  review.imageUrls.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: ModernTheme.primaryPink,
                          child: Text(
                            review.isAnonymous ? 'A' : review.subjectName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.isAnonymous ? 'Anonymous' : review.subjectName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${review.location.city}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (review.wouldRecommend)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ModernTheme.success.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              size: 12,
                              color: ModernTheme.success,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        review.content,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildRatingStars(review.rating.toDouble()),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.favorite_outline, 
                              size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${review.stats.likes}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeView() {
    return PageView.builder(
      controller: _swipeController,
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: _buildSwipeCard(_reviews[index]),
        );
      },
    );
  }

  Widget _buildSwipeCard(Review review) {
    return GestureDetector(
      onTap: () => _navigateToReviewDetail(review),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ModernTheme.primaryPink.withOpacity(0.8),
              ModernTheme.primaryPurple.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ModernTheme.primaryPink.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (review.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  review.imageUrls.first,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: ModernTheme.primaryPink,
                        child: Text(
                          review.isAnonymous ? 'A' : review.subjectName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.isAnonymous ? 'Anonymous' : review.subjectName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${review.location.city} • ${_getTimeAgo(review.createdAt)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (review.wouldRecommend)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildRatingStars(review.rating.toDouble()),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ModernTheme.primaryPink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Coffee House',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ModernTheme.primaryPink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatChip(
                              Icons.favorite_outline,
                              '${review.stats.likes}',
                            ),
                            const SizedBox(width: 12),
                            _buildStatChip(
                              Icons.comment_outlined,
                              '${review.stats.comments}',
                            ),
                            const SizedBox(width: 12),
                            _buildStatChip(
                              Icons.share_outlined,
                              '${review.stats.shares}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildListCard(_reviews[index]),
        );
      },
    );
  }

  Widget _buildListCard(Review review) {
    return GestureDetector(
      onTap: () => _navigateToReviewDetail(review),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (review.imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    review.imageUrls.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: ModernTheme.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: ModernTheme.primaryPink,
                          child: Text(
                            review.isAnonymous ? 'A' : review.subjectName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            review.isAnonymous ? 'Anonymous' : review.subjectName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          _getTimeAgo(review.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildRatingStars(review.rating.toDouble(), size: 14),
                        const SizedBox(width: 8),
                        Text(
                          review.location.city,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.favorite_outline, 
                              size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${review.stats.likes}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.comment_outlined, 
                              size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${review.stats.comments}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
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

  Widget _buildRatingStars(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final halfFilled = index == rating.floor() && rating % 1 >= 0.5;
        
        return Icon(
          halfFilled ? Icons.star_half : Icons.star,
          size: size,
          color: filled || halfFilled ? Colors.amber : Colors.grey.shade300,
        );
      }),
    );
  }

  Widget _buildStatChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _navigateToReviewDetail(Review review) {
    HapticFeedback.lightImpact();
    // Navigate to review detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening review: ${review.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}