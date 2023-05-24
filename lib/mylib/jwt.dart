import 'package:shared_preferences/shared_preferences.dart';

// Menyimpan token JWT
Future<void> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt_token', token);
}

// Mendapatkan token JWT
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

  if (token != null) {
    return token;
  } else {
    return null;
  }
}


// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// // Menyimpan token JWT
// Future<void> saveToken(String token) async {
//   final storage = FlutterSecureStorage();
//   await storage.write(key: 'jwt_token', value: token);
// }

// // Mendapatkan token JWT
// Future<String?> getToken() async {
//   final storage = FlutterSecureStorage();
//   String? token = await storage.read(key: 'jwt_token');
//   if (token != null) {
//     return token;
//   } else {
//     return "";
//   }
// }