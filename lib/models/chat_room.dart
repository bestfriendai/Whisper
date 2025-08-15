class ChatRoom {
  final String id;
  final String name;
  final String description;
  final String topic;
  final String location;
  final String imageUrl;
  final int memberCount;
  final DateTime createdAt;
  final DateTime lastActivity;
  final List<String> tags;
  final bool isActive;
  final ChatRoomType type;
  final String? creatorId;
  final List<String> members;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.topic,
    required this.location,
    required this.imageUrl,
    required this.memberCount,
    required this.createdAt,
    required this.lastActivity,
    required this.tags,
    this.isActive = true,
    required this.type,
    this.creatorId,
    this.members = const [],
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      topic: json['topic'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
      lastActivity: json['lastActivity']?.toDate() ?? DateTime.now(),
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] ?? true,
      type: ChatRoomType.values.firstWhere(
        (t) => t.toString().split('.').last == (json['type'] ?? 'topic'),
        orElse: () => ChatRoomType.topic,
      ),
      creatorId: json['creatorId'],
      members: List<String>.from(json['members'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'topic': topic,
      'location': location,
      'imageUrl': imageUrl,
      'memberCount': memberCount,
      'createdAt': createdAt,
      'lastActivity': lastActivity,
      'tags': tags,
      'isActive': isActive,
      'type': type.toString().split('.').last,
      'creatorId': creatorId,
      'members': members,
    };
  }
}

enum ChatRoomType {
  location,
  topic,
  hybrid, // Both location and topic based
}

class ChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isAnonymous;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isAnonymous = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      roomId: json['roomId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      content: json['content'] ?? '',
      timestamp: json['timestamp']?.toDate() ?? DateTime.now(),
      type: MessageType.values.firstWhere(
        (t) => t.toString().split('.').last == (json['type'] ?? 'text'),
        orElse: () => MessageType.text,
      ),
      isAnonymous: json['isAnonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'timestamp': timestamp,
      'type': type.toString().split('.').last,
      'isAnonymous': isAnonymous,
    };
  }
}

enum MessageType {
  text,
  image,
  system,
}