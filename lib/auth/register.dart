import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import '../auth/login.dart';
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
  bool _isLoading = false;

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
      backgroundColor: bl2,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            color: bl2,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 240,
                        child: Center(
                            child: Image.asset(
                          'assets/logo.png',
                          height: 100,
                        )),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: w1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: _inputDecoration(
                                  'Username',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: w1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: _inputDecoration(
                                  'Email',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: w1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _addressController,
                                decoration: _inputDecoration(
                                  'Alamat',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: w1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _password1Controller,
                                decoration: _inputDecoration(
                                  'Password',
                                  secure: true,
                                  iconActive: _obscureText1,
                                  secureOption: _obsecure1,
                                ),
                                obscureText:
                                    _obscureText1 == true ? true : false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: w1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: _password2Controller,
                                decoration: _inputDecoration(
                                  'Konfirmasi Password',
                                  secure: true,
                                  iconActive: _obscureText2,
                                  secureOption: _obsecure2,
                                ),
                                obscureText:
                                    _obscureText2 == true ? true : false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    minWidth: 100,
                                    height: 42.0,
                                    color: b1,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const Login()),
                                          (route) => false);
                                    },
                                    child: const Text(
                                      "Masuk   <<",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    minWidth: 100,
                                    height: 42.0,
                                    color: b1,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: _isLoading ? null : _register,
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  _register() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (_password1Controller.text != _password2Controller.text) {
        setState(() {
          _isLoading = false;
        });
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Password dan konfirmasi password harus sama.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Lokasi tidak aktif"),
            );
          },
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoading = false;
          });
          return showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text("Lokasi tidak diizinkan"),
              );
            },
          );
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      final latitude = position.latitude;
      final longitude = position.longitude;

      var response = await http.post(
        Uri.parse("https://paa.gunzxx.my.id/api/auth/register"),
        body: {
          "name": _usernameController.text,
          "email": _emailController.text,
          "password": _password1Controller.text,
          "address": _addressController.text,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        },
      );

      if (response.statusCode == 201) {
        FocusScope.of(context).unfocus();
        setState(() {
          _isLoading = false;
        });
        return showDialog(
          context: context,
          useSafeArea: true,
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
                jsonDecode(response.body)['message'] != null
                    ? jsonDecode(response.body)['message']
                    : 'Register gagal',
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
        ).then((_) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()),
              (route) => false);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
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
                jsonDecode(response.body)['message'] ?? 'Register gagal',
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
}
