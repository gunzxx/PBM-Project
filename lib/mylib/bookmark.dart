import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addBookmark(Map tourist) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bookmarkJSON =
      prefs.getString('bookmark') == null ? '[]' : prefs.getString('bookmark')!;
  final List bookmark = jsonDecode(bookmarkJSON);

  bool lanjut = true;
  final int id = tourist['id'].runtimeType == int
      ? tourist['id']
      : int.parse(tourist['id']);

  for (var i = 0; i < bookmark.length; i++) {
    final data = await bookmark[i];
    if (await data['id'] == id) {
      lanjut = false;
      break;
    }
  }

  if (lanjut == true) {
    bookmark.add(tourist);
    bookmarkJSON = jsonEncode(bookmark);
    prefs.setString('bookmark', bookmarkJSON);
    return true;
  }
  return false;
}

Future<void> removeBookmark(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookmarkJSON =
      prefs.getString('bookmark') == null ? '[]' : prefs.getString('bookmark')!;
  final List bookmark = jsonDecode(bookmarkJSON);

  for (var i = 0; i < bookmark.length; i++) {
    final data = await bookmark[i];
    if (await data['id'] == id) {
      bookmark.remove(data);
    }
  }

  bookmarkJSON = jsonEncode(bookmark);
  prefs.setString('bookmark', bookmarkJSON);
}

Future<String> getBookmark() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('bookmark') ?? "[]";
}

Future<bool> cekBookmark(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookmarkJSON = prefs.getString('bookmark') ?? "[]";
  final bookmark = jsonDecode(bookmarkJSON);

  for (var i = 0; i < bookmark.length; i++) {
    final data = await bookmark[i];
    if (await data['id'] == id) {
      return true;
    }
  }

  return false;
}
