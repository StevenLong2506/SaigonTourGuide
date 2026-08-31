class ReviewUser {
  final String name;
  final String? avatar;

  ReviewUser({required this.name, required this.avatar});

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
    name: json['name'] as String,
    avatar: json['avatar'] as String?,
  );
}

class Review {
  final int id;
  final int placeId;
  final int userId;
  final ReviewUser user;
  final int rating;
  final String? title;
  final String? content;
  final DateTime? visitDate;
  final List<String> images;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.user,
    required this.rating,
    required this.title,
    required this.content,
    required this.visitDate,
    required this.images,
    required this.createdAt,
  });

  
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as int,
    placeId: json['place_id'] as int,
    userId: json['user_id'] as int,
    user: ReviewUser.fromJson(json['user'] as Map<String, dynamic>),
    rating: json['rating'] as int,
    title: json['title'] as String?,
    content: json['content'] as String?,
    visitDate: json['visit_date'] != null
        ? DateTime.parse(json['visit_date'] as String)
        : null,
    images: (json['images'] as List? ?? []).map((e) => e as String).toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
