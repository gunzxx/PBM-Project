import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pariwisata_jember/profile/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../mylib/auth.dart';
import '../mylib/bookmark.dart';
import '../mylib/color.dart';
import '../mylib/jwt.dart';
import 'edit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future _futureGetUser;
  final String _default = "https://paa.gunzxx.my.id/img/profile/default.png";

  Future<Map> _getUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map authUser = jsonDecode(prefs.getString('authUser') ?? '{}');

    if (authUser.isEmpty) {
      await resetBookmarks();
      if (!context.mounted) return {};
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) {
          setLogout();
          return const Login();
        },
      ), (route) => false);
      return {};
    } else {
      final jwt = await getToken();
      final response = await http.get(
        Uri.parse("https://paa.gunzxx.my.id/api/user/${authUser['id']}"),
        headers: {"Authorization": "Bearer $jwt"},
      );
      try {
        await saveToken(jsonDecode(response.body)['token']);
        return jsonDecode(response.body)['user'];
      } on Error catch (_) {
        await resetBookmarks();
        if (!context.mounted) return {};
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) {
            setLogout();
            return const Login();
          },
        ), (route) => false);
        return {};
      }
    }
  }

  _logout(BuildContext context) async {
    await resetBookmarks();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      setLogout();
      return const Login();
    }), (route) => false);
  }

  @override
  initState() {
    super.initState();
    _futureGetUser = _getUserAuth();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: w1,
        title: const Text(
          "Profile",
          style: TextStyle(color: bl1),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: _futureGetUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          padding: user['profile'] == _default
                              ? const EdgeInsets.all(10)
                              : EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: w1,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: bl1,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Image.network(
                            user['profile'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                user['email'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: w1,
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Keluar?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Tidak",
                                          style: TextStyle(color: bl1),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _logout(context);
                                        },
                                        child: Text(
                                          "Iya",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Expanded(
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: bl1,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return EditProfile(id: user['id']);
                                  },
                                ));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Edit Profil',
                                      style: TextStyle(
                                        color: w1,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      color: w1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: bl1,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PasswordPage(id: user['id']);
                                  },
                                ));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ganti Password',
                                      style: TextStyle(
                                        color: w1,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      color: w1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(bl1)),
                    onPressed: _logout(context),
                    child: const Text("Logout", style: TextStyle(color: bl1)),
                  ),
                ],
              );
            }
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SpinKitCubeGrid(
                    color: bl1,
                    size: 50.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
