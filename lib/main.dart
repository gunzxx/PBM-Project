import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;

import 'auth/login.dart';
import 'home.dart';
import 'mylib/auth.dart' show authCheck;
import 'mylib/color.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: authCheck(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: bl1,
                body: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitCubeGrid(
                          color: b1,
                          size: 50.0,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Text("Data gagal diambil");
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data == true) {
                return const Home();
              } else {
                return const Login();
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
