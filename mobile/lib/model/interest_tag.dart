class InterestTag {
  final int id;
  final String name;
  final int placeCount;

  InterestTag({
    required this.id,
    required this.name,
    required this.placeCount,
  });

  factory InterestTag.fromJson(Map<String, dynamic> json) => InterestTag(
    id: json['id'] as int, 
    name: json['name'] as String, 
    placeCount: json['place_count'] as int,
  );
}