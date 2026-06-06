import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/memory.dart';

class ApiService {
  static const String _configuredBaseUrl = String.fromEnvironment('MEMORY_JAR_API_BASE_URL');

  String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:8080/api',
      _ => 'http://localhost:8080/api',
    };
  }

  Future<List<Memory>> getMemories() async {
    final response = await http.get(Uri.parse('$baseUrl/memories'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Memory.fromJson(data)).toList();
    } else {
      throw Exception(_errorMessage(response, 'Failed to load memories'));
    }
  }

  Future<Memory> createMemory(Memory memory) async {
    final response = await http.post(
      Uri.parse('$baseUrl/memories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(memory.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Memory.fromJson(json.decode(response.body));
    } else {
      throw Exception(_errorMessage(response, 'Failed to create memory'));
    }
  }

  Future<void> deleteMemory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/memories/$id'));
    if (response.statusCode != 204) {
      throw Exception(_errorMessage(response, 'Failed to delete memory'));
    }
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'];
      }
    } catch (_) {
      return '$fallback (${response.statusCode})';
    }
    return '$fallback (${response.statusCode})';
  }
}
