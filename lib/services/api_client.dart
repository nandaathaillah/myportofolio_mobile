import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/experience.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Map<String, String> _headers({String? token}) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      };

  Future<String> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/auth/token/'),
      headers: _headers(),
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Invalid username or password.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> logout(String token) async {
    await _client.post(
      Uri.parse('$_baseUrl/api/v1/auth/logout/'),
      headers: _headers(token: token),
    );
  }

  Future<List<Experience>> fetchExperiences({String? token}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/v1/experience/'),
      headers: _headers(token: token),
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, 'Failed to load experiences.');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Experience.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Experience> createExperience(
    Experience experience, {
    required String token,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/v1/experience/'),
      headers: _headers(token: token),
      body: jsonEncode(experience.toJson()),
    );

    if (response.statusCode != 201) {
      throw ApiException(response.statusCode, 'Failed to create experience.');
    }

    return Experience.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}