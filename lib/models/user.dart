class AppUser {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  final int? age;
  final Gender? gender;
  final List<DatingPreference> datingPreference;
  final Location location;
  final UserPreferences preferences;
  final UserStats stats;
  final ModerationStatus moderationStatus;
  final bool onboardingCompleted;
  final bool emailVerified;
  final bool isAdmin;
  final bool isModerator;
  final bool isPremium;
  final DateTime? premiumUntil;
  final List<String> blockedUsers;
  final List<String> followingUsers;
  final List<String> savedReviews;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.bio,
    this.age,
    this.gender,
    required this.datingPreference,
    required this.location,
    required this.preferences,
    required this.stats,
    this.moderationStatus = ModerationStatus.active,
    this.onboardingCompleted = false,
    this.emailVerified = false,
    this.isAdmin = false,
    this.isModerator = false,
    this.isPremium = false,
    this.premiumUntil,
    this.blockedUsers = const [],
    this.followingUsers = const [],
    this.savedReviews = const [],
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'],
      displayName: map['displayName'],
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'],
      age: map['age'],
      gender: map['gender'] != null ? Gender.values.firstWhere(
        (g) => g.toString().split('.').last == map['gender']
      ) : null,
      datingPreference: (map['datingPreference'] as List<dynamic>?)
          ?.map((e) => DatingPreference.values.firstWhere(
        (p) => p.toString().split('.').last == e
      )).toList() ?? [],
      location: Location.fromMap(map['location'] ?? {}),
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
      stats: UserStats.fromMap(map['stats'] ?? {}),
      moderationStatus: ModerationStatus.values.firstWhere(
        (s) => s.toString().split('.').last == (map['moderationStatus'] ?? 'active')
      ),
      onboardingCompleted: map['onboardingCompleted'] ?? false,
      emailVerified: map['emailVerified'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
      isModerator: map['isModerator'] ?? false,
      isPremium: map['isPremium'] ?? false,
      premiumUntil: map['premiumUntil'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['premiumUntil'])
          : null,
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      followingUsers: List<String>.from(map['followingUsers'] ?? []),
      savedReviews: List<String>.from(map['savedReviews'] ?? []),
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'age': age,
      'gender': gender?.toString().split('.').last,
      'datingPreference': datingPreference.map((e) => e.toString().split('.').last).toList(),
      'location': location.toMap(),
      'preferences': preferences.toMap(),
      'stats': stats.toMap(),
      'moderationStatus': moderationStatus.toString().split('.').last,
      'onboardingCompleted': onboardingCompleted,
      'emailVerified': emailVerified,
      'isAdmin': isAdmin,
      'isModerator': isModerator,
      'isPremium': isPremium,
      'premiumUntil': premiumUntil?.millisecondsSinceEpoch,
      'blockedUsers': blockedUsers,
      'followingUsers': followingUsers,
      'savedReviews': savedReviews,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // JSON aliases for Firebase compatibility
  Map<String, dynamic> toJson() => toMap();
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser.fromMap(json);

  // Getter for compatibility with provider
  List<String>? get following => followingUsers;

  AppUser copyWith({
    String? username,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    int? age,
    Gender? gender,
    List<DatingPreference>? datingPreference,
    Location? location,
    UserPreferences? preferences,
    UserStats? stats,
    ModerationStatus? moderationStatus,
    bool? onboardingCompleted,
    bool? emailVerified,
    bool? isPremium,
    DateTime? premiumUntil,
    List<String>? blockedUsers,
    List<String>? followingUsers,
    List<String>? savedReviews,
    DateTime? lastSeen,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id,
      email: email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      datingPreference: datingPreference ?? this.datingPreference,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      emailVerified: emailVerified ?? this.emailVerified,
      isAdmin: isAdmin,
      isModerator: isModerator,
      isPremium: isPremium ?? this.isPremium,
      premiumUntil: premiumUntil ?? this.premiumUntil,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      followingUsers: followingUsers ?? this.followingUsers,
      savedReviews: savedReviews ?? this.savedReviews,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

enum Gender { male, female, other }

enum DatingPreference { all, women, men, lgbt }

enum ModerationStatus { active, warned, suspended, banned }

class Location {
  final String city;
  final String state;
  final String country;
  final Coordinates? coords;
  final double radius;

  Location({
    required this.city,
    required this.state,
    required this.country,
    this.coords,
    this.radius = 25.0,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      coords: map['coords'] != null ? Coordinates.fromMap(map['coords']) : null,
      radius: (map['radius'] ?? 25.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'coords': coords?.toMap(),
      'radius': radius,
    };
  }

  // JSON aliases for Firebase compatibility
  Map<String, dynamic> toJson() => toMap();
  factory Location.fromJson(Map<String, dynamic> json) => Location.fromMap(json);
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class UserPreferences {
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final DisplaySettings display;

  UserPreferences({
    required this.notifications,
    required this.privacy,
    required this.display,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      notifications: NotificationSettings.fromMap(map['notifications'] ?? {}),
      privacy: PrivacySettings.fromMap(map['privacy'] ?? {}),
      display: DisplaySettings.fromMap(map['display'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications.toMap(),
      'privacy': privacy.toMap(),
      'display': display.toMap(),
    };
  }

  // JSON aliases for Firebase compatibility
  Map<String, dynamic> toJson() => toMap();
  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences.fromMap(json);
}

class NotificationSettings {
  final bool comments;
  final bool likes;
  final bool messages;
  final bool newReviews;
  final bool chatMentions;

  NotificationSettings({
    this.comments = true,
    this.likes = true,
    this.messages = true,
    this.newReviews = true,
    this.chatMentions = true,
  });

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      comments: map['comments'] ?? true,
      likes: map['likes'] ?? true,
      messages: map['messages'] ?? true,
      newReviews: map['newReviews'] ?? true,
      chatMentions: map['chatMentions'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comments': comments,
      'likes': likes,
      'messages': messages,
      'newReviews': newReviews,
      'chatMentions': chatMentions,
    };
  }
}

class PrivacySettings {
  final bool showLocation;
  final bool showOnlineStatus;
  final MessagePrivacy allowMessages;
  final ProfileVisibility profileVisibility;

  PrivacySettings({
    this.showLocation = true,
    this.showOnlineStatus = true,
    this.allowMessages = MessagePrivacy.all,
    this.profileVisibility = ProfileVisibility.public,
  });

  factory PrivacySettings.fromMap(Map<String, dynamic> map) {
    return PrivacySettings(
      showLocation: map['showLocation'] ?? true,
      showOnlineStatus: map['showOnlineStatus'] ?? true,
      allowMessages: MessagePrivacy.values.firstWhere(
        (m) => m.toString().split('.').last == (map['allowMessages'] ?? 'all')
      ),
      profileVisibility: ProfileVisibility.values.firstWhere(
        (p) => p.toString().split('.').last == (map['profileVisibility'] ?? 'public')
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showLocation': showLocation,
      'showOnlineStatus': showOnlineStatus,
      'allowMessages': allowMessages.toString().split('.').last,
      'profileVisibility': profileVisibility.toString().split('.').last,
    };
  }
}

enum MessagePrivacy { all, following, none }
enum ProfileVisibility { public, community, private }

class DisplaySettings {
  final AppTheme theme;
  final ViewType viewType;
  final FontSize fontSize;

  DisplaySettings({
    this.theme = AppTheme.auto,
    this.viewType = ViewType.masonry,
    this.fontSize = FontSize.medium,
  });

  factory DisplaySettings.fromMap(Map<String, dynamic> map) {
    return DisplaySettings(
      theme: AppTheme.values.firstWhere(
        (t) => t.toString().split('.').last == (map['theme'] ?? 'auto')
      ),
      viewType: ViewType.values.firstWhere(
        (v) => v.toString().split('.').last == (map['viewType'] ?? 'masonry')
      ),
      fontSize: FontSize.values.firstWhere(
        (f) => f.toString().split('.').last == (map['fontSize'] ?? 'medium')
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'theme': theme.toString().split('.').last,
      'viewType': viewType.toString().split('.').last,
      'fontSize': fontSize.toString().split('.').last,
    };
  }
}

enum AppTheme { light, dark, auto }
enum ViewType { masonry, grid, list }
enum FontSize { small, medium, large }

class UserStats {
  final int reviewsPosted;
  final int commentsPosted;
  final int likesReceived;
  final int flagsGiven;
  final int helpfulVotes;
  final double reputation;
  final int level;

  UserStats({
    this.reviewsPosted = 0,
    this.commentsPosted = 0,
    this.likesReceived = 0,
    this.flagsGiven = 0,
    this.helpfulVotes = 0,
    this.reputation = 0.0,
    this.level = 1,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      reviewsPosted: map['reviewsPosted'] ?? 0,
      commentsPosted: map['commentsPosted'] ?? 0,
      likesReceived: map['likesReceived'] ?? 0,
      flagsGiven: map['flagsGiven'] ?? 0,
      helpfulVotes: map['helpfulVotes'] ?? 0,
      reputation: (map['reputation'] ?? 0.0).toDouble(),
      level: map['level'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewsPosted': reviewsPosted,
      'commentsPosted': commentsPosted,
      'likesReceived': likesReceived,
      'flagsGiven': flagsGiven,
      'helpfulVotes': helpfulVotes,
      'reputation': reputation,
      'level': level,
    };
  }

  // JSON aliases for Firebase compatibility
  Map<String, dynamic> toJson() => toMap();
  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats.fromMap(json);
}