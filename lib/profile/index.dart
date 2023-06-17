import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../mylib/auth.dart';
import '../mylib/bookmark.dart';
import '../mylib/color.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w1,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: w1,
        title: const Text(
          "Profile",
          style: TextStyle(color: bl1),
        ),
        centerTitle: true,
      ),
      body: ElevatedButton(
        onPressed: () async {
          await resetBookmarks();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            setLogout();
            return const Login();
          }), (route) => false);
        },
        child: const Text("Logout"),
      ),
    );
  }
}
