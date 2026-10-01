import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/place_detail.dart';

class FavoritesProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  FavoritesProvider(this._apiClient);
  List<PlaceDetail> _places = [];
  bool loading = false;
  bool _loaded = false;
  String? error;

  /// Tăng mỗi lần reset(). Request đang bay dở được chụp lại giá trị này lúc
  /// bắt đầu; khi trả về mà số đã khác nghĩa là dữ liệu thuộc về tài khoản cũ
  /// nên phải bỏ đi thay vì ghi đè.
  int _generation = 0;

  List<PlaceDetail> get places => List.unmodifiable(_places);
  bool isFavorite(int placeId) => _places.any((p) => p.id == placeId);

  /// Xoá sạch dữ liệu của tài khoản vừa đăng xuất. Provider này được tạo trên
  /// RootScreen nên không bị dispose khi chuyển về LoginScreen — không gọi
  /// reset() thì tài khoản đăng nhập kế tiếp sẽ thấy danh sách của tài khoản
  /// trước (ensureLoaded() bỏ qua vì _loaded vẫn đang là true).
  void reset() {
    _generation++;
    _places = [];
    _loaded = false;
    loading = false;
    error = null;
    notifyListeners();
  }

  /// Gọi khi 1 màn hình cần biết trạng thái yêu thích nhưng không phải màn
  /// "sở hữu" dữ liệu này (VD: PlaceDetailScreen) — chỉ tải nếu chưa từng tải.
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
      final res = await _apiClient.dio.get('/favorites');
      final items = (res.data as List)
          .map(
            (e) => PlaceDetail.fromJson(
              (e as Map<String, dynamic>)['place'] as Map<String, dynamic>,
            ),
          )
          .toList();
      if (gen != _generation) return;
      _places = items;
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

  Future<void> toggle(int placeId) async {
    final gen = _generation;
    final wasFavorite = isFavorite(placeId);
    final removed = wasFavorite
        ? _places.firstWhere((p) => p.id == placeId)
        : null;

    if (wasFavorite) {
      _places.removeWhere((p) => p.id == placeId);
    }
    notifyListeners();
    try {
      if (wasFavorite) {
        await _apiClient.dio.delete('/favorites/$placeId');
      } else {
        await _apiClient.dio.post('/favorites', data: {'place_id': placeId});
        await load();
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Dữ liệu local bị lệch với server (VD: chưa từng ensureLoaded() trước đó) —
      // 409 khi thêm nghĩa là đã có sẵn ở server, 404 khi xoá nghĩa là đã bị xoá rồi.
      // Cả 2 trường hợp: đồng bộ lại thay vì báo lỗi cho người dùng.
      if (!wasFavorite && status == 409) {
        await load();
        return;
      }
      if (wasFavorite && status == 404) {
        return;
      }
      if (gen == _generation && wasFavorite && removed != null) {
        _places.add(removed);
        notifyListeners();
      }
      rethrow;
    } catch (e) {
      if (gen == _generation && wasFavorite && removed != null) {
        _places.add(removed);
        notifyListeners();
      }
      rethrow;
    }
  }
}
