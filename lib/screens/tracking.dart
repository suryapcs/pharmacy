import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Tracking")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(title: Text("Order Placed ✅")),
          ListTile(title: Text("Packed 📦")),
          ListTile(title: Text("Out for Delivery 🚚")),
          ListTile(title: Text("Delivered 🎉")),
        ],
      ),
    );
  }
}
