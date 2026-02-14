import 'package:flutter/material.dart';
import 'doctor_list.dart';

class DoctorsHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> specialties = [
    {"title": "Heart", "icon": Icons.favorite},
    {"title": "Leg", "icon": Icons.directions_walk},
    {"title": "Hand", "icon": Icons.pan_tool},
    {"title": "Hair", "icon": Icons.face},
    {"title": "Sugar", "icon": Icons.bloodtype},
    {"title": "Women", "icon": Icons.female},
    {"title": "Child", "icon": Icons.child_care},
    {"title": "Surgery", "icon": Icons.local_hospital},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctors")),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: specialties.length,
        itemBuilder: (context, i) {
          final s = specialties[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorListScreen(s["title"]),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(s["icon"], size: 40, color: Colors.red),
                  SizedBox(height: 10),
                  Text(
                    s["title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
