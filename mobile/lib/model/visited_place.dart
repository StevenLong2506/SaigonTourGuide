import 'package:saigon_tour_guide/model/place_detail.dart';

class VisitedPlace {
  final int id;
  final DateTime? visitedAt;
  final DateTime createdAt;
  final PlaceDetail place;

  VisitedPlace({
    required this.id,
    required this.visitedAt,
    required this.createdAt,
    required this.place,
  });

  factory VisitedPlace.fromJson(Map<String, dynamic> json) => VisitedPlace(
    id: json['id'] as int,
    visitedAt: json['visited_at'] != null
        ? DateTime.parse(json['visited_at'] as String)
        : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    place: PlaceDetail.fromJson(json['place'] as Map<String, dynamic>),
  );
}
