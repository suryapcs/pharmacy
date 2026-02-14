import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000/api";
  //  static const String apiKey = "pmpt_698c15e2fb94819587bef8df6b8dec2d0f79a6dea664ec06";
  static Map<String, String> headers = {"Content-Type": "application/json"};



 static Future<String> askDoctor(
  String message,
  String specialization,
) async {

  final res = await http.post(
    Uri.parse("$baseUrl/ai-doctor"),
    headers: headers,
    body: jsonEncode({
      "message": message,
      "specialization": specialization,
    }),
  );

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    return data["reply"];
  } else {
    return "Server error ${res.statusCode}";
  }
}


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
    return jsonDecode(res.body); // {token, userId}
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

   // 🔥 GET DOCTORS BY SPECIALIZATION

  static Future<List<dynamic>> getDoctors(String specialization) async {
    final res = await http.get(
      Uri.parse("$baseUrl/doctors/$specialization"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
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

  static Future<List> searchMedicines(String query) async {
  final res = await http.get(
    Uri.parse("$baseUrl/medicine/search?q=$query"),
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

  /* ================= CART ================= */

static Future<List<dynamic>> getCart(String userId) async {
  final response = await http.get(Uri.parse("$baseUrl/cart/$userId"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data; // this should be the user.cart array
  } else {
    return [];
  }
}


static Future<bool> addToCart(String userId, String medicineId) async {
  final res = await http.post(
    Uri.parse("$baseUrl/cart/add"),
    headers: headers,
    body: jsonEncode({
      "userId": userId,
      "medicineId": medicineId,
    }),
  );

  return res.statusCode == 200;
}

static Future<bool> removeFromCart(String userId, String medicineId) async {
  final res = await http.post(
    Uri.parse("$baseUrl/cart/remove"),
    headers: headers,
    body: jsonEncode({
      "userId": userId,
      "medicineId": medicineId,
    }),
  );

  return res.statusCode == 200;
}

static Future<List> getUserCart(String userId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/cart/$userId"),
    headers: headers,
  );
  return jsonDecode(res.body);
}

 /// 🔥 CREATE ORDER
  static Future<String?> createOrder(
      String userId, List cartItems, double total) async {

   final res = await http.post(
  Uri.parse("$baseUrl/order/create"),
  headers: headers, // 🔥 IMPORTANT
  body: jsonEncode({
    "userId": userId,
  }),
);


    final data = jsonDecode(res.body);
    return data["orderId"];
  }

 static Future<bool> payOrder(String orderId) async {
   final res = await http.post(
  Uri.parse("$baseUrl/order/pay"),
  headers: headers,  // Content-Type: application/json
  body: jsonEncode({"orderId": orderId}),
);

    return res.statusCode == 200;
  }

static Future<List> getOrders(String userId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/order/user/$userId"),
    headers: headers,
  );
  return jsonDecode(res.body);
}

static Future<List> getOrdersByUser(String userId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/order/user/$userId"),
    headers: headers, // optional, recommended
  );
  return jsonDecode(res.body);
}


}

