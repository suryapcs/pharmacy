import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'payment.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartItems = [];
  bool loading = true;
  double totalAmount = 0;
  String userName = "";

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId")!;
    userName = prefs.getString("userName") ?? "User";

    final data = await ApiService.getUserCart(userId);

    double total = 0;
    for (var item in data) {
      total += item["medicineId"]["price"] * item["count"];
    }

    setState(() {
      cartItems = data;
      totalAmount = total;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// 🛒 CART LIST
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, i) {
                      final item = cartItems[i];
                      final med = item["medicineId"];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(med["name"]),
                          subtitle: Text("₹${med["price"]}  x ${item["count"]}"),
                          trailing: Text(
                            "₹${med["price"] * item["count"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 💰 TOTAL + ORDER BUTTON
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total (${cartItems.length} items)",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "₹$totalAmount",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
                    onPressed: () async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString("userId")!;

  final orderId = await ApiService.createOrder(
    userId,
    cartItems,
    totalAmount,
  );

  if (orderId != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(orderId: orderId),
      ),
    );
  }
},

                        child: Text("Order Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
