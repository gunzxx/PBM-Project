import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;
import 'package:provider/provider.dart';

import 'auth/login.dart';
import 'home.dart';
import 'mylib/auth.dart' show authCheck;
import 'mylib/color.dart';
import 'state/bookmark_state.dart';
import 'state/home_category_state.dart';
import 'state/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => BookmarkState()),
        ChangeNotifierProvider(create: (_) => HomeCategoryState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: authCheck(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: w1,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitCubeGrid(
                          color: bl1,
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
                return Home();
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
