import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {

  // ⚠️ Change depending on device
  static const String baseUrl = "http://localhost:3000"; 
  // static const String baseUrl = "http://192.168.1.5:3000"; // real phone

  static Map<String, String> headers = {
    "Content-Type": "application/json"
  };

  // 🔹 Health check
  static Future<bool> checkHealth() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/health"),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 🔹 Chat API
  static Future<String> chat(String message) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/chat"),
      headers: headers,
      body: jsonEncode({
        "message": message,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["reply"];
    } else {
      return "Server error ${res.statusCode}";
    }
  }
}
