import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:whisperdate/models/chat_room.dart';
import 'package:whisperdate/screens/chat/chat_page.dart';
import 'package:whisperdate/services/chat_service.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({super.key});

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  late AnimationController _filterAnimationController;

  final List<ChatFilter> _filters = [
    ChatFilter(id: 'all', label: 'All Rooms', icon: Icons.forum),
    ChatFilter(id: 'location', label: 'Nearby', icon: Icons.location_on),
    ChatFilter(id: 'topic', label: 'Topics', icon: Icons.topic),
    ChatFilter(id: 'active', label: 'Most Active', icon: Icons.trending_up),
  ];

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadChatRooms();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadChatRooms() async {
    setState(() => _isLoading = true);
    
    try {
      List<ChatRoom> loadedRooms;
      
      switch (_selectedFilter) {
        case 'location':
          loadedRooms = await ChatService().getChatRooms(location: 'DMV Area');
          break;
        case 'topic':
          loadedRooms = await ChatService().getChatRooms();
          break;
        case 'active':
          loadedRooms = await ChatService().getChatRooms();
          break;
        default:
          loadedRooms = await ChatService().getChatRooms();
      }
      
      // Fallback to mock data if no rooms found
      if (loadedRooms.isEmpty) {
        loadedRooms = ChatService().getMockChatRooms();
      }
      
      setState(() {
        _chatRooms = loadedRooms;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to mock data on error
      final mockRooms = ChatService().getMockChatRooms();
      
      setState(() {
        _chatRooms = mockRooms;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using demo data: $e'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
    
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _chatRooms = _generateMockChatRooms();
      _isLoading = false;
    });
  }

  void _onFilterChanged(String filterId) {
    if (filterId == _selectedFilter) return;
    
    setState(() => _selectedFilter = filterId);
    _filterAnimationController.reset();
    _filterAnimationController.forward();
    // TODO: Implement filtering logic
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.02),
                    theme.colorScheme.secondary.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.forum_outlined,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Chat Rooms',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Connect with your community',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: _showCreateRoomBottomSheet,
                  tooltip: 'Create Room',
                ),
              ),
            ],
          ),
        ],
        body: Column(
          children: [
            // Filter chips
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter.id == _selectedFilter;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              )
                            : null,
                        color: isSelected 
                            ? null 
                            : theme.colorScheme.surfaceVariant.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                              ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _onFilterChanged(filter.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  filter.icon,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  filter.label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Chat rooms grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _chatRooms.isEmpty
                      ? _buildEmptyState(theme)
                      : RefreshIndicator(
                          onRefresh: _loadChatRooms,
                          child: MasonryGridView.count(
                            controller: _scrollController,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            padding: const EdgeInsets.all(16),
                            itemCount: _chatRooms.length,
                            itemBuilder: (context, index) {
                              return ChatRoomCard(
                                chatRoom: _chatRooms[index],
                                onTap: () => _navigateToChat(_chatRooms[index]),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.forum_outlined,
              size: 40,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Chat Rooms Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to create a room\nfor your community!',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _showCreateRoomBottomSheet,
            icon: const Icon(Icons.add),
            label: const Text('Create Room'),
          ),
        ],
      ),
    );
  }

  void _navigateToChat(ChatRoom chatRoom) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(chatRoom: chatRoom),
      ),
    );
  }

  void _showCreateRoomBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateRoomBottomSheet(),
    );
  }

  List<ChatRoom> _generateMockChatRooms() {
    final mockImages = [
      'https://pixabay.com/get/g65b52663ec91141d4127f0fa8c7ba4cd9ae4c25deec39fa5bd10d1b93e97204f8459c72bf1294372b5791f7bf854b8f9803cf75c18ba258c80e6ea630cde7d41_1280.jpg',
      'https://pixabay.com/get/g64792a3d98c396138139b00e2eb793da74a59a2e3cf157a78f4183f1cc0d1e6e858a16384a2142ee2c1a2de2de9bdacd40834d6afa773384246febf711ec51fa_1280.jpg',
      'https://pixabay.com/get/g62eacbca3553a6af8148900327fad5234c46257b5fb4633d5c017ab99b0f24c34e47555a49ac0d9b298381c0013952cd9e8c91400355e14d768b1ca375cbaa15_1280.jpg',
      'https://pixabay.com/get/g6f3e57d08dd1eb333079e0041a4abf4557a32c44988f22e8aadc7ac3a662689441535615601fcb972728f2ccfe13a3a28e33ed2c0beb90a46571121385dfd677_1280.jpg',
      'https://pixabay.com/get/g2fae7544713a2c26f89d7bde03a98c75bbe0c3164ff1204fa475087faf4cc8504b4a9f8cd2a00bf2059c67b85e5c2a873572a1bdd95bf354f7b5c6df7391cb84_1280.jpg',
      'https://pixabay.com/get/gb7c53dc3ef356a9c268dabc2b5f9d5bd5105ecbd6b26941bf09df75720bb6bbc810ae90b7a45b87862c6435fddf0b61de7a1f1e5d84c63396e074249729b1a29_1280.jpg',
    ];

    return List.generate(12, (index) {
      final locations = ['Fort Washington, MD', 'Alexandria, VA', 'Washington, DC', 'Bethesda, MD'];
      final topics = ['Coffee Dates', 'First Date Tips', 'Dating After 30', 'Long Distance', 'LGBTQ+ Dating'];
      final types = ChatRoomType.values;
      
      return ChatRoom(
        id: 'room_$index',
        name: [
          'Coffee & Conversation',
          'Fort Washington Singles',
          'First Date Stories',
          'Dating Over 25',
          'LGBTQ+ Community',
          'Weekend Plans',
          'Local Hotspots',
          'Relationship Advice',
          'DC Area Meetup',
          'Success Stories',
          'Dating Mishaps',
          'New in Town'
        ][index % 12],
        description: [
          'Share your coffee date experiences and find the best spots around town',
          'Connect with local singles in Fort Washington and nearby areas',
          'Share funny, sweet, and memorable first date stories',
          'Dating discussions for mature adults looking for real connections',
          'A safe space for LGBTQ+ dating discussions and support',
          'Plan group meetups and weekend activities together',
          'Discover and share the best date spots in the DMV area',
          'Get advice and support on dating challenges',
          'Meet other singles in the Washington DC metropolitan area',
          'Celebrate and share your dating success stories',
          'Laugh about dating fails and learn from them together',
          'Welcome newcomers and help them navigate local dating'
        ][index % 12],
        topic: topics[index % topics.length],
        location: locations[index % locations.length],
        imageUrl: mockImages[index % mockImages.length],
        memberCount: 15 + (index * 7) % 200,
        createdAt: DateTime.now().subtract(Duration(days: index * 3)),
        lastActivity: DateTime.now().subtract(Duration(minutes: index * 15)),
        tags: [
          ['coffee', 'casual', 'meetup'],
          ['local', 'singles', 'community'],
          ['stories', 'experiences', 'fun'],
          ['mature', 'serious', 'relationships'],
          ['lgbtq', 'inclusive', 'support'],
          ['weekend', 'activities', 'plans'],
          ['spots', 'recommendations', 'local'],
          ['advice', 'help', 'support'],
          ['dc', 'meetup', 'area'],
          ['success', 'positive', 'wins'],
          ['funny', 'fails', 'learn'],
          ['newcomers', 'welcome', 'help']
        ][index % 12],
        type: types[index % types.length],
        creatorId: 'user_${index % 5}',
      );
    });
  }
}

class ChatFilter {
  final String id;
  final String label;
  final IconData icon;

  ChatFilter({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class ChatRoomCard extends StatefulWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const ChatRoomCard({
    super.key,
    required this.chatRoom,
    required this.onTap,
  });

  @override
  State<ChatRoomCard> createState() => _ChatRoomCardState();
}

class _ChatRoomCardState extends State<ChatRoomCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _hoverAnimationController.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _hoverAnimationController.reverse();
            },
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              widget.chatRoom.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: theme.colorScheme.surfaceVariant,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                            // Live indicator
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.chatRoom.isActive
                                      ? Colors.green
                                      : theme.colorScheme.outline,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.chatRoom.isActive ? 'LIVE' : 'QUIET',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room name
                          Text(
                            widget.chatRoom.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Description
                          Text(
                            widget.chatRoom.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Location/Topic
                          Row(
                            children: [
                              Icon(
                                _getRoomTypeIcon(),
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _getLocationTopicText(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Members and activity
                          Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.chatRoom.memberCount}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _getLastActivityText(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
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

  IconData _getRoomTypeIcon() {
    switch (widget.chatRoom.type) {
      case ChatRoomType.location:
        return Icons.location_on;
      case ChatRoomType.topic:
        return Icons.topic;
      case ChatRoomType.hybrid:
        return Icons.group;
    }
  }

  String _getLocationTopicText() {
    switch (widget.chatRoom.type) {
      case ChatRoomType.location:
        return widget.chatRoom.location;
      case ChatRoomType.topic:
        return widget.chatRoom.topic;
      case ChatRoomType.hybrid:
        return '${widget.chatRoom.location} • ${widget.chatRoom.topic}';
    }
  }

  String _getLastActivityText() {
    final diff = DateTime.now().difference(widget.chatRoom.lastActivity);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

class CreateRoomBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Create Chat Room',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Chat rooms are coming soon! You\'ll be able to create location-based and topic-specific rooms to connect with your community.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ),
        ],
      ),
    );
  }
}