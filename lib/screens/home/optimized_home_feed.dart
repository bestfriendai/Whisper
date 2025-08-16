import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../design_system/components/components.dart';
import '../../models/review.dart';
import '../../services/review_service.dart';
import '../../providers/app_state_provider.dart';

/// Optimized Home Feed with Proper Pagination
/// 
/// Replaces the old home feed with:
/// - Real data from ReviewService instead of sample data
/// - Proper pagination with infinite scroll
/// - Optimized performance with proper loading states
/// - Unified design system components
/// - Multiple view types (masonry, list, swipe)
class OptimizedHomeFeed extends StatefulWidget {
  const OptimizedHomeFeed({super.key});

  @override
  State<OptimizedHomeFeed> createState() => _OptimizedHomeFeedState();
}

class _OptimizedHomeFeedState extends State<OptimizedHomeFeed>
    with TickerProviderStateMixin {
  
  // View configuration
  ViewType _currentView = ViewType.masonry;
  String _selectedFilter = 'All';
  
  // Pagination
  final List<Review> _reviews = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isInitialLoad = true;
  String? _lastDocumentId;
  
  // Controllers
  final ScrollController _scrollController = ScrollController();
  final PageController _swipeController = PageController(viewportFraction: 0.85);
  late AnimationController _viewTransitionController;
  late Animation<double> _fadeAnimation;
  
  // Services
  final ReviewService _reviewService = ReviewService();
  
  // Constants
  static const int _pageSize = 20;
  static const List<String> _filters = ['All', 'Recent', 'Popular', 'Following', 'Nearby'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupScrollListener();
    _loadInitialData();
  }

  void _setupAnimations() {
    _viewTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeInOut,
    ));
    
    _viewTransitionController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadInitialData() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _isInitialLoad = true;
    });

    try {
      final reviews = await _reviewService.getReviews(
        limit: _pageSize,
        filter: _selectedFilter,
      );
      
      setState(() {
        _reviews.clear();
        _reviews.addAll(reviews);
        _hasMoreData = reviews.length == _pageSize;
        _lastDocumentId = reviews.isNotEmpty ? reviews.last.id : null;
        _isInitialLoad = false;
      });
    } catch (e) {
      _showError('Failed to load reviews: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final reviews = await _reviewService.getReviews(
        limit: _pageSize,
        filter: _selectedFilter,
        startAfter: _lastDocumentId,
      );
      
      setState(() {
        _reviews.addAll(reviews);
        _hasMoreData = reviews.length == _pageSize;
        _lastDocumentId = reviews.isNotEmpty ? reviews.last.id : null;
      });
    } catch (e) {
      _showError('Failed to load more reviews: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _lastDocumentId = null;
      _hasMoreData = true;
    });
    await _loadInitialData();
  }

  void _changeView(ViewType type) {
    if (_currentView == type) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _currentView = type;
    });
    
    _viewTransitionController.reset();
    _viewTransitionController.forward();
  }

  void _changeFilter(String filter) {
    if (_selectedFilter == filter) return;
    
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFilter = filter;
    });
    
    _refreshData();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: DS.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigateToReviewDetail(Review review) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to review detail screen
    _showError('Review detail coming soon!');
  }

  @override
  void dispose() {
    _viewTransitionController.dispose();
    _scrollController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: DesignTokens.shadowSmall,
      ),
      child: Row(
        children: [
          // Logo and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DS.sm),
                decoration: BoxDecoration(
                  gradient: DesignTokens.primaryGradient,
                  borderRadius: BorderRadius.circular(DS.radiusMd),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: DS.md),
              Text(
                'Locker Room Talk',
                style: DesignTokens.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  foreground: Paint()
                    ..shader = DesignTokens.primaryGradient.createShader(
                      const Rect.fromLTWH(0, 0, 200, 70),
                    ),
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // View toggle
          _buildViewToggle(),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(DS.xs),
      decoration: BoxDecoration(
        color: DS.neutral100,
        borderRadius: BorderRadius.circular(DS.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewButton(
            icon: Icons.grid_view_rounded,
            type: ViewType.masonry,
            tooltip: 'Grid View',
          ),
          _buildViewButton(
            icon: Icons.style_rounded,
            type: ViewType.swipe,
            tooltip: 'Card View',
          ),
          _buildViewButton(
            icon: Icons.format_list_bulleted_rounded,
            type: ViewType.list,
            tooltip: 'List View',
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
        borderRadius: BorderRadius.circular(DS.radiusSm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(DS.sm),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(DS.radiusSm),
            boxShadow: isSelected ? DesignTokens.shadowSmall : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? DS.primary : DS.neutral600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: DS.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DS.md),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: DS.sm),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => _changeFilter(filter),
              backgroundColor: Colors.white,
              selectedColor: DS.primary.withOpacity(0.1),
              checkmarkColor: DS.primary,
              labelStyle: TextStyle(
                color: isSelected ? DS.primary : DS.neutral700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.radiusRound),
                side: BorderSide(
                  color: isSelected ? DS.primary : DS.neutral300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isInitialLoad) {
      return _buildLoadingState();
    }
    
    if (_reviews.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildCurrentView(),
    );
  }

  Widget _buildLoadingState() {
    switch (_currentView) {
      case ViewType.masonry:
        return const GridShimmer();
      case ViewType.list:
        return const ListShimmer();
      case ViewType.swipe:
        return const Center(
          child: AppLoadingIndicator(
            message: 'Loading reviews...',
          ),
        );
    }
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.rate_review_outlined,
      title: 'No reviews yet',
      message: 'Be the first to share your dating experience with the community.',
      actionText: 'Write a Review',
      onAction: () {
        // TODO: Navigate to create review
        _showError('Create review coming soon!');
      },
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
      onRefresh: _refreshData,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(DS.md),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: DS.md,
              crossAxisSpacing: DS.md,
              childCount: _reviews.length + (_hasMoreData ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= _reviews.length) {
                  return const CardShimmer();
                }
                
                return ReviewCard(
                  review: _reviews[index],
                  onTap: () => _navigateToReviewDetail(_reviews[index]),
                  style: CardStyle.standard,
                );
              },
            ),
          ),
          if (_isLoading && !_isInitialLoad)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(DS.lg),
                child: Center(
                  child: AppLoadingIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(DS.md),
        itemCount: _reviews.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _reviews.length) {
            return const Padding(
              padding: EdgeInsets.all(DS.lg),
              child: Center(
                child: AppLoadingIndicator(),
              ),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: DS.md),
            child: ReviewCard(
              review: _reviews[index],
              onTap: () => _navigateToReviewDetail(_reviews[index]),
              style: CardStyle.compact,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwipeView() {
    return PageView.builder(
      controller: _swipeController,
      itemCount: _reviews.length,
      onPageChanged: (index) {
        // Load more when approaching the end
        if (index >= _reviews.length - 3) {
          _loadMoreData();
        }
      },
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DS.sm,
            vertical: DS.lg,
          ),
          child: ReviewCard(
            review: _reviews[index],
            onTap: () => _navigateToReviewDetail(_reviews[index]),
            style: CardStyle.feature,
          ),
        );
      },
    );
  }
}

enum ViewType {
  masonry,
  swipe,
  list,
}