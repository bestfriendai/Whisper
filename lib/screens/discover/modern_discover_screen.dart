import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../models/review.dart';
import '../../theme_modern.dart';
import '../../widgets/modern_review_card.dart';
import '../../services/review_service.dart';

class ModernDiscoverScreen extends StatefulWidget {
  const ModernDiscoverScreen({super.key});

  @override
  State<ModernDiscoverScreen> createState() => _ModernDiscoverScreenState();
}

class _ModernDiscoverScreenState extends State<ModernDiscoverScreen>
    with TickerProviderStateMixin {
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _searchController = TextEditingController();
  
  late AnimationController _filterController;
  late AnimationController _gridController;
  late Animation<double> _filterAnimation;
  late Animation<Offset> _gridSlideAnimation;
  
  List<Review> _reviews = [];
  List<String> _trendingTags = [];
  List<String> _selectedFilters = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All',
    'Dating',
    'Hookups',
    'Relationships',
    'Red Flags',
    'Green Flags',
  ];
  
  final List<FilterChip> _filters = [
    FilterChip(label: 'Recent', icon: Icons.access_time),
    FilterChip(label: 'Popular', icon: Icons.trending_up),
    FilterChip(label: 'Top Rated', icon: Icons.star),
    FilterChip(label: 'Verified', icon: Icons.verified),
    FilterChip(label: 'Photos', icon: Icons.photo),
  ];

  @override
  void initState() {
    super.initState();
    
    _filterController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _gridController = AnimationController(
      duration: ModernDuration.slow,
      vsync: this,
    );
    
    _filterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _gridSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _gridController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _loadContent();
  }

  @override
  void dispose() {
    _filterController.dispose();
    _gridController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    try {
      final reviews = await _reviewService.getDiscoverReviews();
      final tags = await _reviewService.getTrendingTags();
      
      if (mounted) {
        setState(() {
          _reviews = reviews;
          _trendingTags = tags;
          _isLoading = false;
        });
        
        _filterController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _gridController.forward();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    
    // Implement search logic here
    if (query.isEmpty) {
      _loadContent();
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    HapticFeedback.selectionClick();
    // Filter reviews by category
  }

  void _onFilterToggled(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
    HapticFeedback.lightImpact();
    // Apply filters
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safePadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // App bar with search
          _buildSearchAppBar(theme, safePadding),
          
          // Category tabs
          if (!_isLoading) _buildCategoryTabs(theme),
          
          // Filter chips
          if (!_isLoading) _buildFilterChips(theme),
          
          // Trending tags
          if (!_isLoading && !_isSearching) _buildTrendingTags(theme),
          
          // Results grid
          if (_isLoading)
            _buildLoadingGrid()
          else
            _buildResultsGrid(theme),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar(ThemeData theme, EdgeInsets safePadding) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.background,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: ModernSpacing.lg,
          right: ModernSpacing.lg,
          bottom: ModernSpacing.sm,
          top: safePadding.top + 40,
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(ModernRadius.full),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search reviews, users, tags...',
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: _isSearching
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: ModernSpacing.md,
                vertical: ModernSpacing.sm,
              ),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Filter options
          },
          icon: Icon(
            Icons.tune,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(ThemeData theme) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _filterAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _filterAnimation.value)),
            child: Opacity(
              opacity: _filterAnimation.value,
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(bottom: ModernSpacing.sm),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernSpacing.md,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return GestureDetector(
                      onTap: () => _onCategorySelected(category),
                      child: Container(
                        margin: const EdgeInsets.only(right: ModernSpacing.sm),
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
                          boxShadow: isSelected ? ModernShadows.small : null,
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _filterAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 40 * (1 - _filterAnimation.value)),
            child: Opacity(
              opacity: _filterAnimation.value,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: ModernSpacing.md),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ModernSpacing.md,
                  ),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilters.contains(filter.label);
                    
                    return GestureDetector(
                      onTap: () => _onFilterToggled(filter.label),
                      child: Container(
                        margin: const EdgeInsets.only(right: ModernSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: ModernSpacing.md,
                          vertical: ModernSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ModernColors.primary.withOpacity(0.1)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(ModernRadius.full),
                          border: Border.all(
                            color: isSelected
                                ? ModernColors.primary.withOpacity(0.3)
                                : theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              filter.icon,
                              size: 16,
                              color: isSelected
                                  ? ModernColors.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              filter.label,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? ModernColors.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingTags(ThemeData theme) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _filterAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _filterAnimation.value)),
            child: Opacity(
              opacity: _filterAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(
                  left: ModernSpacing.md,
                  right: ModernSpacing.md,
                  bottom: ModernSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Now',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: ModernSpacing.sm),
                    
                    Wrap(
                      spacing: ModernSpacing.xs,
                      runSpacing: ModernSpacing.xs,
                      children: _trendingTags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ModernSpacing.sm,
                            vertical: ModernSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ModernColors.secondary.withOpacity(0.1),
                                ModernColors.accent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(ModernRadius.full),
                            border: Border.all(
                              color: ModernColors.secondary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ModernColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsGrid(ThemeData theme) {
    return SlideTransition(
      position: _gridSlideAnimation,
      child: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.sm),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: ModernSpacing.sm,
          crossAxisSpacing: ModernSpacing.sm,
          childCount: _reviews.length,
          itemBuilder: (context, index) {
            final review = _reviews[index];
            
            return _MasonryReviewCard(
              review: review,
              onTap: () {
                HapticFeedback.selectionClick();
                // Navigate to review detail
              },
              onLike: () {
                // Handle like
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.sm),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: ModernSpacing.sm,
        crossAxisSpacing: ModernSpacing.sm,
        childCount: 10,
        itemBuilder: (context, index) {
          return _buildLoadingCard(index);
        },
      ),
    );
  }

  Widget _buildLoadingCard(int index) {
    // Random heights for masonry effect
    final heights = [200.0, 250.0, 180.0, 220.0, 190.0];
    final height = heights[index % heights.length];
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(ModernRadius.card),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ModernRadius.card),
        child: _ShimmerEffect(
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Custom masonry grid for Pinterest-style layout
class SliverMasonryGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int childCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const SliverMasonryGrid.count({
    super.key,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final columnIndex = index % crossAxisCount;
          final rowIndex = index ~/ crossAxisCount;
          
          return Padding(
            padding: EdgeInsets.only(
              left: columnIndex == 0 ? 0 : crossAxisSpacing / 2,
              right: columnIndex == crossAxisCount - 1 ? 0 : crossAxisSpacing / 2,
              bottom: mainAxisSpacing,
            ),
            child: itemBuilder(context, index),
          );
        },
        childCount: childCount,
      ),
    );
  }
}

// Masonry review card optimized for grid display
class _MasonryReviewCard extends StatefulWidget {
  final Review review;
  final VoidCallback? onTap;
  final VoidCallback? onLike;

  const _MasonryReviewCard({
    required this.review,
    this.onTap,
    this.onLike,
  });

  @override
  State<_MasonryReviewCard> createState() => _MasonryReviewCardState();
}

class _MasonryReviewCardState extends State<_MasonryReviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ModernCurves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
    HapticFeedback.lightImpact();
    widget.onLike?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(ModernRadius.card),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
                boxShadow: ModernShadows.small,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ModernRadius.card),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image if available
                    if (widget.review.imageUrls.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.network(
                          widget.review.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(ModernSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating
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
                                  widget.review.rating.toString(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: ModernSpacing.sm),
                          
                          // Title
                          Text(
                            widget.review.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: ModernSpacing.xs),
                          
                          // Content preview
                          Text(
                            widget.review.content,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: ModernSpacing.sm),
                          
                          // Actions
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _onLikeTap,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isLiked ? Icons.favorite : Icons.favorite_border,
                                      size: 16,
                                      color: _isLiked ? ModernColors.error : theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      widget.review.stats.likes.toString(),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: _isLiked ? ModernColors.error : theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: ModernSpacing.md),
                              
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.review.stats.comments.toString(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
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
          ),
        );
      },
    );
  }

  LinearGradient _getRatingGradient() {
    if (widget.review.rating >= 4) {
      return const LinearGradient(
        colors: [ModernColors.success, ModernColors.successDark],
      );
    } else if (widget.review.rating >= 3) {
      return const LinearGradient(
        colors: [ModernColors.warning, ModernColors.warningDark],
      );
    } else {
      return const LinearGradient(
        colors: [ModernColors.error, ModernColors.errorDark],
      );
    }
  }
}

// Filter chip model
class FilterChip {
  final String label;
  final IconData icon;

  FilterChip({
    required this.label,
    required this.icon,
  });
}

// Shimmer effect for loading
class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  
  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [
                math.max(0.0, _animation.value - 0.3),
                _animation.value,
                math.min(1.0, _animation.value + 0.3),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}