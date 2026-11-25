import 'package:flutter/foundation.dart';
import '../services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;
  String? _username;

  String? get token => _token;
  String? get username => _username;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    final token = await _apiClient.login(username, password);
    _token = token;
    _username = username;
    notifyListeners();
  }

  Future<void> logout() async {
    final currentToken = _token;
    _token = null;
    _username = null;
    notifyListeners();
    if (currentToken != null) {
      try {
        await _apiClient.logout(currentToken);
      } catch (_) {}
    }
  }
}