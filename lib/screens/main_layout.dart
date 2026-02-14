import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_medicine.dart';
import 'cart.dart';
import 'track.dart';
import 'login.dart';
import 'doctors_home.dart'; // 🔥 ADD

class MainLayout extends StatefulWidget {
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  int cartCount = 0;

  final pages = [
    SearchMedicineScreen(),
    DoctorsHomeScreen(), // 🔥 NEW
    CartScreen(),
    TrackScreen(),
  ];

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == 4) {
            logout();
          } else {
            setState(() => _currentIndex = i);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: "Doctors",
          ),

          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartCount.toString(),
                        style:
                            TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: "Track",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Logout",
          ),
        ],
      ),
    );
  }
}
