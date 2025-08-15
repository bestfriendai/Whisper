import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisperdate/models/chat_room.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _chatRoomsCollection = 'chat_rooms';
  final String _messagesCollection = 'messages';

  // Get chat rooms
  Future<List<ChatRoom>> getChatRooms({
    String? location,
    String? topic,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore.collection(_chatRoomsCollection)
          .where('isActive', isEqualTo: true);

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isEqualTo: location);
      }

      if (topic != null && topic.isNotEmpty) {
        query = query.where('topic', isEqualTo: topic);
      }

      query = query.orderBy('lastActivity', descending: true).limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ChatRoom.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  // Stream chat rooms
  Stream<List<ChatRoom>> streamChatRooms({
    String? location,
    String? topic,
    int limit = 20,
  }) {
    Query query = _firestore.collection(_chatRoomsCollection)
        .where('isActive', isEqualTo: true);

    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }

    if (topic != null && topic.isNotEmpty) {
      query = query.where('topic', isEqualTo: topic);
    }

    query = query.orderBy('lastActivity', descending: true).limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatRoom.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    });
  }

  // Get messages for a chat room
  Stream<List<ChatMessage>> streamMessages(String roomId, {int limit = 50}) {
    return _firestore
        .collection(_chatRoomsCollection)
        .doc(roomId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList()
          .reversed
          .toList();
    });
  }

  // Send a message
  Future<void> sendMessage(ChatMessage message) async {
    try {
      final batch = _firestore.batch();

      // Add message to room's messages subcollection
      final messageRef = _firestore
          .collection(_chatRoomsCollection)
          .doc(message.roomId)
          .collection(_messagesCollection)
          .doc();

      batch.set(messageRef, message.toJson());

      // Update room's last activity
      final roomRef = _firestore.collection(_chatRoomsCollection).doc(message.roomId);
      batch.update(roomRef, {
        'lastActivity': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Join a chat room
  Future<void> joinRoom(String roomId, String userId) async {
    try {
      await _firestore.collection(_chatRoomsCollection).doc(roomId).update({
        'members': FieldValue.arrayUnion([userId]),
        'memberCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to join room: $e');
    }
  }

  // Leave a chat room
  Future<void> leaveRoom(String roomId, String userId) async {
    try {
      await _firestore.collection(_chatRoomsCollection).doc(roomId).update({
        'members': FieldValue.arrayRemove([userId]),
        'memberCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Failed to leave room: $e');
    }
  }

  // Create a chat room
  Future<String> createChatRoom(ChatRoom room) async {
    try {
      final docRef = await _firestore.collection(_chatRoomsCollection).add(room.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  // Get mock data for development
  List<ChatRoom> getMockChatRooms() {
    return [
      ChatRoom(
        id: '1',
        name: '🌟 Fort Washington Singles',
        description: 'Connect with local singles in Fort Washington area. Share experiences, meet new people, and find meaningful connections!',
        topic: 'Dating',
        location: 'Fort Washington, MD',
        imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=300&fit=crop',
        memberCount: 127,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        tags: ['singles', 'dating', 'local', 'relationships'],
        type: ChatRoomType.location,
        creatorId: 'user1',
      ),
      ChatRoom(
        id: '2',
        name: '💕 Coffee Date Stories',
        description: 'Share your coffee date experiences! From amazing first meetings to hilarious mishaps - all coffee date stories welcome.',
        topic: 'Coffee Dates',
        location: 'DMV Area',
        imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop',
        memberCount: 89,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 12)),
        tags: ['coffee', 'dates', 'stories', 'experiences'],
        type: ChatRoomType.topic,
        creatorId: 'user2',
      ),
      ChatRoom(
        id: '3',
        name: '🎭 Anonymous Confessions',
        description: 'A safe space to share dating confessions anonymously. Get advice, support, and connect with others who understand.',
        topic: 'Confessions',
        location: 'Anywhere',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        memberCount: 203,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
        tags: ['anonymous', 'confessions', 'advice', 'support'],
        type: ChatRoomType.topic,
        creatorId: 'user3',
      ),
      ChatRoom(
        id: '4',
        name: '🏃‍♀️ Active Dates DC',
        description: 'For those who love active dates! Hiking, running, gym partnerships, outdoor adventures and more in the DC area.',
        topic: 'Active Lifestyle',
        location: 'Washington, DC',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
        memberCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
        tags: ['active', 'fitness', 'outdoor', 'adventure'],
        type: ChatRoomType.hybrid,
        creatorId: 'user4',
      ),
      ChatRoom(
        id: '5',
        name: '🍷 Wine & Dine Reviews',
        description: 'Share reviews of restaurant dates, wine bars, and dining experiences. Find the perfect spots for romantic evenings!',
        topic: 'Dining',
        location: 'DMV Area',
        imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=400&h=300&fit=crop',
        memberCount: 94,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
        tags: ['dining', 'wine', 'restaurants', 'romantic'],
        type: ChatRoomType.topic,
        creatorId: 'user5',
      ),
      ChatRoom(
        id: '6',
        name: '🌈 LGBTQ+ Safe Space',
        description: 'A welcoming community for LGBTQ+ individuals to share dating experiences, advice, and connect in a supportive environment.',
        topic: 'LGBTQ+ Dating',
        location: 'DMV Area',
        imageUrl: 'https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=400&h=300&fit=crop',
        memberCount: 78,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 8)),
        tags: ['lgbtq', 'inclusive', 'support', 'community'],
        type: ChatRoomType.topic,
        creatorId: 'user6',
      ),
    ];
  }

  // Get mock messages for development
  List<ChatMessage> getMockMessages(String roomId) {
    final baseMessages = [
      ChatMessage(
        id: '1',
        roomId: roomId,
        senderId: 'user1',
        senderName: 'Alex M.',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
        content: 'Hey everyone! Just wanted to share my amazing coffee date experience from yesterday ☕️',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '2',
        roomId: roomId,
        senderId: 'user2',
        senderName: 'Sarah K.',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
        content: 'That sounds awesome! Where did you go? Always looking for new coffee spots 😊',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '3',
        roomId: roomId,
        senderId: 'user1',
        senderName: 'Alex M.',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
        content: 'We went to that new place on K Street - "Bean There Done That". The atmosphere was perfect and they had amazing pastries!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '4',
        roomId: roomId,
        senderId: 'user3',
        senderName: 'Mike R.',
        senderAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
        content: 'I love that place! Had a great first date there last month. The cozy corner tables are perfect for conversation 💫',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: MessageType.text,
      ),
      ChatMessage(
        id: '5',
        roomId: roomId,
        senderId: 'user2',
        senderName: 'Sarah K.',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face',
        content: 'Definitely adding it to my list! Thanks for the rec 🙌',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        type: MessageType.text,
      ),
    ];

    return baseMessages;
  }
}