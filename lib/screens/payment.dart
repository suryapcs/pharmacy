import 'package:flutter/material.dart';
import 'package:pharmacy/screens/payment_success.dart';
import 'package:pharmacy/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  PaymentScreen({required this.orderId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List items = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId")!;

    final orders = await ApiService.getOrdersByUser(userId);

    final order = orders.firstWhere(
        (o) => o["_id"] == widget.orderId && o["status"] == 0
    );

    items = order["medicines"];
    total = order["totalAmount"];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: items.map<Widget>((e) {
                return ListTile(
                  title: Text(e["name"]),
                  trailing: Text("₹${e["price"] * e["count"]}"),
                );
              }).toList(),
            ),
          ),

          Text("Total : ₹$total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          ElevatedButton(
            onPressed: () async {
              final success = await ApiService.payOrder(widget.orderId);

              if (success) {
                final prefs = await SharedPreferences.getInstance();
                final userName = prefs.getString("userName") ?? "User";

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentSuccessScreen(
                      userName: userName,
                      amount: total,
                    ),
                  ),
                );
              }
            },
            child: Text("Pay Now"),
          ),
        ],
      ),
    );
  }
}
