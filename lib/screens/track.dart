import 'package:flutter/material.dart';
import 'package:pharmacy/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId")!;
    orders = await ApiService.getOrdersByUser(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track Orders")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final o = orders[i];
        return Card(
  child: ListTile(
    title: Text("Order #${o["_id"]}"),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          o["status"] == 0
              ? "Not Paid • Medicine on the way 🚚"
              : "Paid • Delivered ✅",
        ),
        SizedBox(height: 4),
        Text(
          "Ordered on: ${DateTime.parse(o["createdAt"]).toLocal().toString().split('.')[0]}",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    ),
    trailing: Text("₹${o["totalAmount"]}"),
  ),
);

        },
      ),
    );
  }
}
