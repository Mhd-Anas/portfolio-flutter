import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? 'https://portfolio-backend-e9d1.onrender.com';

  Future<bool> submitContact(
    String name,
    String email,
    String subject,
    String message,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/api/contact');
      print('🌐 Sending contact form to: $uri');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        }),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      // Accept both 200 (OK) and 201 (Created)
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Contact form submitted successfully');
        return true;
      } else {
        print('❌ Server returned error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('💥 Network error: $e');
      return false;
    }
  }

  // Test connection to backend
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'Accept': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}