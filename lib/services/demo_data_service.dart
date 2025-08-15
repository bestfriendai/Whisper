import 'dart:math';
import 'package:whisperdate/models/user.dart';
import 'package:whisperdate/models/review.dart';

// Type alias for compatibility
typedef User = AppUser;

class DemoDataService {
  static final Random _random = Random();

  // Sports-themed demo profile images (using placeholder URLs)
  static const List<String> maleAvatars = [
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400',
    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=400',
    'https://images.unsplash.com/photo-1548372290-8d01b6c8e78c?w=400',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
    'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
  ];

  static const List<String> femaleAvatars = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    'https://images.unsplash.com/photo-1513207565459-d7f36bfa1222?w=400',
  ];

  // Sports/activity images for reviews
  static const List<String> activityImages = [
    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800', // Running
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800', // Gym
    'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=800', // Basketball
    'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800', // Cycling
    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800', // Rock climbing
    'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800', // Soccer
    'https://images.unsplash.com/photo-1587280501635-3e9d3f772ae8?w=800', // Tennis
    'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800', // Swimming
  ];

  // Realistic names
  static const List<String> maleNames = [
    'Jake Thompson', 'Mike Rodriguez', 'Tyler Chen', 'Brandon Williams',
    'Kyle Anderson', 'Ryan Murphy', 'Jordan Taylor', 'Derek Johnson',
    'Marcus Davis', 'Alex Martinez', 'Chris Miller', 'Nathan Brown',
    'Justin Wilson', 'Kevin Lee', 'Matt Garcia', 'Anthony Smith',
    'Brad Cooper', 'Sean Mitchell', 'Eric Thomas', 'Jason Parker'
  ];

  static const List<String> femaleNames = [
    'Sarah Johnson', 'Jessica Miller', 'Ashley Davis', 'Amanda Wilson',
    'Emily Thompson', 'Megan Anderson', 'Rachel Martinez', 'Lauren Taylor',
    'Samantha Brown', 'Katie Rodriguez', 'Jennifer Chen', 'Nicole Williams',
    'Brittany Murphy', 'Christina Lee', 'Stephanie Garcia', 'Michelle Smith',
    'Danielle Cooper', 'Alexis Mitchell', 'Hannah Thomas', 'Victoria Parker'
  ];

  // Sports-themed bios
  static const List<String> maleBios = [
    'Former college basketball player. Still hit the court every weekend. Love competitive sports and staying active. Looking for someone who appreciates the athletic lifestyle.',
    'CrossFit enthusiast and marathon runner. Early morning gym sessions are my therapy. Seeking a partner who values fitness and healthy living.',
    'Weekend warrior - football in fall, basketball in winter, baseball in summer. Sports bar regular. Looking for someone to share game days with.',
    'Rock climbing instructor by day, MMA training by night. Adventure is my middle name. Want someone who can keep up with my active lifestyle.',
    'Golf on Saturdays, football on Sundays. Corporate league softball champion 3 years running. Looking for my teammate in life.',
    'Cycling is my passion - road, mountain, you name it. Completed 5 century rides last year. Seeking someone who loves outdoor adventures.',
    'Swimming coach and water polo player. Beach volleyball in summer. Ocean is my second home. Looking for someone who loves water sports.',
    'Soccer fanatic - play in two leagues and never miss a Premier League match. Traveled to 3 World Cups. Want someone who gets the beautiful game.',
    'Hockey player since age 5. Beer league legend. Season ticket holder. Looking for someone who appreciates the dedication to the game.',
    'Tennis instructor and former college player. Competed at nationals. Love the mental chess match of sports. Seeking an intellectual athlete.',
  ];

  static const List<String> femaleBios = [
    'Yoga instructor and trail runner. Balance is everything - in fitness and life. Looking for someone who values mindfulness and movement.',
    'Competitive swimmer turned triathlete. Early morning training is my meditation. Seeking a partner who understands the dedication.',
    'Dance and pilates keep me centered. Former cheerleader, still love the energy. Want someone who appreciates grace and strength.',
    'Volleyball player - beach and indoor. Travel for tournaments. Looking for someone who loves competition and teamwork.',
    'Personal trainer specializing in strength training. Empowering others through fitness. Want a partner who values health and growth.',
    'Marathon runner chasing Boston qualification. Running is my therapy. Looking for someone to share sunrise runs and post-race celebrations.',
    'Rock climbing and hiking enthusiast. Summited 14 peaks. Seeking an adventure partner for life\'s climbs.',
    'Basketball player in city league. Former college point guard. Love the strategy and flow of the game. Want someone who gets team dynamics.',
    'Tennis player and golf enthusiast. Country club regular. Looking for someone who enjoys the social side of sports.',
    'Fitness influencer and nutrition coach. Helping others achieve their goals. Seeking someone who shares my passion for wellness.',
  ];

  // Realistic review content
  static const List<Map<String, dynamic>> reviewTemplates = [
    {
      'title': 'Amazing gym date - perfect for fitness lovers!',
      'content': 'We met at the rock climbing gym for our first date. Started with some easy routes to break the ice, then tackled harder climbs together. The teamwork aspect really showed their personality - supportive, encouraging, and not afraid of a challenge. Grabbed protein smoothies after and talked for hours about our fitness goals. Definitely recommend active dates!',
      'rating': 5,
      'recommend': true,
      'tags': ['athletic', 'adventurous', 'teamwork']
    },
    {
      'title': 'Basketball game date was a slam dunk',
      'content': 'Went to a local college basketball game. They knew so much about the game and made it really fun even though I\'m not a huge sports fan. The energy was electric, we shared nachos and beer, and had great conversation during halftime. They were passionate but not overbearing about explaining plays. Really showed their fun side!',
      'rating': 4,
      'recommend': true,
      'tags': ['knowledgeable', 'fun', 'passionate']
    },
    {
      'title': 'Morning run turned into great connection',
      'content': 'Met at 6am for a sunrise run along the waterfront. They matched my pace perfectly and we had great conversation even while running. Stopped for coffee and breakfast after. Really appreciated how they made me feel comfortable about my fitness level. Shows dedication waking up that early for a date!',
      'rating': 5,
      'recommend': true,
      'tags': ['dedicated', 'considerate', 'energetic']
    },
    {
      'title': 'Gym bro vibes were too much',
      'content': 'Spent the entire date talking about their workout routine and critiquing my form. Felt more like a training session than a date. They were clearly knowledgeable but came across as condescending. Not everyone needs to deadlift 400lbs to be considered fit. Chemistry just wasn\'t there.',
      'rating': 2,
      'recommend': false,
      'tags': ['intense', 'critical', 'one-dimensional']
    },
    {
      'title': 'Tennis date showed true colors',
      'content': 'Played tennis at the local courts. They were patient teaching me the basics and made it really fun. We laughed a lot at my terrible serves. Grabbed lunch at the club after and met some of their tennis friends. Really welcoming crowd. Loved how they handled winning without being cocky.',
      'rating': 4,
      'recommend': true,
      'tags': ['patient', 'social', 'humble']
    },
    {
      'title': 'Yoga class date was surprisingly intimate',
      'content': 'Attended a partner yoga class together. Initially nervous but they made it comfortable and we ended up laughing through the awkward poses. The meditation at the end was actually really connecting. Green juice after and deep conversation about mindfulness and life goals. Not what I expected but pleasantly surprised!',
      'rating': 5,
      'recommend': true,
      'tags': ['open-minded', 'spiritual', 'surprising']
    },
    {
      'title': 'Hiking date revealed great character',
      'content': 'Moderate 5-mile hike with beautiful views. They came prepared with water and snacks to share. Great conversation about travel and outdoor adventures. When I twisted my ankle slightly, they were immediately helpful without making a big deal. The way someone acts in nature says a lot about them.',
      'rating': 5,
      'recommend': true,
      'tags': ['prepared', 'caring', 'outdoorsy']
    },
    {
      'title': 'CrossFit date was intimidating',
      'content': 'They insisted on their CrossFit box for the first date. The workout was way too intense for a beginner and they seemed more focused on their own workout than spending time together. Everyone there knew them and it felt cliquey. Not a good first date choice unless you know the person\'s fitness level.',
      'rating': 2,
      'recommend': false,
      'tags': ['intense', 'inconsiderate', 'cliquey']
    },
    {
      'title': 'Cycling tour was perfect pace',
      'content': 'Rented bikes and did a leisurely tour of the city. They knew great spots to stop for photos and snacks. Adjusted the pace when I got tired without making me feel bad. Ended at a brewery with live music. Active but not exhausting - perfect balance for getting to know someone.',
      'rating': 5,
      'recommend': true,
      'tags': ['thoughtful', 'flexible', 'fun']
    },
    {
      'title': 'Golf date showed patience and humor',
      'content': 'Mini golf followed by driving range. They were actually really good but made it fun and not competitive. Taught me proper grip and stance without being patronizing. We made silly bets on holes and laughed constantly. Drinks at the 19th hole sealed a great date.',
      'rating': 4,
      'recommend': true,
      'tags': ['patient', 'funny', 'skilled']
    },
  ];

  // Generate demo users
  static List<User> generateDemoUsers({int count = 20}) {
    List<User> users = [];
    
    for (int i = 0; i < count; i++) {
      bool isMale = _random.nextBool();
      String name = isMale 
        ? maleNames[_random.nextInt(maleNames.length)]
        : femaleNames[_random.nextInt(femaleNames.length)];
      
      String avatar = isMale
        ? maleAvatars[_random.nextInt(maleAvatars.length)]
        : femaleAvatars[_random.nextInt(femaleAvatars.length)];
      
      String bio = isMale
        ? maleBios[_random.nextInt(maleBios.length)]
        : femaleBios[_random.nextInt(femaleBios.length)];
      
      final now = DateTime.now().subtract(Duration(days: _random.nextInt(365)));
      users.add(User(
        id: 'user_$i',
        email: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
        displayName: name,
        profileImageUrl: avatar,
        bio: bio,
        age: 22 + _random.nextInt(18), // 22-40 years old
        gender: isMale ? Gender.male : Gender.female,
        datingPreference: [DatingPreference.values[_random.nextInt(3)]],
        location: Location(
          city: _getCityName(),
          state: _getStateName(),
          country: 'US',
          coords: Coordinates(
            lat: 25.0 + _random.nextDouble() * 25, // US latitude range
            lng: -125.0 + _random.nextDouble() * 55, // US longitude range
          ),
        ),
        preferences: UserPreferences(
          notifications: NotificationSettings(
            comments: true,
            likes: true,
            messages: true,
            newReviews: _random.nextBool(),
            chatMentions: true,
          ),
          privacy: PrivacySettings(
            showLocation: true,
            showOnlineStatus: true,
            allowMessages: MessagePrivacy.values[_random.nextInt(MessagePrivacy.values.length)],
            profileVisibility: ProfileVisibility.public,
          ),
          display: DisplaySettings(),
        ),
        stats: UserStats(
          reviewsPosted: _random.nextInt(50),
          commentsPosted: _random.nextInt(30),
          likesReceived: _random.nextInt(500),
          helpfulVotes: _random.nextInt(300),
          reputation: 3.5 + _random.nextDouble() * 1.5,
        ),
        isPremium: _random.nextDouble() > 0.7,
        lastSeen: now,
        createdAt: now,
        updatedAt: now,
      ));
    }
    
    return users;
  }

  // Generate demo reviews
  static List<Review> generateDemoReviews({int count = 30, List<User>? users}) {
    users ??= generateDemoUsers(count: 20);
    List<Review> reviews = [];
    
    for (int i = 0; i < count; i++) {
      var template = reviewTemplates[_random.nextInt(reviewTemplates.length)];
      var author = users[_random.nextInt(users.length)];
      var subject = users[_random.nextInt(users.length)];
      
      // Make sure author and subject are different
      while (subject.id == author.id) {
        subject = users[_random.nextInt(users.length)];
      }
      
      final createdAt = DateTime.now().subtract(Duration(
        days: _random.nextInt(90),
        hours: _random.nextInt(24),
      ));
      
      reviews.add(Review(
        id: 'review_$i',
        authorId: author.id,
        subjectName: subject.displayName ?? 'Anonymous',
        subjectAge: subject.age ?? 25,
        subjectGender: subject.gender ?? Gender.male,
        category: DatingPreference.values[_random.nextInt(3)],
        dateDuration: DateDuration.values[_random.nextInt(DateDuration.values.length)],
        dateYear: 2023 + _random.nextInt(2),
        relationshipType: RelationshipType.values[_random.nextInt(4)],
        title: template['title'],
        content: template['content'],
        rating: template['rating'],
        wouldRecommend: template['recommend'],
        greenFlags: [],
        redFlags: [],
        imageUrls: _random.nextBool() 
          ? [activityImages[_random.nextInt(activityImages.length)]]
          : [],
        location: Location(
          city: _getCityName(),
          state: _getStateName(),
          country: 'US',
          coords: Coordinates(
            lat: 25.0 + _random.nextDouble() * 25,
            lng: -125.0 + _random.nextDouble() * 55,
          ),
        ),
        stats: ReviewStats(
          likes: _random.nextInt(200),
          comments: _random.nextInt(50),
          views: 100 + _random.nextInt(2000),
        ),
        tags: List<String>.from(template['tags'] ?? []),
        createdAt: createdAt,
        updatedAt: createdAt,
      ));
    }
    
    // Sort by creation date (newest first)
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return reviews;
  }

  // Helper methods for location generation
  static String _getCityName() {
    const cities = [
      'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
      'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'Austin',
      'San Francisco', 'Seattle', 'Denver', 'Boston', 'Miami',
      'Atlanta', 'Portland', 'Nashville', 'Charlotte', 'Orlando'
    ];
    return cities[_random.nextInt(cities.length)];
  }

  static String _getStateName() {
    const states = [
      'NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'TX',
      'CA', 'WA', 'CO', 'MA', 'FL', 'GA', 'OR', 'TN', 'NC', 'FL'
    ];
    return states[_random.nextInt(states.length)];
  }

  // Generate trending topics
  static List<String> getTrendingTopics() {
    return [
      '#GymDate',
      '#ActiveLifestyle', 
      '#FitnessFirst',
      '#TeamworkMakesTheDreamWork',
      '#HealthyRelationships',
      '#SweatTogether',
      '#AdventurePartner',
      '#GameDayDates',
      '#RunningBuddy',
      '#FitCouple'
    ];
  }

  // Generate activity suggestions
  static List<Map<String, String>> getActivitySuggestions() {
    return [
      {
        'title': 'Rock Climbing',
        'description': 'Build trust and teamwork scaling walls together',
        'difficulty': 'Moderate',
        'icon': '🧗‍♂️'
      },
      {
        'title': 'Tennis Match',
        'description': 'Friendly competition with built-in conversation breaks',
        'difficulty': 'Easy-Moderate',
        'icon': '🎾'
      },
      {
        'title': 'Morning Run',
        'description': 'Start the day with endorphins and sunrise views',
        'difficulty': 'Adjustable',
        'icon': '🏃‍♀️'
      },
      {
        'title': 'Yoga Class',
        'description': 'Connect through mindfulness and movement',
        'difficulty': 'Easy',
        'icon': '🧘‍♂️'
      },
      {
        'title': 'Basketball Game',
        'description': 'High energy date with constant action',
        'difficulty': 'Moderate',
        'icon': '🏀'
      },
      {
        'title': 'Bike Tour',
        'description': 'Explore the city at your own pace',
        'difficulty': 'Easy-Moderate',
        'icon': '🚴‍♀️'
      },
    ];
  }
}