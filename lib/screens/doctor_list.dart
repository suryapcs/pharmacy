import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';
import 'dummy_doctors.dart';
import 'appointment_screen.dart'; // 👈 make sure this exists

class DoctorListScreen extends StatelessWidget {
  final String specialization;
  DoctorListScreen(this.specialization);

  @override
  Widget build(BuildContext context) {
    final doctors = dummyDoctors[specialization] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("$specialization Doctors")),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, i) {
          final d = doctors[i];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(d["img"]!),
              ),
              title: Text(
                d["name"]!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${d["exp"]} yrs experience"),

              // 🔥 HERE IS THE IMPORTANT PART
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 💬 AI CHAT
                  IconButton(
                    icon: Icon(Icons.chat, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AiChatScreen(
                            specialization: specialization,
                          ),
                        ),
                      );
                    },
                  ),

                  // 📅 APPOINTMENT
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AppointmentScreen(d["name"]!),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
