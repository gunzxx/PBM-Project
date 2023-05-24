import 'package:flutter/material.dart';

import 'tourist/index.dart';
import '../mylib/jwt.dart';

void main() {
  getToken().then((value) => print(value));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
