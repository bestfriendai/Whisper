import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockerroomtalk/models/user.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  bool _isSearching = false;
  bool _hasSearched = false;
  String _currentQuery = '';
  
  List<SearchResult> _searchResults = [];
  List<String> _recentSearches = [
    'Coffee date conversations',
    'Thoughtful and genuine',
    'Great chemistry',
    'Museum visits',
    'Theater experiences'
  ];
  List<String> _trendingTopics = [
    'Coffee dates',
    'Art galleries',
    'Food experiences',
    'Book lovers',
    'Fitness dates',
    'Travel stories'
  ];
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    final query = _searchController.text;
    if (query != _currentQuery) {
      setState(() {
        _currentQuery = query;
        _isSearching = query.isNotEmpty;
      });
      
      if (query.isNotEmpty) {
        _performSearch(query);
      }
    }
  }
  
  Future<void> _performSearch(String query) async {
    setState(() {
      _hasSearched = true;
    });
    
    // Simulate search delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock search results
    final results = _generateMockResults(query);
    
    setState(() {
      _searchResults = results;
    });
  }
  
  void _clearSearch() {
    HapticFeedback.lightImpact();
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      _isSearching = false;
      _hasSearched = false;
      _searchResults.clear();
    });
  }
  
  void _onRecentSearchTapped(String search) {
    HapticFeedback.selectionClick();
    _searchController.text = search;
    _searchFocusNode.unfocus();
  }
  
  void _onTrendingTopicTapped(String topic) {
    HapticFeedback.lightImpact();
    _searchController.text = topic;
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Ultra-Modern Header with Glassmorphism
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor.withValues(alpha: 0.98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.neutral600.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Column(
              children: [
                // Ultra-Enhanced Title
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => AppColors.meshGradient1.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        'Search',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.0,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Ultra-Premium Search Bar
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neutral800.withValues(alpha: 0.95),
                        AppColors.neutral800.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _searchFocusNode.hasFocus
                          ? AppColors.primary
                          : AppColors.neutral600.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _searchFocusNode.hasFocus
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                        blurRadius: _searchFocusNode.hasFocus ? 20 : 12,
                        offset: const Offset(0, 4),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search reviews, people, experiences...',
                      hintStyle: TextStyle(
                        color: AppColors.neutral400,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.neutral400,
                          size: 22,
                        ),
                      ),
                      suffixIcon: _currentQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: _clearSearch,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.neutral600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: AppColors.neutral300,
                                  size: 18,
                                ),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    if (!_hasSearched) {
      return _buildDiscoveryContent(context);
    } else if (_isSearching) {
      return _buildSearchResults(context);
    } else {
      return _buildDiscoveryContent(context);
    }
  }
  
  Widget _buildDiscoveryContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader(context, 'Recent Searches'),
            const SizedBox(height: 16),
            _buildRecentSearches(context),
            const SizedBox(height: 32),
          ],
          
          // Trending Topics
          _buildSectionHeader(context, 'Trending Topics'),
          const SizedBox(height: 16),
          _buildTrendingTopics(context),
          const SizedBox(height: 32),
          
          // Quick Filters
          _buildSectionHeader(context, 'Quick Filters'),
          const SizedBox(height: 16),
          _buildQuickFilters(context),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
        letterSpacing: -0.4,
      ),
    );
  }
  
  Widget _buildRecentSearches(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: _recentSearches.map((search) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _onRecentSearchTapped(search),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.neutral800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.neutral700,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: AppColors.neutral400,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      search,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral100,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_west,
                    color: AppColors.neutral400,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildTrendingTopics(BuildContext context) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _trendingTopics.map((topic) {
        return GestureDetector(
          onTap: () => _onTrendingTopicTapped(topic),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  topic,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildQuickFilters(BuildContext context) {
    final theme = Theme.of(context);
    final filters = [
      {'title': 'Highly Rated', 'icon': Icons.star, 'count': '500+'},
      {'title': 'Recent Reviews', 'icon': Icons.schedule, 'count': '200+'},
      {'title': 'Recommended', 'icon': Icons.thumb_up, 'count': '300+'},
      {'title': 'Local Area', 'icon': Icons.location_on, 'count': '150+'},
    ];
    
    return Column(
      children: filters.map((filter) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              // Handle filter tap
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neutral800,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.neutral700,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      filter['icon'] as IconData,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filter['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral100,
                          ),
                        ),
                        Text(
                          '${filter['count']} reviews',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.neutral400,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.neutral800,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.neutral700,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.search_off,
                size: 36,
                color: AppColors.neutral400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No results found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.neutral100,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral400,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultItem(context, result);
      },
    );
  }
  
  Widget _buildSearchResultItem(BuildContext context, SearchResult result) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutral700,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            result.title.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          result.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.neutral100,
          ),
        ),
        subtitle: Text(
          result.subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutral400,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.neutral400,
          size: 16,
        ),
        onTap: () {
          // Handle result tap
        },
      ),
    );
  }
  
  List<SearchResult> _generateMockResults(String query) {
    return [
      SearchResult(
        title: 'Coffee conversations',
        subtitle: 'Reviews about great coffee date experiences',
        type: SearchResultType.topic,
      ),
      SearchResult(
        title: 'Museum visits',
        subtitle: 'Cultural date experiences and reviews',
        type: SearchResultType.topic,
      ),
      SearchResult(
        title: 'Thoughtful dates',
        subtitle: 'Reviews highlighting considerate partners',
        type: SearchResultType.topic,
      ),
    ];
  }
}

class SearchResult {
  final String title;
  final String subtitle;
  final SearchResultType type;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum SearchResultType {
  user,
  review,
  topic,
}