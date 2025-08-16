import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleChatRoomsScreen extends StatefulWidget {
  const SimpleChatRoomsScreen({Key? key}) : super(key: key);

  @override
  State<SimpleChatRoomsScreen> createState() => _SimpleChatRoomsScreenState();
}

class _SimpleChatRoomsScreenState extends State<SimpleChatRoomsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Local', 'Popular', 'New'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCD6B47),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Filter tabs
                    _buildFilterTabs(),
                    
                    // Chat rooms list
                    Expanded(
                      child: _buildChatRoomsList(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFFCD6B47),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Chat Rooms',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Connect with your community',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFCD6B47) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected 
                      ? null 
                      : Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFFCD6B47).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatRoomsList() {
    final chatRooms = _getMockChatRooms();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final room = chatRooms[index];
        return _buildChatRoomCard(room);
      },
    );
  }

  Widget _buildChatRoomCard(ChatRoom room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Room image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        room.color.withOpacity(0.7),
                        room.color,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      room.icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Live indicator
                if (room.isLive)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Room details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room name and members
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.memberCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  room.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Location and last activity
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: const Color(0xFFCD6B47),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCD6B47),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      room.lastActivity,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Join button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => _joinChatRoom(room),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD6B47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      room.isJoined ? 'Continue Chat' : 'Join Room',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _joinChatRoom(ChatRoom room) {
    // Show coming soon dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.chat_bubble_outline, color: Color(0xFFCD6B47)),
            SizedBox(width: 12),
            Text('Coming Soon'),
          ],
        ),
        content: Text(
          'Chat rooms are coming soon! You\'ll be able to join "${room.name}" and connect with others in your area.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  List<ChatRoom> _getMockChatRooms() {
    return [
      ChatRoom(
        name: 'Fort Washington Singles',
        description: 'Connect with local singles in Fort Washington and nearby areas. Share experiences and meet new people.',
        location: 'Fort Washington, MD',
        memberCount: 124,
        isLive: true,
        isJoined: false,
        lastActivity: '2m ago',
        color: Colors.blue,
        icon: Icons.location_city,
      ),
      ChatRoom(
        name: 'Coffee Date Stories',
        description: 'Share your coffee date experiences, both good and bad. Find the best spots and avoid the worst.',
        location: 'DMV Area',
        memberCount: 89,
        isLive: false,
        isJoined: true,
        lastActivity: '15m ago',
        color: Colors.brown,
        icon: Icons.coffee,
      ),
      ChatRoom(
        name: 'Dating After 30',
        description: 'Mature discussions about dating challenges and successes for adults over 30.',
        location: 'Washington, DC',
        memberCount: 203,
        isLive: true,
        isJoined: false,
        lastActivity: '5m ago',
        color: Colors.purple,
        icon: Icons.favorite,
      ),
      ChatRoom(
        name: 'Local Events & Meetups',
        description: 'Coordinate group dates, events, and meetups in the DMV area. Make new connections safely.',
        location: 'DMV Area',
        memberCount: 67,
        isLive: false,
        isJoined: false,
        lastActivity: '1h ago',
        color: Colors.green,
        icon: Icons.event,
      ),
      ChatRoom(
        name: 'First Date Tips',
        description: 'Get advice on first dates, share success stories, and learn from others\' experiences.',
        location: 'General',
        memberCount: 156,
        isLive: false,
        isJoined: true,
        lastActivity: '30m ago',
        color: Colors.orange,
        icon: Icons.tips_and_updates,
      ),
      ChatRoom(
        name: 'LGBTQ+ Community',
        description: 'A safe and welcoming space for LGBTQ+ dating discussions, support, and connections.',
        location: 'DMV Area',
        memberCount: 78,
        isLive: false,
        isJoined: false,
        lastActivity: '45m ago',
        color: Colors.pink,
        icon: Icons.diversity_3,
      ),
    ];
  }
}

class ChatRoom {
  final String name;
  final String description;
  final String location;
  final int memberCount;
  final bool isLive;
  final bool isJoined;
  final String lastActivity;
  final Color color;
  final IconData icon;

  ChatRoom({
    required this.name,
    required this.description,
    required this.location,
    required this.memberCount,
    required this.isLive,
    required this.isJoined,
    required this.lastActivity,
    required this.color,
    required this.icon,
  });
}