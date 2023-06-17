import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Menyimpan data User
Future<void> setUser(Map user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('authUser', jsonEncode(user));
}

// Mendapatkan dataUser
Future<Map> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map user = jsonDecode(prefs.getString('authUser') ?? '{}');
  return user;
}
