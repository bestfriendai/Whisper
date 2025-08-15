import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lockerroomtalk/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  List<NotificationData> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      final appState = context.read<AppStateProvider>();
      if (appState.currentUser != null) {
        _notifications = await NotificationService().getUserNotifications(
          appState.currentUser!.id,
        );
      }
      
      // Fallback to mock data if no notifications
      if (_notifications.isEmpty) {
        _notifications = _generateMockNotifications();
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      // Fallback to mock data on error
      setState(() {
        _notifications = _generateMockNotifications();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
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
                        Icons.notifications_rounded,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Notifications',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_notifications.where((n) => !n.isRead).length} unread',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _markAllAsRead,
                  icon: Icon(
                    Icons.mark_email_read_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Mark all as read',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'clear_all':
                        _clearAllNotifications();
                        break;
                      case 'settings':
                        Navigator.pushNamed(context, '/settings');
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 12),
                          Text('Clear All'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.all_inbox_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text('All (${_notifications.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mark_email_unread_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text('Unread (${_notifications.where((n) => !n.isRead).length})'),
                    ],
                  ),
                ),
                const Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alternate_email_rounded, size: 18),
                      SizedBox(width: 6),
                      Text('Mentions'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationsList(_notifications),
                  _buildNotificationsList(_notifications.where((n) => !n.isRead).toList()),
                  _buildNotificationsList(_notifications.where((n) => n.type == NotificationType.comment).toList()),
                ],
              ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationData> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildNotificationCard(notifications[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
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
                  theme.colorScheme.primary.withValues(alpha: 0.2),
                  theme.colorScheme.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see notifications here when they arrive',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationData notification) {
    // Mark as read
    if (!notification.isRead) {
      NotificationService().markAsRead(notification.id);
    }
    
    // Navigate based on notification type and data
    final data = notification.data ?? {};
    
    switch (notification.type) {
      case NotificationType.like:
      case NotificationType.comment:
        if (data['reviewId'] != null) {
          Navigator.pushNamed(context, '/review/${data['reviewId']}');
        }
        break;
      case NotificationType.message:
        if (data['chatRoomId'] != null) {
          Navigator.pushNamed(context, '/chat/${data['chatRoomId']}');
        }
        break;
      case NotificationType.follow:
        if (data['fromUserId'] != null) {
          Navigator.pushNamed(context, '/profile/${data['fromUserId']}');
        }
        break;
      case NotificationType.review:
        if (data['reviewId'] != null) {
          Navigator.pushNamed(context, '/review/${data['reviewId']}');
        }
        break;
      case NotificationType.system:
        // Handle system notifications
        break;
    }
  }

  void _dismissNotification(NotificationData notification) {
    NotificationService().deleteNotification(notification.id);
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });
  }

  void _markAllAsRead() async {
    final appState = context.read<AppStateProvider>();
    if (appState.currentUser != null) {
      await NotificationService().markAllAsRead(appState.currentUser!.id);
      await _loadNotifications();
    }
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final appState = context.read<AppStateProvider>();
              if (appState.currentUser != null) {
                await NotificationService().deleteAllNotifications(appState.currentUser!.id);
                setState(() => _notifications.clear());
              }
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationData notification) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;
    
    return Card(
      elevation: isUnread ? 2 : 0,
      color: isUnread ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: isUnread ? Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ) : null,
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }
  
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.message:
        return Colors.purple;
      case NotificationType.review:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
    }
  }
  
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.review:
        return Icons.rate_review;
      case NotificationType.system:
        return Icons.info;
    }
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  List<NotificationData> _generateMockNotifications() {
    final now = DateTime.now();
    
    return [
      NotificationData(
        id: '1',
        userId: 'current_user',
        type: NotificationType.like,
        title: 'New Like!',
        body: 'Sarah K. liked your review "Amazing coffee date experience!"',
        data: {'fromUserId': 'user2', 'reviewId': 'review_1', 'action': 'like'},
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationData(
        id: '2',
        userId: 'current_user',
        type: NotificationType.comment,
        title: 'New Comment!',
        body: 'Alex M. commented on your review "Great conversation over dinner": "This sounds amazing! Where did you go?"',
        data: {'fromUserId': 'user1', 'reviewId': 'review_2', 'action': 'comment'},
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      NotificationData(
        id: '3',
        userId: 'current_user',
        type: NotificationType.follow,
        title: 'New Follower!',
        body: 'Mike R. started following you',
        data: {'fromUserId': 'user3', 'action': 'follow'},
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationData(
        id: '4',
        userId: 'current_user',
        type: NotificationType.review,
        title: 'New Review About You!',
        body: 'Jordan T. posted a review about you: "Wonderful museum date"',
        data: {'fromUserId': 'user4', 'reviewId': 'review_3', 'action': 'review'},
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      NotificationData(
        id: '5',
        userId: 'current_user',
        type: NotificationType.message,
        title: 'New Message!',
        body: 'Casey L.: "Hey! I saw your review about that new coffee shop. Would love to check it out sometime!"',
        data: {'fromUserId': 'user5', 'chatRoomId': 'room_1', 'action': 'message'},
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      NotificationData(
        id: '6',
        userId: 'current_user',
        type: NotificationType.system,
        title: 'Welcome to WhisperDate!',
        body: 'Thanks for joining our community. Start by creating your first review!',
        data: {'action': 'welcome'},
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}