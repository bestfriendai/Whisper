import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/chat_room.dart';
import '../../models/user.dart';
import '../../theme_modern.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';

class ModernChatScreen extends StatefulWidget {
  final ChatRoom? chatRoom;
  
  const ModernChatScreen({
    super.key,
    this.chatRoom,
  });

  @override
  State<ModernChatScreen> createState() => _ModernChatScreenState();
}

class _ModernChatScreenState extends State<ModernChatScreen>
    with TickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  
  late AnimationController _listController;
  late AnimationController _inputController;
  late Animation<Offset> _listSlideAnimation;
  late Animation<Offset> _inputSlideAnimation;
  
  List<ChatRoom> _chatRooms = [];
  List<Message> _messages = [];
  AppUser? _currentUser;
  bool _isLoading = true;
  bool _isTyping = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    _listController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _inputController = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _listSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _inputSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _inputController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _loadData();
  }

  @override
  void dispose() {
    _listController.dispose();
    _inputController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      
      if (widget.chatRoom != null) {
        // Load messages for specific chat
        final messages = await _chatService.getMessages(widget.chatRoom!.id);
        setState(() {
          _messages = messages;
          _currentUser = currentUser;
          _isLoading = false;
        });
      } else {
        // Load chat rooms list
        final chatRooms = await _chatService.getUserChatRooms();
        setState(() {
          _chatRooms = chatRooms;
          _currentUser = currentUser;
          _isLoading = false;
        });
      }
      
      _listController.forward();
      _inputController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || widget.chatRoom == null) return;
    
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatRoomId: widget.chatRoom!.id,
      senderId: _currentUser!.id,
      content: text,
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
    
    HapticFeedback.lightImpact();
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: ModernDuration.fast,
        curve: ModernCurves.easeOutQuart,
      );
    });
    
    // Send to service
    _chatService.sendMessage(widget.chatRoom!.id, text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (widget.chatRoom != null) {
      return _buildChatInterface(theme);
    } else {
      return _buildChatList(theme);
    }
  }

  Widget _buildChatList(ThemeData theme) {
    final safePadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Column(
        children: [
          // App bar
          Container(
            padding: EdgeInsets.only(
              left: ModernSpacing.lg,
              right: ModernSpacing.lg,
              top: safePadding.top + ModernSpacing.sm,
              bottom: ModernSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Messages',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // New message
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Search bar
          Container(
            margin: const EdgeInsets.all(ModernSpacing.md),
            padding: const EdgeInsets.symmetric(
              horizontal: ModernSpacing.md,
              vertical: ModernSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(ModernRadius.full),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: ModernSpacing.sm),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          
          // Chat list
          Expanded(
            child: SlideTransition(
              position: _listSlideAnimation,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.md),
                itemCount: _chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = _chatRooms[index];
                  return _buildChatListItem(chatRoom, theme);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatListItem(ChatRoom chatRoom, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: ModernSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ModernChatScreen(chatRoom: chatRoom),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(ModernSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(ModernRadius.md),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Icon(
                          Icons.person,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 28,
                        ),
                      ),
                    ),
                    
                    // Online indicator
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: ModernColors.success,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: ModernSpacing.md),
                
                // Chat info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatRoom.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatTime(chatRoom.lastMessageTime),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 2),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatRoom.lastMessage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chatRoom.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: ModernColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                chatRoom.unreadCount.toString(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
  }

  Widget _buildChatInterface(ThemeData theme) {
    final safePadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Column(
        children: [
          // Chat header
          Container(
            padding: EdgeInsets.only(
              left: ModernSpacing.sm,
              right: ModernSpacing.md,
              top: safePadding.top,
              bottom: ModernSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: ModernSpacing.sm),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatRoom!.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_isTyping)
                        Text(
                          'typing...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ModernColors.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Text(
                          'Online',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ModernColors.success,
                          ),
                        ),
                    ],
                  ),
                ),
                
                IconButton(
                  onPressed: () {
                    // Video call
                  },
                  icon: Icon(
                    Icons.videocam_outlined,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                
                IconButton(
                  onPressed: () {
                    // More options
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: SlideTransition(
              position: _listSlideAnimation,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(ModernSpacing.md),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message.senderId == _currentUser?.id;
                  final showAvatar = index == _messages.length - 1 ||
                      _messages[index + 1].senderId != message.senderId;
                  
                  return _buildMessageBubble(message, isMe, showAvatar, theme);
                },
              ),
            ),
          ),
          
          // Input area
          SlideTransition(
            position: _inputSlideAnimation,
            child: _buildInputArea(theme, safePadding),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    Message message,
    bool isMe,
    bool showAvatar,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: ModernSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: ModernSpacing.sm),
          ] else if (!isMe) ...[
            const SizedBox(width: 40),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: ModernSpacing.md,
                vertical: ModernSpacing.sm,
              ),
              decoration: BoxDecoration(
                gradient: isMe ? ModernColors.primaryGradient : null,
                color: isMe ? null : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(ModernRadius.lg),
                  topRight: const Radius.circular(ModernRadius.lg),
                  bottomLeft: Radius.circular(isMe ? ModernRadius.lg : ModernRadius.xs),
                  bottomRight: Radius.circular(isMe ? ModernRadius.xs : ModernRadius.lg),
                ),
                boxShadow: isMe ? ModernShadows.small : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isMe ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatMessageTime(message.timestamp),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isMe
                              ? Colors.white.withOpacity(0.8)
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? ModernColors.info
                              : Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, EdgeInsets safePadding) {
    return Container(
      padding: EdgeInsets.only(
        left: ModernSpacing.md,
        right: ModernSpacing.md,
        top: ModernSpacing.sm,
        bottom: ModernSpacing.sm + safePadding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {
              // Attachment options
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: theme.colorScheme.primary,
            ),
          ),
          
          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(ModernRadius.full),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
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
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) {
                  // Handle typing indicator
                },
              ),
            ),
          ),
          
          // Send button
          IconButton(
            onPressed: _sendMessage,
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: ModernColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 7) {
      return '${time.day}/${time.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}