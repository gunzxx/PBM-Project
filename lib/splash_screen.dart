import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:pariwisata_jember/main.dart' show MyApp2;
import 'package:pariwisata_jember/mylib/color.dart' show bl1;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  _loadSplashScreen() async {
    await Future.delayed(Duration(seconds: 3));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => MyApp2(),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: bl1,
          child: Center(
            child: Image.asset(
              'assets/logo.png',
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}
