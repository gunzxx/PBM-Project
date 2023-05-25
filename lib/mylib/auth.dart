import 'package:shared_preferences/shared_preferences.dart';

void setLogout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
}

void setLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
}

Future<bool> authCheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? status = prefs.getBool('isLoggedIn');

  if (status == true) {
    return true;
  } else {
    return false;
  }
}
