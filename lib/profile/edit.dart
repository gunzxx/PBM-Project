import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../mylib/color.dart';

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
  late Future<Map> _futureGetId;

  _EditProfileState({required this.id});

  Future<Map> _getUser() async {
    final response =
        await http.get(Uri.parse("https://paa.gunzxx.my.id/api/user/1"));
    if (response.statusCode == 200) {
      final Map user = jsonDecode(response.body);
      return user;
    }
    return {};
  }

  @override
  initState() {
    super.initState();
    _futureGetId = _getUser();
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
      body: FutureBuilder(
        future: _futureGetId,
        builder: (context, snapshot) {
          return Center(child: Text(id.toString()));
        },
      ),
    );
  }
}
