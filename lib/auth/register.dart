import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pariwisata_jember/auth/login.dart';
import 'package:http/http.dart' as http;

import '../mylib/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  // bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _password1Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bl1,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print("oke");
        },
        child: Center(
          child: Container(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Center(
                        child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                    )),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              label: Text("username"),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Data tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              label: Text("email"),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Data tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              label: Text("Alamat"),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Data tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password1Controller,
                            decoration: InputDecoration(
                              label: Text("password"),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText1 =
                                        _obscureText1 == true ? false : true;
                                  });
                                },
                                child: Icon(_obscureText1
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            obscureText: _obscureText1 == true ? true : false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Data tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password2Controller,
                            decoration: InputDecoration(
                              label: Text("konfirmasi password"),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText2 =
                                        _obscureText2 == true ? false : true;
                                  });
                                },
                                child: Icon(_obscureText2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            obscureText: _obscureText2 == true ? true : false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Data tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Sudah punya akun?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Login()),
                                            (route) => false);
                                      },
                                      child: Text("Login"),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: _register,
                                  child: Text("Register"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _register() async {
    if (_formKey.currentState!.validate()) {
      if (_password1Controller.text != _password2Controller.text) {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Password dan konfirmasi password harus sama.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      var response = await http.post(
        Uri.parse("https://paa.gunzxx.my.id/api/auth/register"),
        body: {"username": _usernameController.text},
      );

      if (response.statusCode == 200) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("OKE"),
            );
          },
        );
      } else {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(jsonDecode(response.body)['message']),
            );
          },
        );
      }
    }
  }
}
