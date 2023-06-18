import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;
import '../home.dart';
import '../mylib/color.dart';
import '../mylib/jwt.dart';

class PasswordPage extends StatefulWidget {
  final int id;
  const PasswordPage({
    required this.id,
    super.key,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<Map> _futureGetId;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  _gantiPassword(int id) async {
    try {
      if (_formKey.currentState!.validate()) {
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          if (!context.mounted) return;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: const Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: Colors.red,
                  ),
                  content: const Text(
                    "Kesalahan jaringan.",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                );
              });
          return;
        }

        final String jwt = await getToken() ?? "";
        final http.Response response = await http.put(
          Uri.parse("https://paa.gunzxx.my.id/api/user/password"),
          body: {
            "password": _oldPasswordController.text,
            "new_password": _newPasswordController.text,
            "new_password_confirmation": _passwordConfirmationController.text,
          },
          headers: {
            "Authorization": "Bearer $jwt",
          },
        );
        if (response.statusCode == 200) {
          await saveToken(jsonDecode(response.body)['token']);
          if (!context.mounted) return {};
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: const Icon(
                  Icons.check_circle,
                  size: 64.0,
                  color: Colors.green,
                ),
                content: Text(
                  jsonDecode(response.body)['message'],
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Home(currentPage: 2)),
                      );
                    },
                    child: const Text(
                      'Oke',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).then((_) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Home(currentPage: 2)),
            );
          });
        } else {
          if (!context.mounted) return {};
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: const Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: Colors.red,
                ),
                content: Text(
                  jsonDecode(response.body)['message'],
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Home(currentPage: 2)),
                      );
                    },
                    child: const Text(
                      'Oke',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).then(
            (_) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Home(currentPage: 2)),
              );
            },
          );
        }
      }
    } on Error catch (_) {}
  }

  Future<Map> _getUser() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        if (!context.mounted) return {};
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: const Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: Colors.red,
                ),
                content: const Text(
                  "Kesalahan jaringan.",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            });
        return {};
      }
      final jwt = await getToken();
      http.Response response = await http.get(
        Uri.parse("https://paa.gunzxx.my.id/api/user/1"),
        headers: {"Authorization": "Bearer $jwt"},
      );
      if (response.statusCode == 200) {
        final Map user = jsonDecode(response.body)['user'];
        await saveToken(jsonDecode(response.body)['token']);
        return user;
      }
      return {};
    } on Error catch (_) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Icon(
                Icons.error_outline,
                size: 64.0,
                color: Colors.red,
              ),
              content: const Text(
                "Terjadi kesalahan.",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          });
      return {};
    }
  }

  @override
  initState() {
    super.initState();
    _futureGetId = _getUser();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    _passwordConfirmationController.dispose();
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
          "Edit Profile",
          style: TextStyle(color: bl1),
        ),
        centerTitle: true,
        leading: MaterialButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: Icon(Icons.arrow_back, color: bl1),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder(
            future: _futureGetId,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: w1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _oldPasswordController,
                            obscureText: _obscureText1,
                            decoration: _inputDecoration(
                              "Password lama",
                              secure: true,
                              iconActive: _obscureText1,
                              secureOption: _obsecure1,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password lama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: w1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _newPasswordController,
                            obscureText: _obscureText2,
                            decoration: _inputDecoration(
                              "Password baru",
                              secure: true,
                              iconActive: _obscureText2,
                              secureOption: _obsecure2,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password baru tidak boleh kosong.';
                              }
                              if (_newPasswordController.text !=
                                  _passwordConfirmationController.text) {
                                return "Password tidak sama.";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: w1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _passwordConfirmationController,
                            obscureText: _obscureText3,
                            decoration: _inputDecoration(
                              "Konfirmasi password",
                              secure: true,
                              iconActive: _obscureText3,
                              secureOption: _obsecure3,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              if (_newPasswordController.text !=
                                  _passwordConfirmationController.text) {
                                return "Password tidak sama.";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                minWidth: 100,
                                height: 42.0,
                                color: bl1,
                                disabledColor: Color.fromRGBO(0, 0, 0, 1),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _gantiPassword(user['id']);
                                      },
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: bl1, blurRadius: 1)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: bl1,
                    size: 50.0,
                  ),
                  SizedBox(height: 30),
                  Text("Mengambil data..."),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String text, {
    bool secure = false,
    bool iconActive = false,
    Function()? secureOption,
  }) {
    return InputDecoration(
      labelText: text,
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: b1,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: b1,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: w1,
      labelStyle: const TextStyle(
        color: b1,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: b1,
          ),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: b1,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: secure
          ? InkWell(
              onTap: secureOption,
              child: Icon(iconActive ? Icons.visibility_off : Icons.visibility,
                  color: b1),
            )
          : null,
    );
  }

  _obsecure1() {
    setState(() {
      _obscureText1 = _obscureText1 == true ? false : true;
    });
  }

  _obsecure2() {
    setState(() {
      _obscureText2 = _obscureText2 == true ? false : true;
    });
  }

  _obsecure3() {
    setState(() {
      _obscureText3 = _obscureText3 == true ? false : true;
    });
  }
}
