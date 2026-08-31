class ChatSession {
  final int id;
  final String? title;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'] as int, 
    title: json['title'] as String?, 
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}