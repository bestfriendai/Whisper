import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:whisperdate/theme_modern_2025.dart';
import 'dart:math' as math;

class HomeScreenPremium extends StatefulWidget {
  const HomeScreenPremium({super.key});

  @override
  State<HomeScreenPremium> createState() => _HomeScreenPremiumState();
}

class _HomeScreenPremiumState extends State<HomeScreenPremium> 
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _headerAnimController;
  late AnimationController _fabAnimController;
  double _scrollOffset = 0;
  String _selectedFilter = 'Trending';
  
  final List<String> _filters = ['Trending', 'New', 'Near You', 'Following'];
  
  // High-quality stock images for reviews
  final List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1543807535-eceef0bc6599?w=800&q=90',
    'https://images.unsplash.com/photo-1517456793572-1d8efd6dc135?w=800&q=90',
    'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?w=800&q=90',
    'https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?w=800&q=90',
    'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=800&q=90',
    'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&q=90',
    'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800&q=90',
    'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800&q=90',
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800&q=90',
    'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=90',
    'https://images.unsplash.com/photo-1502082890817-ed84341a9f73?w=800&q=90',
    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=90',
    'https://images.unsplash.com/photo-1556075798-4825dfaaf498?w=800&q=90',
    'https://images.unsplash.com/photo-1551836022-b06985bceb24?w=800&q=90',
    'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800&q=90',
  ];

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
    
    if (_scrollOffset > 100) {
      _headerAnimController.forward();
      _fabAnimController.forward();
    } else {
      _headerAnimController.reverse();
      _fabAnimController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Premium animated header
              SliverAppBar(
                expandedHeight: 140,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: _scrollOffset > 10 ? 2 : 0,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final expandRatio = (constraints.maxHeight - kToolbarHeight) / 
                                       (140 - kToolbarHeight);
                    return FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(
                        left: 20,
                        bottom: 14,
                        right: 20,
                      ),
                      title: Row(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: expandRatio < 0.5 ? 1 : 0,
                            child: const Text(
                              'LockerRoom',
                              style: TextStyle(
                                color: ModernColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              ModernColors.primary.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'LockerRoom',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: ModernColors.primary,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Real experiences, real connections',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ModernColors.neutral600,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    _buildHeaderAction(Icons.search_rounded),
                                    const SizedBox(width: 12),
                                    _buildHeaderAction(Icons.notifications_none_rounded,
                                      badge: true),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Filter chips
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterDelegate(
                  filters: _filters,
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              ),
              
              // Pinterest-style masonry grid
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childCount: 20,
                  itemBuilder: (context, index) {
                    return _buildMasonryCard(index);
                  },
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          
          // Floating Action Button
          Positioned(
            bottom: 80,
            right: 20,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _fabAnimController,
                curve: Curves.easeOutBack,
              )),
              child: FloatingActionButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                },
                backgroundColor: ModernColors.primary,
                child: const Icon(Icons.edit_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeaderAction(IconData icon, {bool badge = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(icon, color: ModernColors.neutral700, size: 22),
          ),
          if (badge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: ModernColors.accent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildMasonryCard(int index) {
    final random = math.Random(index);
    final hasImage = index % 3 != 2; // 2/3 cards have images
    final imageHeight = 150.0 + random.nextDouble() * 150; // Variable heights
    final names = ['Emma Wilson', 'James Chen', 'Sophia Martinez', 'Liam Anderson', 'Olivia Brown'];
    final ratings = [5, 4, 5, 3, 4];
    final times = ['2h ago', '5h ago', '1d ago', '2d ago', '3d ago'];
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (hasImage)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_imageUrls[index % _imageUrls.length]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, 
                              size: 14, 
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              ratings[index % 5].toString(),
                              style: const TextStyle(
                                fontSize: 12,
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
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: ModernColors.primary.withOpacity(0.1),
                        child: Text(
                          names[index % 5][0],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ModernColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              names[index % 5],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: ModernColors.neutral900,
                              ),
                            ),
                            Text(
                              times[index % 5],
                              style: TextStyle(
                                fontSize: 11,
                                color: ModernColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index % 4 == 0)
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: ModernColors.info,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Review title
                  Text(
                    _getReviewTitle(index),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ModernColors.neutral900,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Review content
                  Text(
                    _getReviewContent(index),
                    style: TextStyle(
                      fontSize: 12,
                      color: ModernColors.neutral600,
                      height: 1.4,
                    ),
                    maxLines: hasImage ? 3 : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _getTags(index).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tag['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag['text'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: tag['color'],
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Engagement bar
                  Row(
                    children: [
                      _buildEngagement(Icons.favorite_outline, '${234 + index * 17}'),
                      const SizedBox(width: 16),
                      _buildEngagement(Icons.chat_bubble_outline, '${42 + index * 3}'),
                      const Spacer(),
                      Icon(Icons.bookmark_outline, 
                        size: 18, 
                        color: ModernColors.neutral400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEngagement(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ModernColors.neutral500),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            color: ModernColors.neutral500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  String _getReviewTitle(int index) {
    final titles = [
      'Perfect sunset picnic at Griffith Observatory',
      'Cozy coffee date turned into 4-hour conversation',
      'Hiking adventure at Runyon Canyon',
      'Art gallery date with wine tasting',
      'Beach volleyball and sunset drinks',
      'Rooftop dinner with city views',
      'Morning yoga class together',
      'Food truck tour downtown',
      'Jazz night at Blue Whale',
      'Bookstore browsing in Silver Lake',
    ];
    return titles[index % titles.length];
  }
  
  String _getReviewContent(int index) {
    final contents = [
      'Such an amazing first date! We watched the sunset over LA and talked about everything from travel dreams to favorite movies. They brought a thoughtful picnic spread and even remembered I mentioned loving cheese boards. The conversation flowed naturally and we stayed until the stars came out.',
      'Met at Intelligentsia and what was supposed to be a quick coffee turned into hours of deep conversation. They asked thoughtful questions and really listened. We discovered so many shared interests - from true crime podcasts to hiking trails.',
      'Early morning hike was the perfect active date. They came prepared with water and snacks for both of us. Great conversation during the breaks and stunning views at the top. Ended with smoothies at Sunlife Organics.',
      'LACMA date was incredibly thoughtful - they researched the exhibits beforehand and had interesting insights about the art. The wine tasting afterward was relaxed and fun. Really appreciated their knowledge and passion for art.',
      'Beach date at Manhattan Beach - played volleyball with some locals, had fish tacos, and watched the sunset. They were fun, competitive in the best way, and made sure I was comfortable the whole time.',
    ];
    return contents[index % contents.length];
  }
  
  List<Map<String, dynamic>> _getTags(int index) {
    final allTags = [
      {'text': 'Thoughtful', 'color': ModernColors.success},
      {'text': 'Great conversation', 'color': ModernColors.primary},
      {'text': 'Would meet again', 'color': ModernColors.accent},
      {'text': 'Respectful', 'color': ModernColors.info},
      {'text': 'Fun', 'color': ModernColors.warning},
    ];
    
    final numTags = (index % 3) + 1;
    return allTags.sublist(index % allTags.length, 
      math.min((index % allTags.length) + numTags, allTags.length));
  }
}

class _FilterDelegate extends SliverPersistentHeaderDelegate {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterChanged;
  
  _FilterDelegate({
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = filter == selectedFilter;
            
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? ModernColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? ModernColors.primary : ModernColors.neutral300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : ModernColors.neutral700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  @override
  double get maxExtent => 54;
  
  @override
  double get minExtent => 54;
  
  @override
  bool shouldRebuild(_FilterDelegate oldDelegate) {
    return oldDelegate.selectedFilter != selectedFilter;
  }
}