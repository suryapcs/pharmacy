import 'package:flutter/material.dart';
import 'package:pharmacy/screens/main_layout.dart';
import 'package:pharmacy/services/auth_service.dart';
import 'search_medicine.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: pass, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
             onPressed: () async {
  final res = await ApiService.login(email.text, pass.text);

  if (res != null) {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userId", res["userId"]);
    await prefs.setString("token", res["token"]);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainLayout()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed")),
    );
  }
},

              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text("Create Account"),
            )
          ],
        ),
      ),
    );
  }
}
