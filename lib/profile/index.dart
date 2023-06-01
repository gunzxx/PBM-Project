import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../mylib/auth.dart';
import '../mylib/color.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w1,
      appBar: AppBar(
        backgroundColor: bl1,
        title: const Text(
          "Profile",
          style: TextStyle(color: b1),
        ),
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            setLogout();
            return Login();
          }), (route) => false);
        },
        child: Text("Logout"),
      ),
    );
  }
}
