import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _currentUser;
  final ApiService _apiService = ApiService();

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;

  // Kiểm tra trạng thái đăng nhập
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response['success']) {
        _isLoggedIn = true;
        _currentUser = UserModel.fromJson(response['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', response['token']);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi đăng nhập: $e');
      return false;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    notifyListeners();
  }

  // Cập nhật hồ sơ người dùng
  Future<bool> updateUserProfile(UserModel user) async {
    try {
      final response = await _apiService.updateUserProfile(user);
      if (response['success']) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi cập nhật hồ sơ: $e');
      return false;
    }
  }
}
