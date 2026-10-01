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

  /// Xem chú thích ở FavoritesProvider._generation.
  int _generation = 0;

  List<VisitedPlace> get items => List.unmodifiable(_items);
  bool isVisited(int placeId) => _items.any((v) => v.place.id == placeId);

  /// Xoá dữ liệu của tài khoản vừa đăng xuất — provider sống trên RootScreen
  /// nên không tự bị dispose khi chuyển về LoginScreen.
  void reset() {
    _generation++;
    _items = [];
    _loaded = false;
    loading = false;
    error = null;
    notifyListeners();
  }

  Future<void> ensureLoaded() async {
    if (_loaded || loading) return;
    await load();
  }

  Future<void> load() async {
    final gen = _generation;
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _apiClient.dio.get('/visited');
      final items = (res.data as List)
          .map((e) => VisitedPlace.fromJson(e as Map<String, dynamic>))
          .toList();
      if (gen != _generation) return;
      _items = items;
      _loaded = true;
    } catch (e) {
      if (gen != _generation) return;
      error = getErrorMessage(e);
    } finally {
      if (gen == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> markVisited(int placeId) async {
    await _apiClient.dio.post('/visited', data: {'place_id': placeId});
    await load();
  }

  Future<void> removeVisited(int placeId) async {
    final gen = _generation;
    final removed = _items.where((v) => v.place.id == placeId).toList();
    _items.removeWhere((v) => v.place.id == placeId);
    notifyListeners();
    try {
      await _apiClient.dio.delete('/visited/$placeId');
    } catch (e) {
      if (gen == _generation && removed.isNotEmpty) {
        _items.addAll(removed);
        notifyListeners();
      }
      rethrow;
    }
  }
}
