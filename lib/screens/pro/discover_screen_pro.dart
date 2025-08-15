import 'package:flutter/material.dart';
import 'package:whisperdate/theme_modern_2025.dart';

class DiscoverScreenPro extends StatefulWidget {
  const DiscoverScreenPro({super.key});

  @override
  State<DiscoverScreenPro> createState() => _DiscoverScreenProState();
}

class _DiscoverScreenProState extends State<DiscoverScreenPro> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernColors.background,
      appBar: AppBar(
        title: const Text('Discover'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search people, places, experiences...',
                prefixIcon: const Icon(Icons.search, color: ModernColors.neutral400),
                filled: true,
                fillColor: ModernColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Trending Topics', [
            _buildTrendingTopic('Coffee Dates', '2.3k reviews', ModernColors.primary),
            _buildTrendingTopic('First Dates', '1.8k reviews', ModernColors.accent),
            _buildTrendingTopic('Outdoor Activities', '945 reviews', ModernColors.success),
          ]),
          const SizedBox(height: 24),
          _buildSection('Popular Locations', [
            _buildLocationCard('Downtown LA', '523 reviews'),
            _buildLocationCard('Santa Monica', '412 reviews'),
            _buildLocationCard('Beverly Hills', '387 reviews'),
          ]),
          const SizedBox(height: 24),
          _buildSection('Recommended Users', [
            _buildUserCard('Emma Watson', '4.8', true),
            _buildUserCard('Chris Johnson', '4.6', false),
            _buildUserCard('Maya Patel', '4.9', true),
          ]),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ModernColors.neutral900,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
  
  Widget _buildTrendingTopic(String topic, String count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ModernColors.neutral200, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.tag, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ModernColors.neutral900,
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ModernColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: ModernColors.neutral400),
        ],
      ),
    );
  }
  
  Widget _buildLocationCard(String location, String reviews) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ModernColors.neutral200, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: ModernColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ModernColors.neutral900,
                  ),
                ),
                Text(
                  reviews,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ModernColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserCard(String name, String rating, bool isVerified) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ModernColors.neutral200, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: ModernColors.neutral200,
            child: Text(
              name[0],
              style: const TextStyle(
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
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ModernColors.neutral900,
                      ),
                    ),
                    if (isVerified) ...[                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 14, color: ModernColors.info),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: ModernColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ModernColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ProButton(
            text: 'Follow',
            onPressed: () {},
            isPrimary: false,
          ),
        ],
      ),
    );
  }
}