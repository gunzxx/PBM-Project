import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;

import 'auth/login.dart';
import 'home.dart';
import 'mylib/auth.dart' show authCheck;
import 'mylib/color.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: authCheck(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: c2,
                    size: 50.0,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text("Data gagal diambil");
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data || data == true) {
                return const Login();
              } else {
                return const Home();
              }
            } else {
              return const Text("Tidak ada data");
            }
          },
        ),
      ),
    );
  }
}
