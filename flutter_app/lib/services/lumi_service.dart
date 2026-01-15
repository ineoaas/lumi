import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LumiService {
  // Change this to your backend URL
  // For Android emulator: use 'http://10.0.2.2:8000'
  // For physical device on LAN: use 'http://YOUR_LOCAL_IP:8000' (e.g., 'http://192.168.1.100:8000')
  // For production: use your server URL with HTTPS
  final String baseUrl = 'http://192.168.0.85:8000';

  /// Predict emotion from a single text string
  Future<Map<String, dynamic>> predictText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict_text'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to predict: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Predict emotion from multiple lines (recommended for Lumi demo)
  /// No longer saves to database - returns analysis only
  Future<Map<String, dynamic>> predictLines(List<String> lines) async {
    try {
      final payload = {
        'lines': lines,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to predict: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get user's recent color entries from database
  Future<List<Map<String, dynamic>>> getUserColors(String userId, {int limit = 30}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/colors/$userId?limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['colors'] as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch colors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get mood statistics for a user
  Future<Map<String, dynamic>> getMoodStats(String userId, {int days = 30}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/$userId?days=$days'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get community mood statistics for today (all users, anonymous)
  Future<Map<String, dynamic>> getCommunityMoodToday() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/community/mood-today'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch community mood: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Summarize multiple journal reflections
  Future<Map<String, dynamic>> summarizeReflections(List<String> reflections) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/summarize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reflections': reflections}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to summarize: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Convert HSL hue (0-360) to Flutter Color
  /// Returns a vibrant color for the given hue value
  Color hueToColor(int? hue) {
    if (hue == null) return Colors.grey;
    // Convert hue to HSL Color with high saturation and medium lightness
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.85, 0.65).toColor();
  }

  /// Get a lighter version of the color for backgrounds
  Color hueToLightColor(int? hue) {
    if (hue == null) return Colors.grey.shade200;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.5, 0.92).toColor();
  }
}
