import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000/api";

  static Map<String, String> headers = {"Content-Type": "application/json"};

  /* ================= AUTH ================= */

static Future<Map<String, dynamic>?> login(
  String email,
  String password,
) async {
  final res = await http.post(
    Uri.parse("$baseUrl/auth/login"),
    headers: headers,
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body); 
    // { token, userId }
  } else {
    return null;
  }
}


  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: headers,
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    return res.statusCode == 200;
  }

  static Future<List> getAllUsers() async {
    final res = await http.get(
      Uri.parse("$baseUrl/auth/users"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getUserById(String id) async {
    final res = await http.get(
      Uri.parse("$baseUrl/auth/user/$id"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  /* ================= MEDICINES ================= */

  static Future<List> getAllMedicines() async {
    final res = await http.get(
      Uri.parse("$baseUrl/medicine"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getMedicineById(String id) async {
    final res = await http.get(
      Uri.parse("$baseUrl/medicine/$id"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  static Future<bool> addMedicine(
    String name,
    double price,
    String image,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/medicine"),
      headers: headers,
      body: jsonEncode({"name": name, "price": price, "image": image}),
    );
    return res.statusCode == 201;
  }

  /* ================= ORDERS ================= */

  static Future<bool> placeOrder(
    String userId,
    List medicines,
    String address,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/order"),
      headers: headers,
      body: jsonEncode({
        "userId": userId,
        "medicines": medicines,
        "address": address,
      }),
    );
    return res.statusCode == 201;
  }

  static Future<List> getAllOrders() async {
    final res = await http.get(Uri.parse("$baseUrl/order"), headers: headers);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getOrderById(String id) async {
    final res = await http.get(
      Uri.parse("$baseUrl/order/$id"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  /* ================= ORDER TRACKING ================= */

  static Future<Map<String, dynamic>> trackOrder(String orderId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/order/track/$orderId"),
      headers: headers,
    );
    return jsonDecode(res.body);
  }
}
