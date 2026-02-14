import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String userName;
  final double amount;

  PaymentSuccessScreen({
    required this.userName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text(
                "Payment Successful 🎉",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Thank you, $userName",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Paid Amount: ₹$amount",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: Text("Go Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
