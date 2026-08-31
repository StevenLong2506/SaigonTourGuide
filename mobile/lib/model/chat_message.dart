enum ChatSender {user, bot}

class ChatPlaceCard{
  final int id;
  final String name;
  final String ward;
  final double? averageRating;

  ChatPlaceCard({
    required this.id,
    required this.name,
    required this.ward,
    required this.averageRating,
  });

  factory ChatPlaceCard.fromJson(Map<String, dynamic> json) => ChatPlaceCard(
    id: json['id'] as int,
    name: json['name'] as String,
    ward: json['ward'] as String,
    averageRating: json['average_rating'] != null
        ? double.tryParse(json['average_rating'].toString())
        : null,
  );
}

class ChatMessage {
  final ChatSender sender;
  final String text;
  final List<ChatPlaceCard> places;

  ChatMessage({
    required this.sender,
    required this.text,
    this.places = const []
  });
}