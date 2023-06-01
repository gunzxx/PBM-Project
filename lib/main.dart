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
  late bool _is_login;
  @override
  initState() {
    super.initState();

    setState(() {
      authCheck().then((value) => _is_login = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _is_login ? Home() : Login(),
      ),
    );
  }
}
