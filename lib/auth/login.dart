// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../mylib/auth.dart';
import '../mylib/color.dart';
import '../mylib/jwt.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            color: bl2,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/logo.png",
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: w1,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: _inputDecoration("Email"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: w1,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText ? true : false,
                                  decoration: _inputDecoration("Password",
                                      secure: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              MaterialButton(
                                minWidth: 190,
                                height: 42.0,
                                color: b1,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: _isLoading ? null : _login,
                                child: const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 70),
                              const Text("Tidak punya akun?",
                                  style: TextStyle(color: Colors.white)),
                              const SizedBox(height: 30),
                              MaterialButton(
                                minWidth: 190,
                                height: 42.0,
                                color: b1,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const RegisterPage()),
                                      (route) => false);
                                },
                                child: const Text(
                                  "Daftar sekarang >>",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? Expanded(
                        child: Container(
                          color: const Color.fromRGBO(0, 0, 0, .3),
                          child: const Column(
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
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    FocusScope.of(context).unfocus();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return await showDialog(
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
              'Kesalahan jaringan.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false,
                  );
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
        },
      );
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;

      var response = await http.post(
        Uri.parse("https://paa.gunzxx.my.id/api/auth/login"),
        body: {
          "email": email,
          "password": password,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        saveToken(token);
        setLogin();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map user = jsonDecode(response.body)['user'];
        if (user['profile'] == "") {
          user['profile'] = "https://paa.gunzxx.my.id/img/profile/default.png";
        }
        prefs.setString('authUser', jsonEncode(user));
        return await showDialog(
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
              content: const Text(
                'Login berhasil.',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false,
                    );
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
          },
        ).then((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (route) => false,
          );
        });
      } else {
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
              content: const Text(
                'Login gagal.',
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
          },
        );
      }
    }
  }

  InputDecoration _inputDecoration(String text, {bool secure = false}) {
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
              onTap: () {
                setState(() {
                  _obscureText = _obscureText == true ? false : true;
                });
              },
              child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: b1),
            )
          : null,
    );
  }
}
