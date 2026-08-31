import 'package:saigon_tour_guide/model/place.dart';

class ItineraryItem {
  final int id;
  final int? placeId;
  final int dayNumber;
  final String? startTime;
  final String? endTime;
  final String? note;
  final String? transportMode;
  final PlaceSummary? place;

  ItineraryItem({
    required this.id,
    required this.placeId,
    required this.dayNumber,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.transportMode,
    required this.place,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) => ItineraryItem(
    id: json['id'] as int,
    placeId: json['place_id'] as int?,
    dayNumber: json['day_number'] as int,
    startTime: json['start_time'] as String?,
    endTime: json['end_time'] as String?,
    note: json['note'] as String?,
    transportMode: json['transport_mode'] as String?,
    place: json['place'] != null
        ? PlaceSummary.fromJson(json['place'] as Map<String, dynamic>)
        : null,
  );
}

class Itinerary {
  final int id;
  final String title;
  final String? description;
  final String? shareCode;
  final DateTime createdAt;
  final List<ItineraryItem> items;

  Itinerary({
    required this.id,
    required this.title,
    required this.description,
    required this.shareCode,
    required this.createdAt,
    required this.items,
  });

  Map<int, List<ItineraryItem>> get itemsByDay {
    final map = <int, List<ItineraryItem>>{};
    for (final item in items){
      map.putIfAbsent(item.dayNumber, () => []).add(item);
    }
    for (final list in map.values){
      list.sort((a,b) => a.sortOrderCompare(b));
    }
    return map;
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String?,
    shareCode: json['share_code'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    items: (json['items'] as List)
        .map((e) => ItineraryItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

extension on ItineraryItem{
  int sortOrderCompare(ItineraryItem other) => (startTime ?? '').compareTo(other.startTime ?? '');
}