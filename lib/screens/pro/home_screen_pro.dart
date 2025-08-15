import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockerroomtalk/theme_modern_2025.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/models/user.dart';

class HomeScreenPro extends StatefulWidget {
  const HomeScreenPro({super.key});

  @override
  State<HomeScreenPro> createState() => _HomeScreenProState();
}

class _HomeScreenProState extends State<HomeScreenPro> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'For You';
  
  final List<String> _filters = ['For You', 'Following', 'Trending', 'New'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Clean, minimal app bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  'LockerRoom',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ModernColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ModernColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BETA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ModernColors.accent,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_none, color: ModernColors.neutral700),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ModernColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Filter tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterHeaderDelegate(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildReviewCard(index),
                childCount: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewCard(int index) {
    final names = ['Sarah M.', 'Alex Chen', 'Jordan Taylor', 'Morgan Lee', 'Casey Williams'];
    final ages = [24, 27, 23, 26, 25];
    final ratings = [5, 4, 3, 5, 4];
    final verifiedStatus = [true, false, true, true, false];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ModernColors.neutral200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ModernColors.neutral200,
                  child: Text(
                    names[index % 5][0],
                    style: TextStyle(
                      color: ModernColors.neutral700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            names[index % 5],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ModernColors.neutral900,
                            ),
                          ),
                          if (verifiedStatus[index % 5]) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: ModernColors.info,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${ages[index % 5]} • 2 days ago',
                        style: const TextStyle(
                          fontSize: 12,
                          color: ModernColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ModernColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: ModernColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ratings[index % 5].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ModernColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getReviewTitle(index),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ModernColors.neutral900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getReviewContent(index),
                  style: const TextStyle(
                    fontSize: 14,
                    color: ModernColors.neutral700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Tags
          if (index % 2 == 0)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('Great conversation', ModernColors.success),
                  _buildTag('Respectful', ModernColors.info),
                  if (index % 3 == 0) _buildTag('Would meet again', ModernColors.primary),
                ],
              ),
            ),
          
          // Divider
          const Divider(height: 1, color: ModernColors.neutral200),
          
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: '${42 + index * 7}',
                  onTap: () {},
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: '${12 + index * 2}',
                  onTap: () {},
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.bookmark_outline,
                  label: '',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Icon(icon, size: 20, color: ModernColors.neutral600),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ModernColors.neutral600,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _getReviewTitle(int index) {
    final titles = [
      'Amazing first date at the local coffee shop',
      'Fun evening at the bowling alley',
      'Great conversation over dinner',
      'Hiking date was perfect',
      'Movie night turned into deep talks',
    ];
    return titles[index % titles.length];
  }
  
  String _getReviewContent(int index) {
    final contents = [
      'We met at Blue Bottle Coffee and ended up talking for 3 hours. They were genuinely interested in my work and had great stories to share. Really appreciated how they asked thoughtful questions.',
      'Super fun and competitive in the best way! We had a blast at the bowling alley, lots of laughs. They were gracious when winning and encouraging when I was struggling with my strikes.',
      'Chose a quiet Italian place downtown. The conversation flowed naturally, covering everything from travel stories to life goals. They were attentive and made sure to include me in choosing wine.',
      'They suggested a morning hike at Runyon Canyon. Great choice! We saw the sunrise and had meaningful conversations during breaks. They came prepared with water and snacks for both of us.',
      'Started with a movie but ended up talking in the car for hours after. They were respectful of boundaries and genuinely interested in getting to know me as a person.',
    ];
    return contents[index % contents.length];
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterChanged;
  
  _FilterHeaderDelegate({
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = filter == selectedFilter;
                
                return GestureDetector(
                  onTap: () => onFilterChanged(filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? ModernColors.primary : ModernColors.neutral600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: isSelected ? 24 : 0,
                          decoration: BoxDecoration(
                            color: ModernColors.primary,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: ModernColors.neutral200),
        ],
      ),
    );
  }
  
  @override
  double get maxExtent => 49;
  
  @override
  double get minExtent => 49;
  
  @override
  bool shouldRebuild(_FilterHeaderDelegate oldDelegate) {
    return oldDelegate.selectedFilter != selectedFilter;
  }
}