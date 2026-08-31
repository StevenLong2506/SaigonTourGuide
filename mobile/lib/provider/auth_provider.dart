import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/token_storage.dart';
import 'package:saigon_tour_guide/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  AuthProvider(this._apiClient);
  UserModel? user;
  bool loading = true;
  bool skippedOnboarding = false;

  void skipOnboarding() {
    skippedOnboarding = true;
    notifyListeners();
  }

  Future<void> restoreSession() async {
    loading = true;
    try {
      final token = await TokenStorage.read();
      if (token != null) {
        final res = await _apiClient.dio.get('/auth/me');
        user = UserModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      try {
        await TokenStorage.clear();
      } catch (_) {}
      user = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String identifier, String password) async {
    final loginRes = await _apiClient.dio.post(
      '/auth/login',
      data: {'identifier': identifier, 'password': password},
    );

    final token = loginRes.data['access_token'] as String;
    await TokenStorage.write(token);

    final meRes = await _apiClient.dio.get('/auth/me');
    user = UserModel.fromJson(meRes.data as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required String username,
    required String password,
  }) async {
    await _apiClient.dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'date_of_birth': dob,
        'gender': gender,
        'username': username,
        'password': password,
      },
    );
  }

  Future<void> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _apiClient.dio.post('/users/me/avatar', data: formData);
    user = UserModel.fromJson(res.data as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    final res = await _apiClient.dio.put(
      '/users/me',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'date_of_birth': dob,
        'gender': gender,
      },
    );

    user = UserModel.fromJson(res.data as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _apiClient.dio.post(
      '/users/me/change-password',
      data: {'old_password': oldPassword, 'new_password': newPassword},
    );
  }

  Future<void> setTravelProfile({
    String? travelStyle,
    String? budgetLevel,
    bool? withChildren,
    bool? withElderly,
  }) async {
    final res = await _apiClient.dio.put(
      '/users/me/travel-profile',
      data: {
        'travel_style': travelStyle,
        'budget_level': budgetLevel,
        'with_children': withChildren,
        'with_elderly': withElderly,
      },
    );

    final profile = TravelProfile.fromJson(res.data as Map<String, dynamic>);
    user = user != null
        ? UserModel(
            id: user!.id,
            username: user!.username,
            name: user!.name,
            email: user!.email,
            avatar: user!.avatar,
            userRole: user!.userRole,
            dob: user!.dob,
            gender: user!.gender,
            phone: user!.phone,
            createdAt: user!.createdAt,
            interests: user!.interests,
            travelProfile: profile,
          )
        : null;

    notifyListeners();
  }

  Future<void> setInterests(List<int> tagIds) async {
    final res = await _apiClient.dio.put(
      '/users/me/interests',
      data: {
        'interests': tagIds.map((id) => {'tag_id': id, 'priority': 1}).toList(),
      },
    );

    final items = (res.data as List)
        .map((e) => UserInterest.fromJson(e as Map<String, dynamic>))
        .toList();
    user = user != null
        ? UserModel(
            id: user!.id,
            username: user!.username,
            name: user!.name,
            email: user!.email,
            avatar: user!.avatar,
            userRole: user!.userRole,
            dob: user!.dob,
            gender: user!.gender,
            phone: user!.phone,
            createdAt: user!.createdAt,
            interests: items,
            travelProfile: user!.travelProfile,
          )
        : null;

    notifyListeners();
  }

  Future<void> forceLogout() async {
    await TokenStorage.clear();
    user = null;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      // Bỏ qua lỗi gọi API (VD mất mạng) — vẫn phải đăng xuất được ở local.
    } finally {
      await forceLogout();
    }
  }
}
