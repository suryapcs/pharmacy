// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AiService {

//   static Future<String> askDoctor(String message, String specialization) async {

//     final response = await http.post(
//       Uri.parse("http://localhost:3000/ask-doctor"), // emulator use
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "message": message,
//         "specialization": specialization
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["reply"];
//     } else {
//       return "Server error bro";
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {

  static Future<String> askDoctor(String message) async {

    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/ask-doctor"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"];
      } else {
        return "Server error bro";
      }

    } catch (e) {
      return "Connection error bro";
    }
  }
}
