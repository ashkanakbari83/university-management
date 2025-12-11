import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/resource.dart';

class ApiService {
  // Change this to your actual API URL
  // For local development: http://localhost:8080
  // For Android emulator: http://10.0.2.2:8080
  static const String baseUrl = 'http://localhost:8080';

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (requiresAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Auth APIs
  Future<LoginResponse> register(
    String username,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: _getHeaders(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return LoginResponse(
        success: true,
        message: 'User registered successfully',
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Registration failed');
    }
  }

  Future<LoginResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: _getHeaders(),
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      return LoginResponse(
        success: true,
        token: data['token'],
        username: data['username'],
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    }
  }

  // Resource APIs
  Future<List<Resource>> getResources() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resources'),
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load resources');
    }
  }

  Future<Resource> getResourceById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resources/$id'),
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      return Resource.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load resource');
    }
  }

  Future<List<Resource>> getResourcesByType(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resources/type/$type'),
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load resources by type');
    }
  }

  Future<List<Resource>> getAvailableResourcesByType(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/resources/type/$type/available'),
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load available resources');
    }
  }

  Future<Resource> createResource({
    required String name,
    required String description,
    required String type,
    required String location,
    required int capacity,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/resources'),
      headers: _getHeaders(requiresAuth: true),
      body: jsonEncode({
        'name': name,
        'description': description,
        'type': type,
        'location': location,
        'capacity': capacity,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Resource.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to create resource');
    }
  }

  Future<void> deleteResource(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/resources/$id'),
      headers: _getHeaders(requiresAuth: true),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to delete resource');
    }
  }
}

class LoginResponse {
  final bool success;
  final String? token;
  final String? username;
  final String? message;

  LoginResponse({
    required this.success,
    this.token,
    this.username,
    this.message,
  });
}
