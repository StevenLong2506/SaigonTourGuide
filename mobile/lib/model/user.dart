class UserInterest {
  final int priority;
  final int tagId;
  final String tagName;

  UserInterest({
    required this.priority,
    required this.tagId,
    required this.tagName,
  });

  factory UserInterest.fromJson(Map<String, dynamic> json) => UserInterest(
    priority: json['priority'] as int,
    tagId: (json['tag'] as Map<String, dynamic>)['id'] as int,
    tagName: (json['tag'] as Map<String, dynamic>)['name'] as String,
  );
}

class TravelProfile {
  final String? travelStyle;
  final String? budgetLevel;
  final bool? withChildren;
  final bool? withElderly;

  TravelProfile({
    required this.travelStyle,
    required this.budgetLevel,
    required this.withChildren,
    required this.withElderly,
  });

  factory TravelProfile.fromJson(Map<String, dynamic> json) => TravelProfile(
    travelStyle: json['travel_style'] as String?,
    budgetLevel: json['budget_level'] as String?,
    withChildren: json['with_children'] as bool?,
    withElderly: json['with_elderly'] as bool?,
  );
}

class UserModel {
  final int id;
  final String username;
  final String email;
  final String name;
  final String? avatar;
  final String userRole;
  final DateTime dob;
  final String gender;
  final String phone;
  final DateTime createdAt;
  final List<UserInterest> interests;
  final TravelProfile? travelProfile;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatar,
    required this.userRole,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.createdAt,
    required this.interests,
    required this.travelProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      userRole: json['user_role'] as String,
      dob: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      phone: json['phone'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      interests: (json['interests'] as List? ?? [])
          .map((e) => UserInterest.fromJson(e as Map<String, dynamic>))
          .toList(),
      travelProfile: json['travel_profile'] != null
          ? TravelProfile.fromJson(
              json['travel_profile'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
