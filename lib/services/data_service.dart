import 'dart:math';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/models/user.dart';
import 'package:lockerroomtalk/models/chat_room.dart';
import 'package:lockerroomtalk/services/review_service.dart';
import 'package:lockerroomtalk/services/user_service.dart';
import 'package:lockerroomtalk/services/chat_service.dart';
import 'package:lockerroomtalk/services/comment_service.dart';

/// Central data service that provides mock data for development
/// and coordinates data fetching across different services
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final ReviewService _reviewService = ReviewService();
  final UserService _userService = UserService();
  final ChatService _chatService = ChatService();
  final CommentService _commentService = CommentService();

  final Random _random = Random();

  // Profile images from Unsplash
  final List<String> _profileImages = [
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=150&h=150&fit=crop&crop=face',
  ];

  // Date activity images
  final List<String> _dateImages = [
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop', // Coffee
    'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=400&h=300&fit=crop', // Restaurant
    'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&h=300&fit=crop', // Cinema
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', // Hiking
    'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=300&fit=crop', // Park
    'https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=400&h=300&fit=crop', // Museum
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop', // Beach
    'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400&h=300&fit=crop', // Concert
  ];

  final List<String> _firstNames = [
    'Alex', 'Jordan', 'Taylor', 'Casey', 'Morgan', 'Riley', 'Avery', 'Quinn',
    'Cameron', 'Sage', 'River', 'Phoenix', 'Blake', 'Dakota', 'Skylar', 'Rowan'
  ];

  final List<String> _lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas'
  ];

  final List<String> _reviewTitles = [
    'Amazing coffee date experience!',
    'Great conversation over dinner',
    'Fun hiking adventure together',
    'Lovely evening at the museum',
    'Perfect first date vibes',
    'Unexpected connection at the park',
    'Wonderful time at the farmers market',
    'Beautiful sunset walk by the river',
    'Cozy movie night that went perfectly',
    'Dancing under the stars',
    'Brunch date that lasted hours',
    'Art gallery visit turned magical',
    'Beach day filled with laughter',
    'Concert experience we\'ll never forget',
    'Simple picnic, extraordinary connection',
  ];

  final List<String> _reviewContents = [
    'We met at this cozy coffee shop downtown and had the most amazing conversation. The atmosphere was perfect, and we talked for hours about everything from travel to our favorite books. They were so genuinely interested in what I had to say, and I felt completely comfortable being myself.',
    
    'This dinner date exceeded all my expectations! We went to that new Italian place on Main Street, and the food was incredible. But what made it special was how easy the conversation flowed. We laughed so much that other diners started looking over, but we didn\'t care.',
    
    'I was nervous about suggesting a hiking date, but it turned out to be perfect! We took the trail at Rock Creek Park, and it was beautiful. Having an activity to do together took the pressure off, and we got to see each other\'s adventurous side.',
    
    'Who knew a museum date could be so romantic? We spent the entire afternoon at the Smithsonian, and they had such interesting insights about the exhibits. It was clear they were well-educated and curious about the world.',
    
    'Sometimes the simplest dates are the best. We just walked around the neighborhood, grabbed some ice cream, and sat in the park talking until the sun went down. There was something so genuine and refreshing about keeping things low-key.',
    
    'This person suggested we meet at the farmers market, and it was such a creative idea! We wandered around, tried different samples, and picked out ingredients to cook together later. It felt so natural and fun.',
    
    'The evening started with dinner, but we were having such a good time that we decided to take a walk along the waterfront. The conversation never stopped, and we discovered we have so many shared interests and values.',
    
    'I\'ll be honest - I was skeptical about meeting someone online, but this date completely changed my perspective. They were even more charming in person, and we had incredible chemistry from the moment we met.',
  ];

  final List<String> _locations = [
    'Fort Washington, MD',
    'Alexandria, VA',
    'Washington, DC',
    'Bethesda, MD',
    'Arlington, VA',
    'Silver Spring, MD',
    'Fairfax, VA',
    'Rockville, MD',
  ];

  /// Generate comprehensive mock data for the app
  Future<void> initializeMockData() async {
    // This would be called on app startup to populate with sample data
    // In production, this would sync with backend/Firebase
  }

  /// Generate mock reviews with realistic data
  List<Review> generateMockReviews({int count = 10, int startIndex = 0}) {
    final reviews = <Review>[];
    
    for (int i = 0; i < count; i++) {
      final index = startIndex + i;
      final authorId = 'user_${(index % 20) + 1}';
      
      final review = Review(
        id: 'review_$index',
        authorId: authorId,
        subjectName: _generateRandomName(),
        subjectAge: 22 + _random.nextInt(20), // Ages 22-41
        subjectGender: Gender.values[_random.nextInt(Gender.values.length)],
        category: DatingPreference.values[_random.nextInt(DatingPreference.values.length)],
        dateDuration: DateDuration.values[_random.nextInt(DateDuration.values.length)],
        dateYear: DateTime.now().year - _random.nextInt(2), // This year or last
        relationshipType: RelationshipType.values[_random.nextInt(RelationshipType.values.length)],
        title: _reviewTitles[_random.nextInt(_reviewTitles.length)],
        content: _reviewContents[_random.nextInt(_reviewContents.length)],
        rating: 3 + _random.nextInt(3), // Ratings 3-5 (mostly positive)
        wouldRecommend: _random.nextBool(),
        greenFlags: _generateRandomFlags(PredefinedFlags.greenFlags, maxCount: 4),
        redFlags: _generateRandomFlags(PredefinedFlags.redFlags, maxCount: 2),
        imageUrls: _generateRandomImages(),
        location: _generateRandomLocation(),
        stats: ReviewStats(
          likes: _random.nextInt(50),
          comments: _random.nextInt(20),
          shares: _random.nextInt(10),
          views: 50 + _random.nextInt(500),
          helpful: _random.nextInt(25),
          notHelpful: _random.nextInt(5),
        ),
        createdAt: DateTime.now().subtract(Duration(
          days: _random.nextInt(30),
          hours: _random.nextInt(24),
        )),
        updatedAt: DateTime.now().subtract(Duration(
          days: _random.nextInt(30),
          hours: _random.nextInt(24),
        )),
      );
      
      reviews.add(review);
    }
    
    return reviews;
  }

  /// Generate mock users
  List<AppUser> generateMockUsers({int count = 20}) {
    final users = <AppUser>[];
    
    for (int i = 0; i < count; i++) {
      final user = AppUser(
        id: 'user_${i + 1}',
        email: '${_firstNames[i % _firstNames.length].toLowerCase()}.${_lastNames[i % _lastNames.length].toLowerCase()}@example.com',
        username: '${_firstNames[i % _firstNames.length].toLowerCase()}${_random.nextInt(999)}',
        displayName: _generateRandomName(),
        profileImageUrl: _profileImages[i % _profileImages.length],
        bio: _generateBio(),
        age: 21 + _random.nextInt(25), // Ages 21-45
        gender: Gender.values[_random.nextInt(Gender.values.length)],
        datingPreference: [DatingPreference.values[_random.nextInt(DatingPreference.values.length)]],
        location: _generateRandomLocation(),
        preferences: UserPreferences(
          notifications: NotificationSettings(),
          privacy: PrivacySettings(),
          display: DisplaySettings(),
        ),
        stats: UserStats(
          reviewsPosted: _random.nextInt(25),
          commentsPosted: _random.nextInt(50),
          likesReceived: _random.nextInt(100),
          helpfulVotes: _random.nextInt(30),
          reputation: _random.nextDouble() * 100,
          level: 1 + _random.nextInt(5),
        ),
        emailVerified: true,
        lastSeen: DateTime.now().subtract(Duration(minutes: _random.nextInt(1440))),
        createdAt: DateTime.now().subtract(Duration(days: 30 + _random.nextInt(365))),
        updatedAt: DateTime.now().subtract(Duration(days: _random.nextInt(7))),
      );
      
      users.add(user);
    }
    
    return users;
  }

  String _generateRandomName() {
    return '${_firstNames[_random.nextInt(_firstNames.length)]} ${_lastNames[_random.nextInt(_lastNames.length)]}';
  }

  String _generateBio() {
    final bios = [
      'Love exploring new coffee shops and hiking trails ☕🥾',
      'Foodie, bookworm, and adventure seeker 📚🍕',
      'Artist by day, Netflix enthusiast by night 🎨📺',
      'Fitness enthusiast who loves trying new restaurants 💪🍽️',
      'Travel lover and photography hobbyist ✈️📷',
      'Dog parent, yoga practitioner, wine enthusiast 🐕🧘‍♀️🍷',
      'Music lover who enjoys concerts and quiet evenings 🎵🏠',
      'Outdoor adventurer who also loves cozy movie nights ⛰️🎬',
    ];
    
    return bios[_random.nextInt(bios.length)];
  }

  Location _generateRandomLocation() {
    final location = _locations[_random.nextInt(_locations.length)];
    final parts = location.split(', ');
    
    return Location(
      city: parts[0],
      state: parts[1],
      country: 'US',
      coords: Coordinates(
        lat: 38.7 + (_random.nextDouble() - 0.5) * 0.5, // DMV area coordinates
        lng: -77.0 + (_random.nextDouble() - 0.5) * 0.5,
      ),
    );
  }

  List<Flag> _generateRandomFlags(List<Flag> availableFlags, {int maxCount = 3}) {
    final shuffled = List<Flag>.from(availableFlags)..shuffle(_random);
    final count = 1 + _random.nextInt(maxCount);
    return shuffled.take(count).toList();
  }

  List<String> _generateRandomImages() {
    if (_random.nextBool()) return []; // 50% chance of no images
    
    final count = 1 + _random.nextInt(3); // 1-3 images
    final shuffled = List<String>.from(_dateImages)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  /// Get popular hashtags/topics
  List<String> getPopularTopics() {
    return [
      'coffee dates',
      'dinner dates',
      'hiking',
      'museums',
      'concerts',
      'beach dates',
      'farmers market',
      'wine tasting',
      'art galleries',
      'sports events',
      'cooking together',
      'dancing',
      'bookstore browsing',
      'mini golf',
      'rooftop bars'
    ];
  }

  /// Get trending locations
  List<String> getTrendingLocations() {
    return _locations;
  }

  /// Get date ideas
  List<String> getDateIdeas() {
    return [
      'Coffee and conversation at a local cafe',
      'Sunset walk along the waterfront',
      'Visit to a farmers market',
      'Museum or gallery exploration',
      'Hiking in a nearby park',
      'Cooking class together',
      'Wine tasting experience',
      'Live music or concert',
      'Bookstore browsing and tea',
      'Mini golf or arcade games',
      'Picnic in the park',
      'Food truck hopping',
      'Art class or pottery painting',
      'Dancing lessons',
      'Rooftop bar with city views'
    ];
  }
}