import 'package:flutter/foundation.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/visited_place.dart';

class VisitedPlacesProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  VisitedPlacesProvider(this._apiClient);

  List<VisitedPlace> _items = [];
  bool loading = false;
  bool _loaded = false;
  String? error;

  List<VisitedPlace> get items => List.unmodifiable(_items);
  bool isVisited(int placeId) => _items.any((v) => v.place.id == placeId);

  Future<void> ensureLoaded() async {
    if (_loaded || loading) return;
    await load();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _apiClient.dio.get('/visited');
      _items = (res.data as List)
          .map((e) => VisitedPlace.fromJson(e as Map<String, dynamic>))
          .toList();
      _loaded = true;
    } catch (e) {
      error = getErrorMessage(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> markVisited(int placeId) async {
    await _apiClient.dio.post('/visited', data: {'place_id': placeId});
    await load();
  }

  Future<void> removeVisited(int placeId) async {
    final removed = _items.where((v) => v.place.id == placeId).toList();
    _items.removeWhere((v) => v.place.id == placeId);
    notifyListeners();
    try {
      await _apiClient.dio.delete('/visited/$placeId');
    } catch (e) {
      if (removed.isNotEmpty) {
        _items.addAll(removed);
        notifyListeners();
      }
      rethrow;
    }
  }
}
