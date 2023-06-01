import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pariwisata_jember/auth/login.dart';
import 'package:http/http.dart' as http;

import '../mylib/color.dart';
import '../style/buttonStyle.dart';

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
      backgroundColor: bl1,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
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
                                keyboardType: TextInputType.emailAddress,
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
                                        _obscureText1 = _obscureText1 == true
                                            ? false
                                            : true;
                                      });
                                    },
                                    child: Icon(_obscureText1
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
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
                              TextFormField(
                                controller: _password2Controller,
                                decoration: InputDecoration(
                                  label: Text("konfirmasi password"),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _obscureText2 = _obscureText2 == true
                                            ? false
                                            : true;
                                      });
                                    },
                                    child: Icon(_obscureText2
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
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
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Sudah punya akun?"),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Login()),
                                                (route) => false);
                                          },
                                          child: Text("Login"),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      style: button1(),
                                      onPressed: _isLoading ? null : _register,
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
                _isLoading
                    ? Expanded(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, .3),
                          child: Column(
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

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
              return AlertDialog(
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
              content: jsonDecode(response.body)['message'] != null
                  ? Text(jsonDecode(response.body)['message'])
                  : Text("Register berhasil!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()),
                          (route) => false);
                    },
                    child: Text("Oke"))
              ],
            );
          },
        ).then((_) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Login()),
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
              content: jsonDecode(response.body)['message'] != null
                  ? Text(jsonDecode(response.body)['message'])
                  : Text("Register gagal!"),
            );
          },
        );
      }
    }
  }
}
