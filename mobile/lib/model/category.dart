class Category {
  final int id;
  final String name;
  final int placeCount;

  Category({required this.id, required this.name, required this.placeCount});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as int, 
    name: json['name'] as String, 
    placeCount: json['place_count'] as int,
  );
}
