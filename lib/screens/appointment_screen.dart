import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  final String doctorName;
  AppointmentScreen(this.doctorName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Center(
        child: Text(
          "Booking appointment with Dr. $doctorName",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
