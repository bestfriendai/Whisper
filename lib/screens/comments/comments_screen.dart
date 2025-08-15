import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:whisperdate/models/review.dart';
import 'package:whisperdate/widgets/gradient_button.dart';

class CommentsScreen extends StatefulWidget {
  final Review review;

  const CommentsScreen({
    super.key,
    required this.review,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _commentFocusNode = FocusNode();
  
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _replyingToId;
  
  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _comments = _generateMockComments();
      _isLoading = false;
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newComment = Comment(
        id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
        reviewId: widget.review.id,
        authorId: 'current_user',
        authorName: 'You',
        authorAvatar: 'https://pixabay.com/get/ga4b1d2484b8146f04856371a2b143af455c67050b60e8020bc8373e15e5cc8f867d8606c1d30a8d8c7ce26f0fd2a4d03dbf9a6d2eb5dbfacb635138c6d66e8ad_1280.jpg',
        content: _commentController.text.trim(),
        parentId: _replyingToId,
        createdAt: DateTime.now(),
      );
      
      setState(() {
        if (_replyingToId != null) {
          // Add as reply
          final parentIndex = _comments.indexWhere((c) => c.id == _replyingToId);
          if (parentIndex != -1) {
            _comments[parentIndex].replies.add(newComment);
          }
        } else {
          // Add as new comment
          _comments.insert(0, newComment);
        }
        _commentController.clear();
        _replyingToId = null;
      });
      
      // Provide haptic feedback
      HapticFeedback.lightImpact();
      
      // Unfocus the text field
      _commentFocusNode.unfocus();
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post comment: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _replyToComment(Comment comment) {
    setState(() => _replyingToId = comment.id);
    _commentFocusNode.requestFocus();
    _commentController.text = '@${comment.authorName} ';
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _commentController.text.length),
    );
  }

  void _cancelReply() {
    setState(() => _replyingToId = null);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments (${_getTotalCommentsCount()})'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'sort_newest':
                  _sortComments(CommentSort.newest);
                  break;
                case 'sort_oldest':
                  _sortComments(CommentSort.oldest);
                  break;
                case 'sort_likes':
                  _sortComments(CommentSort.likes);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_newest',
                child: Row(
                  children: [
                    Icon(Icons.new_releases),
                    SizedBox(width: 12),
                    Text('Newest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort_oldest',
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 12),
                    Text('Oldest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort_likes',
                child: Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 12),
                    Text('Most Liked'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Review summary
          _buildReviewSummary(context),
          
          // Comments list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? _buildEmptyState(context)
                    : RefreshIndicator(
                        onRefresh: _loadComments,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _comments.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return CommentCard(
                              comment: _comments[index],
                              onReply: () => _replyToComment(_comments[index]),
                              onLike: () => _likeComment(_comments[index]),
                              onReport: () => _reportComment(_comments[index]),
                            );
                          },
                        ),
                      ),
          ),
          
          // Comment input
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildReviewSummary(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  widget.review.subjectName[0].toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.review.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < widget.review.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.review.rating}/5',
                          style: theme.textTheme.bodySmall?.copyWith(
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
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
              Icons.chat_bubble_outline,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Comments Yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your thoughts!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Reply indicator
            if (_replyingToId != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Replying to comment',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _cancelReply,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Input field
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    'Y',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 5,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: _commentController.text.trim().isNotEmpty && !_isSubmitting
                        ? _submitComment
                        : null,
                    icon: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: _commentController.text.trim().isNotEmpty
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                    style: IconButton.styleFrom(
                      backgroundColor: _commentController.text.trim().isNotEmpty
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalCommentsCount() {
    int count = _comments.length;
    for (final comment in _comments) {
      count += comment.replies.length;
    }
    return count;
  }

  void _sortComments(CommentSort sort) {
    setState(() {
      switch (sort) {
        case CommentSort.newest:
          _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case CommentSort.oldest:
          _comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case CommentSort.likes:
          _comments.sort((a, b) => b.likes.compareTo(a.likes));
          break;
      }
    });
  }

  void _likeComment(Comment comment) {
    setState(() {
      if (comment.isLiked) {
        comment.likes--;
        comment.isLiked = false;
      } else {
        comment.likes++;
        comment.isLiked = true;
      }
    });
    
    HapticFeedback.lightImpact();
  }

  void _reportComment(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Comment'),
        content: const Text('Are you sure you want to report this comment as inappropriate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Comment reported successfully'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  List<Comment> _generateMockComments() {
    final now = DateTime.now();
    
    return [
      Comment(
        id: 'comment_1',
        reviewId: widget.review.id,
        authorId: 'user_1',
        authorName: 'Jordan Smith',
        authorAvatar: 'https://pixabay.com/get/g77e909a4c4fc6173fe3fb8df5e2c007d89ac828099b22eb99967c162c001460edcb7136da4a0f5055ab3c6fe4ceea023eafeee94ba6c2f79ebe22681d273f483_1280.jpg',
        content: 'Thanks for sharing this! Really helpful review.',
        likes: 12,
        createdAt: now.subtract(const Duration(hours: 2)),
        replies: [
          Comment(
            id: 'reply_1',
            reviewId: widget.review.id,
            authorId: 'user_2',
            authorName: 'Alex Chen',
            authorAvatar: 'https://pixabay.com/get/g5627763d38653f1b1c34715d2a174ba5912492b8b431f2cb44f1f2417ea7af2b676290517629d417e19b6ad8bbf6513d9db11ce6f2b9a0497489523bb6d56116_1280.jpg',
            content: '@Jordan Smith Totally agree! This gives me a good idea of what to expect.',
            likes: 5,
            createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
            parentId: 'comment_1',
          ),
        ],
      ),
      Comment(
        id: 'comment_2',
        reviewId: widget.review.id,
        authorId: 'user_3',
        authorName: 'Sam Rodriguez',
        authorAvatar: 'https://pixabay.com/get/g40d9394bac618d7a33e7e1f8508cd67d08214c1095d1bc2ff1511babea0f761c981c80fafef905f93cec5809e99a33a062bb1fa9e33572a53ee98458b9b1580f_1280.jpg',
        content: 'I had a similar experience! Those green flags are so important.',
        likes: 8,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      Comment(
        id: 'comment_3',
        reviewId: widget.review.id,
        authorId: 'user_4',
        authorName: 'Taylor Johnson',
        authorAvatar: 'https://pixabay.com/get/ga4b1d2484b8146f04856371a2b143af455c67050b60e8020bc8373e15e5cc8f867d8606c1d30a8d8c7ce26f0fd2a4d03dbf9a6d2eb5dbfacb635138c6d66e8ad_1280.jpg',
        content: 'Great detail in this review. The location tips are especially helpful for planning dates in that area.',
        likes: 15,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final VoidCallback onReport;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onLike,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        _buildCommentTile(context, comment, false),
        
        // Replies
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 12),
            child: Column(
              children: comment.replies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCommentTile(context, reply, true),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentTile(BuildContext context, Comment comment, bool isReply) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isReply ? 16 : 20,
          backgroundImage: comment.authorAvatar != null
              ? NetworkImage(comment.authorAvatar!)
              : null,
          child: comment.authorAvatar == null
              ? Text(
                  comment.authorName[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isReply ? 12 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.authorName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatCommentTime(comment.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          comment.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: comment.isLiked
                              ? Colors.red
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comment.likes.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: comment.isLiked
                                ? Colors.red
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (!isReply)
                    GestureDetector(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showCommentOptions(context),
                    child: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: comment.content));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.red),
              title: const Text('Report', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onReport();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCommentTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class Comment {
  final String id;
  final String reviewId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String? parentId;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.reviewId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.parentId,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    List<Comment>? replies,
  }) : replies = replies ?? [];
}

enum CommentSort {
  newest,
  oldest,
  likes,
}