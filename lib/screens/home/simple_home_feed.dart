import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class SimpleHomeFeed extends StatefulWidget {
  const SimpleHomeFeed({Key? key}) : super(key: key);

  @override
  State<SimpleHomeFeed> createState() => _SimpleHomeFeedState();
}

class _SimpleHomeFeedState extends State<SimpleHomeFeed> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String _selectedLocation = 'Oxon Hill, MD';
  String _selectedRadius = '50mi';
  bool _showAnnouncement = true;

  final List<String> _locations = [
    'Oxon Hill, MD',
    'New York, NY',
    'Los Angeles, CA',
    'Chicago, IL',
    'Houston, TX',
    'Phoenix, AZ',
    'Philadelphia, PA',
    'San Antonio, TX',
    'San Diego, CA',
    'Dallas, TX',
  ];

  final List<String> _radiusOptions = ['10mi', '25mi', '50mi', '100mi', '250mi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCD6B47), // TeaOnHer orange color
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Main content
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row with logo and guest indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFFCD6B47),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'LockerRoomTalk',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              
              // Guest indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.visibility_outlined, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _auth.currentUser?.isAnonymous ?? true ? 'Guest' : 'Member',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Location selector
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedLocation,
                  isExpanded: true,
                  underline: Container(),
                  dropdownColor: const Color(0xFFCD6B47),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedRadius,
                underline: Container(),
                dropdownColor: const Color(0xFFCD6B47),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                items: _radiusOptions.map((radius) {
                  return DropdownMenuItem(
                    value: radius,
                    child: Text(radius, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRadius = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Admin announcement
          if (_showAnnouncement) _buildAnnouncement(),
          
          // Reviews feed
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getReviewsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCD6B47)),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reviews found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildReviewCard(data, doc.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncement() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCD6B47),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'APP UPDATE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCD6B47),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _showAnnouncement = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Admin Announcement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Global',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '"Fellas, In the past few weeks, thousands of new users have joined our platform. Please continue to be respectful and honest in your reviews."',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> data, String docId) {
    final String name = data['subjectName'] ?? 'Unknown';
    final int age = data['subjectAge'] ?? 0;
    final String location = '${data['location']?['city'] ?? 'Unknown'}, ${data['location']?['state'] ?? ''}';
    final String content = data['content'] ?? '';
    final List<dynamic> imageUrls = data['imageUrls'] ?? [];
    final bool hasImage = imageUrls.isNotEmpty;
    final bool isAnonymous = data['isAnonymous'] ?? false;
    
    // Determine card color based on flags
    Color cardColor = Colors.white;
    Color flagColor = Colors.grey;
    IconData flagIcon = Icons.flag_outlined;
    
    if (data['flags'] != null) {
      final flags = data['flags'] as Map<String, dynamic>;
      final greenFlags = flags['green'] ?? 0;
      final redFlags = flags['red'] ?? 0;
      
      if (greenFlags > redFlags) {
        flagColor = Colors.green;
        flagIcon = Icons.flag;
      } else if (redFlags > greenFlags) {
        flagColor = Colors.red;
        flagIcon = Icons.flag;
      } else {
        flagColor = Colors.orange;
        flagIcon = Icons.flag;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image (if available)
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrls[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFFCD6B47)),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                  
                  // Flag indicator
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: flagColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        flagIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  // Report button
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.flag_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _reportReview(docId),
                            child: const Text(
                              'Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and age
                Row(
                  children: [
                    Text(
                      '$name, $age',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    if (!hasImage)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: flagColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          flagIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Location
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Review content
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: hasImage ? 3 : 5,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Bottom row with report button (if no image)
                if (!hasImage)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flag_outlined, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _reportReview(docId),
                              child: const Text(
                                'Report',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getReviewsStream() {
    Query query = _firestore.collection('reviews');
    
    // Filter by city if not showing all
    String selectedCity = _selectedLocation.split(',')[0].trim();
    if (selectedCity != 'All Cities') {
      query = query.where('location.city', isEqualTo: selectedCity);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  void _reportReview(String reviewId) {
    // Show report confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Review'),
        content: const Text('Are you sure you want to report this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review reported. Thank you for keeping our community safe.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}