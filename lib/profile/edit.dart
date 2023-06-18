import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../home.dart';
import '../mylib/color.dart';
import '../mylib/jwt.dart';

class EditProfile extends StatefulWidget {
  final int id;
  const EditProfile({
    super.key,
    required this.id,
  });

  @override
  State<EditProfile> createState() => _EditProfileState(id: id);
}

class _EditProfileState extends State<EditProfile> {
  final int id;
  final _formKey = GlobalKey<FormState>();
  late Future<Map> _futureGetId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  late Map _user;
  File? _image;

  _EditProfileState({required this.id});

  void _gantiGambarCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      setState(() {
        _image = null;
      });
    }
  }

  void _gantiGambarGaleri() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      setState(() {
        _image = null;
      });
    }
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
        Uri.parse("https://paa.gunzxx.my.id/api/user/$id"),
        headers: {"Authorization": "Bearer $jwt"},
      );
      if (response.statusCode == 200) {
        final Map user = jsonDecode(response.body)['user'];
        await saveToken(jsonDecode(response.body)['token']);
        return user;
      }
      print(jsonDecode(response.body));
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
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
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
                _user = user;
                _nameController.text = user['name'];
                _emailController.text = user['email'];
                _addressController.text = user['address'];
                return Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: w1,
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: bl1,
                                        blurRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: _image == null
                                      ? Image.network(
                                          user['profile'],
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(_image!),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  onPressed: _gantiGambarCamera,
                                  color: bl1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  minWidth: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(
                                    "Ambil foto",
                                    style: TextStyle(color: w1),
                                  ),
                                ),
                                SizedBox(width: 30),
                                MaterialButton(
                                  onPressed: _gantiGambarGaleri,
                                  color: bl1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  minWidth: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(
                                    "Unggah gambar",
                                    style: TextStyle(color: w1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: w1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            decoration: _inputDecoration("Nama"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
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
                            readOnly: true,
                            controller: _emailController,
                            decoration: _inputDecoration("Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
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
                            controller: _addressController,
                            decoration: _inputDecoration("Alamat"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
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
                                onPressed: _isLoading ? null : _editProfil,
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

  _editProfil() async {
    if (_formKey.currentState!.validate()) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        if (!context.mounted) return {};
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
                      MaterialPageRoute(
                          builder: (context) => Home(currentPage: 2)),
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
      setState(() {
        _isLoading = true;
      });
      final jwt = await getToken();
      if (_image == null) {
        final Response response = await http.post(
          Uri.parse("https://paa.gunzxx.my.id/api/user"),
          headers: {"Authorization": "Bearer $jwt"},
          body: {
            "name": _nameController.text,
            "address": _addressController.text,
          },
        );
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200) {
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
                      // Navigator.of(context).pop();
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
          );
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
            Navigator.pop(context);
          });
        }
      } else {
        var request = http.MultipartRequest(
            "POST", Uri.parse("https://paa.gunzxx.my.id/api/user"))
          ..headers['Authorization'] = "Bearer $jwt"
          ..fields['name'] = _nameController.text
          ..fields['address'] = _addressController.text
          ..files.add(http.MultipartFile.fromBytes(
            "profile",
            await _image!.readAsBytes(),
            filename: "${_user['name']}_PP",
          ));
        final StreamedResponse response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print(jsonDecode(responseBody));

        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200) {
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
                  jsonDecode(responseBody)['message'],
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
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
          );
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
                  jsonDecode(responseBody)['message'],
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
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
