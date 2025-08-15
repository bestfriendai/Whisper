import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:whisperdate/models/review.dart';
import 'package:whisperdate/models/user.dart';
import 'package:whisperdate/widgets/review_card.dart';
import 'package:whisperdate/widgets/shimmer_loading.dart';
import 'package:whisperdate/services/review_service.dart';
import 'package:whisperdate/theme.dart';
import 'package:provider/provider.dart';
import 'package:whisperdate/providers/app_state_provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'all';
  ViewType _viewType = ViewType.masonry;
  bool _isLoading = false;
  bool _isRefreshing = false;
  List<Review> _reviews = [];

  final List<CategoryFilter> _categoryFilters = [
    CategoryFilter(id: 'all', label: 'All'),
    CategoryFilter(id: 'recent', label: 'Recent'),
    CategoryFilter(id: 'popular', label: 'Popular'),
    CategoryFilter(id: 'nearby', label: 'Nearby'),
    CategoryFilter(id: 'helpful', label: 'Helpful'),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreReviews();
    }
  }

  Future<void> _loadReviews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Review> loadedReviews;
      
      switch (_selectedCategory) {
        case 'popular':
          loadedReviews = await ReviewService().getPopularReviews();
          break;
        case 'recent':
          loadedReviews = await ReviewService().getRecentReviews();
          break;
        case 'nearby':
          // For now, get recent reviews as nearby
          loadedReviews = await ReviewService().getRecentReviews();
          break;
        case 'helpful':
          loadedReviews = await ReviewService().getReviews(
            sortBy: 'stats.helpful',
            descending: true,
          );
          break;
        default:
          loadedReviews = await ReviewService().getReviews();
      }
      
      // Fallback to mock data if no reviews found
      if (loadedReviews.isEmpty) {
        loadedReviews = _generateMockReviews();
      }
      
      setState(() {
        _reviews = loadedReviews;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data on error
      final mockReviews = _generateMockReviews();
      
      setState(() {
        _reviews = mockReviews;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using demo data: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // For pagination, we would normally use startAfterDoc
      // For now, generate more mock reviews
      final moreReviews = _generateMockReviews(startIndex: _reviews.length);
      
      setState(() {
        _reviews.addAll(moreReviews);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final newReviews = _generateMockReviews();
      
      setState(() {
        _reviews = newReviews;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _onCategoryChanged(String category) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategory = category;
    });
    _loadReviews();
  }

  void _toggleViewType() {
    HapticFeedback.lightImpact();
    setState(() {
      _viewType = _viewType == ViewType.masonry ? ViewType.list : ViewType.masonry;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: theme.colorScheme.surface,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Ultra-Modern App Bar with Advanced Glassmorphism
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.background,
                        theme.colorScheme.background.withValues(alpha: 0.98),
                        theme.colorScheme.background.withValues(alpha: 0.92),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors.meshGradient1.createShader(
                                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                  ),
                                  child: Text(
                                    'WhisperDate',
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -1.2,
                                      height: 0.95,
                                      fontSize: 36,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.surface.withValues(alpha: 0.95),
                                        theme.colorScheme.surface.withValues(alpha: 0.85),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppColors.online.withValues(alpha: 0.4),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.online.withValues(alpha: 0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                        spreadRadius: -2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              AppColors.online,
                                              AppColors.online.withValues(alpha: 0.8),
                                              AppColors.online.withValues(alpha: 0.5),
                                            ],
                                            stops: [0.0, 0.7, 1.0],
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.online.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Fort Washington, MD',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _buildPremiumAction(
                                context,
                                _viewType == ViewType.masonry 
                                    ? Icons.view_list_rounded
                                    : Icons.apps_rounded,
                                _toggleViewType,
                              ),
                              const SizedBox(width: 16),
                              _buildPremiumAction(
                                context,
                                Icons.notifications_none_rounded,
                                () => Navigator.pushNamed(context, '/notifications'),
                                badgeCount: 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Ultra-Modern Category Filters
            SliverToBoxAdapter(
              child: Container(
                height: 64,
                margin: const EdgeInsets.only(bottom: 28),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _categoryFilters.length,
                  itemBuilder: (context, index) {
                    final filter = _categoryFilters[index];
                    final isSelected = filter.id == _selectedCategory;
                    
                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => _onCategoryChanged(filter.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected 
                                ? AppColors.primaryGradient
                                : LinearGradient(
                                    colors: [
                                      theme.colorScheme.surface.withValues(alpha: 0.9),
                                      theme.colorScheme.surface.withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isSelected 
                                  ? AppColors.primary.withValues(alpha: 0.6)
                                  : AppColors.neutral300.withValues(alpha: 0.8),
                              width: 1.2,
                            ),
                            boxShadow: [
                              if (isSelected) 
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                  spreadRadius: -2,
                                ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          child: Text(
                            filter.label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: isSelected ? 0.3 : 0.1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Reviews Content
            if (_isLoading && _reviews.isEmpty)
              SliverToBoxAdapter(
                child: _buildModernLoadingState(context),
              )
            else if (_reviews.isEmpty)
              SliverFillRemaining(
                child: _buildModernEmptyState(context),
              )
            else
              _viewType == ViewType.masonry
                  ? SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childCount: _reviews.length,
                        itemBuilder: (context, index) {
                          return ReviewCard(
                            review: _reviews[index],
                            viewType: _viewType,
                          );
                        },
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ReviewCard(
                                review: _reviews[index],
                                viewType: _viewType,
                              ),
                            );
                          },
                          childCount: _reviews.length,
                        ),
                      ),
                    ),
            
            // Modern Loading Indicator
            if (_isLoading && _reviews.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.neutral200,
                          width: 1,
                        ),
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
            
            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumAction(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    int badgeCount = 0,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.95),
              theme.colorScheme.surface.withValues(alpha: 0.85),
              theme.colorScheme.surface.withValues(alpha: 0.75),
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? AppColors.ultraGlassStroke.withValues(alpha: 0.4)
                : AppColors.glassStroke.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: theme.brightness == Brightness.dark ? 0.05 : 0.8),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: AppColors.neutral200,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.favorite_border_outlined,
                size: 48,
                color: AppColors.neutral400,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No reviews yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onBackground,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Be the first to share your dating experience\nand help others make better connections',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral500,
                height: 1.5,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Write First Review',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.neutral200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Review> _generateMockReviews({int startIndex = 0}) {
    final mockImageUrls = [
      'https://pixabay.com/get/gbcf11b36857f310d7b8c889e4db0d539794d90f2352eecc2d16f3133b0f032b99dc96593c9e05ebdf28aa3b98fad5ac8860e328d39eaf621c8bc76e4b8b04983_1280.jpg',
      'https://pixabay.com/get/gfb30d35ed8bb8bb832a6a02b05225958c07099729694baecc9eec2ad296c30f93fa144d722d71e58ae4dc0759b363ef9fe90e1d36808b6158d70be40213224d7_1280.jpg',
      'https://pixabay.com/get/ga356ae6cb08dc938557e9254f33594c8924148bf299b8f3af5d8755a4811da3d8ecf53f31588a1a6262f02f7d18c4a1dd40f67e8410d26739c8299d65e8309ed_1280.jpg',
      'https://pixabay.com/get/g2f14dd66c03899d8167934fd1ea68bd0fc353d832334522b8fa7d431f8b344e226c7ddd64ad1475034f92b824e0d0c036233effd1c6aa6a74f58dbab00ffcbdb_1280.jpg',
      'https://pixabay.com/get/g4ade1666b67597a71fd8b56f5ed1b4c7f9170d5b5b67402f264e88a6b652d7765014a19db9e4ed436e47cfdd1eaa2cbd0719cc890372881be0dab00587b95231_1280.jpg',
      'https://pixabay.com/get/g0dbdbd10d294197e5a53a60193fd3b2184bbbe287859f719e8db4f3821d98062dc4b5e2f957e4ffda5d3ea1ade1dcc823d118f3ee9aa131b67e9379f1e942b35_1280.jpg',
    ];
    
    return List.generate(10, (index) {
      final actualIndex = startIndex + index;
      final categories = [DatingPreference.women, DatingPreference.men, DatingPreference.lgbt];
      final genders = [Gender.male, Gender.female, Gender.other];
      final durations = DateDuration.values;
      final relationships = RelationshipType.values;
      
      return Review(
        id: 'review_\$actualIndex',
        authorId: 'user_\$actualIndex',
        subjectName: ['Alex', 'Jamie', 'Morgan', 'Casey', 'Riley'][actualIndex % 5],
        subjectAge: 22 + (actualIndex % 8),
        subjectGender: genders[actualIndex % genders.length],
        category: categories[actualIndex % categories.length],
        dateDuration: durations[actualIndex % durations.length],
        dateYear: 2024 - (actualIndex % 3),
        relationshipType: relationships[actualIndex % relationships.length],
        title: [
          'Coffee date turned into hours of great conversation',
          'Only talks about crypto - major red flag',
          'Such a thoughtful and genuine person',
          'Great dinner but zero chemistry',
          'Museum date was absolutely perfect',
          'Showed up 30 minutes late twice',
          'Amazing connection and great chemistry',
          'Too clingy and overwhelming for me',
          'Perfect theater date experience',
          'Rude to the server - immediate turnoff',
        ][actualIndex % 10],
        content: [
          'We went to this cute coffee shop downtown and ended up talking until they closed! Great sense of humor, asked thoughtful questions, and really seemed interested in getting to know me.',
          'The conversation was pretty one-sided - they dominated talking about investments and didn\'t really ask about my interests. Also kept checking their phone constantly.',
          'Such a refreshing change from the usual dating scene! They planned a thoughtful activity, were genuinely engaged, and we had amazing chemistry.',
          'Nice person and the restaurant was lovely, but we just didn\'t have that spark. Sometimes it just doesn\'t click and that\'s okay.',
          'They surprised me with tickets to an art exhibit I mentioned loving. We spent hours discussing different pieces and grabbed dinner after.',
          'Met at the park for a walk but they were constantly distracted by their phone and seemed more interested in getting photos than connecting.',
          'The chemistry was instant! Great conversation over dinner, then we walked around the city for hours just talking and laughing.',
          'Sweet person but the energy felt overwhelming. Multiple texts before our date, called me pet names immediately, and talked about future plans.',
        ][actualIndex % 8],
        rating: 3 + (actualIndex % 3),
        wouldRecommend: actualIndex % 3 != 0,
        greenFlags: _getGreenFlags(actualIndex),
        redFlags: _getRedFlags(actualIndex),
        imageUrls: actualIndex % 3 == 0 ? [mockImageUrls[actualIndex % mockImageUrls.length]] : [],
        location: Location(
          city: 'Fort Washington',
          state: 'MD',
          country: 'US',
          coords: Coordinates(lat: 38.7073, lng: -77.0365),
        ),
        stats: ReviewStats(
          likes: 10 + (actualIndex % 50),
          comments: actualIndex % 20,
          views: 100 + (actualIndex % 200),
          helpful: actualIndex % 15,
          notHelpful: actualIndex % 5,
        ),
        createdAt: DateTime.now().subtract(Duration(days: actualIndex % 30)),
        updatedAt: DateTime.now().subtract(Duration(days: actualIndex % 30)),
      );
    });
  }

  List<Flag> _getGreenFlags(int index) {
    switch (index % 8) {
      case 0:
        return [
          PredefinedFlags.greenFlags[0], // Good Communicator
          PredefinedFlags.greenFlags[2], // Funny
          PredefinedFlags.greenFlags[4], // Great Listener
        ];
      case 1:
        return [
          PredefinedFlags.greenFlags[1], // Respectful
          PredefinedFlags.greenFlags[6], // Romantic
        ];
      case 2:
        return [
          PredefinedFlags.greenFlags[3], // Honest
          PredefinedFlags.greenFlags[5], // Generous
          PredefinedFlags.greenFlags[8], // Supportive
        ];
      case 3:
        return [
          PredefinedFlags.greenFlags[7], // Adventurous
          PredefinedFlags.greenFlags[9], // Intelligent
        ];
      case 4:
        return [
          PredefinedFlags.greenFlags[0], // Good Communicator
          PredefinedFlags.greenFlags[1], // Respectful
          PredefinedFlags.greenFlags[3], // Honest
          PredefinedFlags.greenFlags[6], // Romantic
        ];
      case 5:
        return []; // No green flags
      case 6:
        return [
          PredefinedFlags.greenFlags[2], // Funny
          PredefinedFlags.greenFlags[4], // Great Listener
        ];
      case 7:
        return [
          PredefinedFlags.greenFlags[8], // Supportive
          PredefinedFlags.greenFlags[9], // Intelligent
          PredefinedFlags.greenFlags[5], // Generous
        ];
      default:
        return [];
    }
  }

  List<Flag> _getRedFlags(int index) {
    switch (index % 8) {
      case 0:
        return [];
      case 1:
        return [
          PredefinedFlags.redFlags[0], // Poor Communication
        ];
      case 2:
        return [];
      case 3:
        return [
          PredefinedFlags.redFlags[6], // Jealous/Possessive
          PredefinedFlags.redFlags[3], // Controlling
        ];
      case 4:
        return [];
      case 5:
        return [
          PredefinedFlags.redFlags[1], // Disrespectful
          PredefinedFlags.redFlags[4], // Unreliable
        ];
      case 6:
        return [
          PredefinedFlags.redFlags[7], // Anger Issues
        ];
      case 7:
        return [
          PredefinedFlags.redFlags[2], // Dishonest
          PredefinedFlags.redFlags[5], // Selfish
        ];
      default:
        return [];
    }
  }
}

class CategoryFilter {
  final String id;
  final String label;

  CategoryFilter({
    required this.id,
    required this.label,
  });
}