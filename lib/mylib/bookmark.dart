import 'dart:convert';
import '../model/bookmark_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<BookmarkModel>> getBookmarks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bookmarkJSON = prefs.getString('bookmark') ?? '[]';
  final List bookmarks = jsonDecode(bookmarkJSON);

  List<BookmarkModel> touristBookmark = [];
  for (var i = 0; i < bookmarks.length; i++) {
    final BookmarkModel bookmark = BookmarkModel(
      id: bookmarks[i]['id'],
      name: bookmarks[i]['name'],
      description: bookmarks[i]['description'],
      location: bookmarks[i]['location'],
      latitude: bookmarks[i]['latitude'],
      longitude: bookmarks[i]['longitude'],
      thumb: bookmarks[i]['thumb'],
      previewUrl: bookmarks[i]['preview_url'],
    );
    touristBookmark.add(bookmark);
  }

  return touristBookmark;
}

Future<bool> cekBookmark(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookmarkJSON = prefs.getString('bookmark') ?? "[]";
  final List bookmarks = jsonDecode(bookmarkJSON);

  for (var i = 0; i < bookmarks.length; i++) {
    if (bookmarks[i]['id'] == id) {
      return true;
    }
  }

  return false;
}

Future<bool> addBookmark(BookmarkModel tourist) async {
  bool lanjut = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bookmarkJSON = prefs.getString('bookmark') ?? '[]';
  final List bookmarks = jsonDecode(bookmarkJSON);

  for (var i = 0; i < bookmarks.length; i++) {
    if (bookmarks[i]['id'] == tourist.id) {
      lanjut = false;
      break;
    }
  }

  if (lanjut == true) {
    final Map newTourist = {
      'id': tourist.id,
      'name': tourist.name,
      'description': tourist.description,
      'location': tourist.location,
      'latitude': tourist.latitude,
      'longitude': tourist.longitude,
      'thumb': tourist.thumb,
      'preview_url': tourist.previewUrl,
    };

    bookmarks.add(newTourist);
    bookmarkJSON = jsonEncode(bookmarks);
    prefs.setString('bookmark', bookmarkJSON);
    return true;
  }
  return false;
}

Future<bool> removeBookmark(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bookmarkJSON = prefs.getString('bookmark') ?? '[]';
  final List bookmarks = jsonDecode(bookmarkJSON);

  for (var i = 0; i < bookmarks.length; i++) {
    final data = bookmarks[i];
    if (data['id'] == id) {
      bookmarks.remove(data);
    }
  }

  bookmarkJSON = jsonEncode(bookmarks);
  prefs.setString('bookmark', bookmarkJSON);

  return true;
}

Future<bool> resetBookmarks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bookmarkJSON = prefs.getString('bookmark') ?? '[]';
  final List bookmarks = jsonDecode(bookmarkJSON);

  bookmarks.clear();
  bookmarkJSON = jsonEncode(bookmarks);
  prefs.setString('bookmark', bookmarkJSON);

  return true;
}
