import 'package:whisperdate/models/user.dart';

class Review {
  final String id;
  final String authorId;
  final String subjectName;
  final int? subjectAge;
  final Gender subjectGender;
  final DatingPreference category;
  final DateDuration dateDuration;
  final int dateYear;
  final RelationshipType relationshipType;
  final String title;
  final String content;
  final int rating; // 1-5 stars
  final bool wouldRecommend;
  final List<Flag> greenFlags;
  final List<Flag> redFlags;
  final List<String> imageUrls;
  final List<String>? images; // Alias for imageUrls for compatibility
  final Location location;
  final ReviewStats stats;
  final ModerationStatus moderationStatus;
  final String? moderationNotes;
  final double? aiModerationScore;
  final int reportCount;
  final bool isAnonymous;
  final bool isEdited;
  final List<EditHistory> editHistory;
  final ReviewVisibility visibility;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.authorId,
    required this.subjectName,
    this.subjectAge,
    required this.subjectGender,
    required this.category,
    required this.dateDuration,
    required this.dateYear,
    required this.relationshipType,
    required this.title,
    required this.content,
    required this.rating,
    required this.wouldRecommend,
    this.greenFlags = const [],
    this.redFlags = const [],
    this.imageUrls = const [],
    this.images,
    required this.location,
    required this.stats,
    this.moderationStatus = ModerationStatus.active,
    this.moderationNotes,
    this.aiModerationScore,
    this.reportCount = 0,
    this.isAnonymous = true,
    this.isEdited = false,
    this.editHistory = const [],
    this.visibility = ReviewVisibility.public,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      authorId: map['authorId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      subjectAge: map['subjectAge'],
      subjectGender: Gender.values.firstWhere(
        (g) => g.toString().split('.').last == map['subjectGender']
      ),
      category: DatingPreference.values.firstWhere(
        (c) => c.toString().split('.').last == map['category']
      ),
      dateDuration: DateDuration.values.firstWhere(
        (d) => d.toString().split('.').last == map['dateDuration']
      ),
      dateYear: map['dateYear'] ?? DateTime.now().year,
      relationshipType: RelationshipType.values.firstWhere(
        (r) => r.toString().split('.').last == map['relationshipType']
      ),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      rating: map['rating'] ?? 1,
      wouldRecommend: map['wouldRecommend'] ?? false,
      greenFlags: (map['greenFlags'] as List<dynamic>?)
          ?.map((f) => Flag.fromMap(f))
          .toList() ?? [],
      redFlags: (map['redFlags'] as List<dynamic>?)
          ?.map((f) => Flag.fromMap(f))
          .toList() ?? [],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      location: Location.fromMap(map['location'] ?? {}),
      stats: ReviewStats.fromMap(map['stats'] ?? {}),
      moderationStatus: ModerationStatus.values.firstWhere(
        (s) => s.toString().split('.').last == (map['moderationStatus'] ?? 'active')
      ),
      moderationNotes: map['moderationNotes'],
      aiModerationScore: map['aiModerationScore']?.toDouble(),
      reportCount: map['reportCount'] ?? 0,
      isAnonymous: map['isAnonymous'] ?? true,
      isEdited: map['isEdited'] ?? false,
      editHistory: (map['editHistory'] as List<dynamic>?)
          ?.map((e) => EditHistory.fromMap(e))
          .toList() ?? [],
      visibility: ReviewVisibility.values.firstWhere(
        (v) => v.toString().split('.').last == (map['visibility'] ?? 'public')
      ),
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'subjectName': subjectName,
      'subjectAge': subjectAge,
      'subjectGender': subjectGender.toString().split('.').last,
      'category': category.toString().split('.').last,
      'dateDuration': dateDuration.toString().split('.').last,
      'dateYear': dateYear,
      'relationshipType': relationshipType.toString().split('.').last,
      'title': title,
      'content': content,
      'rating': rating,
      'wouldRecommend': wouldRecommend,
      'greenFlags': greenFlags.map((f) => f.toMap()).toList(),
      'redFlags': redFlags.map((f) => f.toMap()).toList(),
      'imageUrls': imageUrls,
      'location': location.toMap(),
      'stats': stats.toMap(),
      'moderationStatus': moderationStatus.toString().split('.').last,
      'moderationNotes': moderationNotes,
      'aiModerationScore': aiModerationScore,
      'reportCount': reportCount,
      'isAnonymous': isAnonymous,
      'isEdited': isEdited,
      'editHistory': editHistory.map((e) => e.toMap()).toList(),
      'visibility': visibility.toString().split('.').last,
      'tags': tags,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // JSON aliases for Firebase compatibility
  Map<String, dynamic> toJson() => toMap();
  factory Review.fromJson(Map<String, dynamic> json) => Review.fromMap(json);

  Review copyWith({
    String? title,
    String? content,
    int? rating,
    bool? wouldRecommend,
    List<Flag>? greenFlags,
    List<Flag>? redFlags,
    List<String>? imageUrls,
    ReviewStats? stats,
    ModerationStatus? moderationStatus,
    String? moderationNotes,
    double? aiModerationScore,
    int? reportCount,
    bool? isEdited,
    List<EditHistory>? editHistory,
    ReviewVisibility? visibility,
    List<String>? tags,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id,
      authorId: authorId,
      subjectName: subjectName,
      subjectAge: subjectAge,
      subjectGender: subjectGender,
      category: category,
      dateDuration: dateDuration,
      dateYear: dateYear,
      relationshipType: relationshipType,
      title: title ?? this.title,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      wouldRecommend: wouldRecommend ?? this.wouldRecommend,
      greenFlags: greenFlags ?? this.greenFlags,
      redFlags: redFlags ?? this.redFlags,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location,
      stats: stats ?? this.stats,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      moderationNotes: moderationNotes ?? this.moderationNotes,
      aiModerationScore: aiModerationScore ?? this.aiModerationScore,
      reportCount: reportCount ?? this.reportCount,
      isAnonymous: isAnonymous,
      isEdited: isEdited ?? this.isEdited,
      editHistory: editHistory ?? this.editHistory,
      visibility: visibility ?? this.visibility,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Getter for compatibility with review service
  bool get isVisible => visibility == ReviewVisibility.public;
}

enum DateDuration {
  oneHour,
  twoToThreeHours,
  halfDay,
  fullDay,
  multiDay,
}

enum RelationshipType {
  workout,
  training,
  game,
  casual,
}

enum ReviewVisibility {
  public,
  community,
  private,
}

class Flag {
  final String id;
  final String label;
  final String category;
  final String emoji;
  final int votes;

  const Flag({
    required this.id,
    required this.label,
    required this.category,
    required this.emoji,
    this.votes = 0,
  });

  factory Flag.fromMap(Map<String, dynamic> map) {
    return Flag(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      category: map['category'] ?? '',
      emoji: map['emoji'] ?? '',
      votes: map['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'category': category,
      'emoji': emoji,
      'votes': votes,
    };
  }
}

class ReviewStats {
  final int likes;
  final int comments;
  final int shares;
  final int views;
  final int helpful;
  final int notHelpful;

  ReviewStats({
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.views = 0,
    this.helpful = 0,
    this.notHelpful = 0,
  });

  factory ReviewStats.fromMap(Map<String, dynamic> map) {
    return ReviewStats(
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      views: map['views'] ?? 0,
      helpful: map['helpful'] ?? 0,
      notHelpful: map['notHelpful'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'views': views,
      'helpful': helpful,
      'notHelpful': notHelpful,
    };
  }

  ReviewStats copyWith({
    int? likes,
    int? comments,
    int? shares,
    int? views,
    int? helpful,
    int? notHelpful,
  }) {
    return ReviewStats(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      views: views ?? this.views,
      helpful: helpful ?? this.helpful,
      notHelpful: notHelpful ?? this.notHelpful,
    );
  }
}

class EditHistory {
  final String content;
  final DateTime editedAt;

  EditHistory({
    required this.content,
    required this.editedAt,
  });

  factory EditHistory.fromMap(Map<String, dynamic> map) {
    return EditHistory(
      content: map['content'] ?? '',
      editedAt: DateTime.fromMillisecondsSinceEpoch(map['editedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'editedAt': editedAt.millisecondsSinceEpoch,
    };
  }
}

// Predefined flags for selection
class PredefinedFlags {
  static const List<Flag> greenFlags = [
    Flag(id: 'g1', label: 'Good Communicator', category: 'Communication', emoji: '💬'),
    Flag(id: 'g2', label: 'Respectful', category: 'Respect', emoji: '🙏'),
    Flag(id: 'g3', label: 'Funny', category: 'Personality', emoji: '😄'),
    Flag(id: 'g4', label: 'Honest', category: 'Honesty', emoji: '🌟'),
    Flag(id: 'g5', label: 'Great Listener', category: 'Communication', emoji: '👂'),
    Flag(id: 'g6', label: 'Generous', category: 'Generosity', emoji: '💝'),
    Flag(id: 'g7', label: 'Romantic', category: 'Romance', emoji: '💕'),
    Flag(id: 'g8', label: 'Adventurous', category: 'Personality', emoji: '🎯'),
    Flag(id: 'g9', label: 'Supportive', category: 'Support', emoji: '🤝'),
    Flag(id: 'g10', label: 'Intelligent', category: 'Intelligence', emoji: '🧠'),
  ];

  static const List<Flag> redFlags = [
    Flag(id: 'r1', label: 'Poor Communication', category: 'Communication', emoji: '🚫'),
    Flag(id: 'r2', label: 'Disrespectful', category: 'Respect', emoji: '😤'),
    Flag(id: 'r3', label: 'Dishonest', category: 'Honesty', emoji: '🤥'),
    Flag(id: 'r4', label: 'Controlling', category: 'Control', emoji: '⚠️'),
    Flag(id: 'r5', label: 'Unreliable', category: 'Reliability', emoji: '⏰'),
    Flag(id: 'r6', label: 'Selfish', category: 'Selfishness', emoji: '😈'),
    Flag(id: 'r7', label: 'Jealous/Possessive', category: 'Trust', emoji: '👹'),
    Flag(id: 'r8', label: 'Anger Issues', category: 'Behavior', emoji: '😡'),
    Flag(id: 'r9', label: 'Inconsistent', category: 'Consistency', emoji: '🌪️'),
    Flag(id: 'r10', label: 'Poor Hygiene', category: 'Hygiene', emoji: '🤢'),
  ];
}