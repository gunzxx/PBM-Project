import 'package:flutter/foundation.dart';
import '../model/bookmark_model.dart';
import '../mylib/bookmark.dart';

class BookmarkState extends ChangeNotifier {
  List<BookmarkModel> _bookmarks = [];
  Future<List<BookmarkModel>>? _bookmarkFuture;

  Future<List<BookmarkModel>> getData() {
    if (_bookmarkFuture == null) {
      _bookmarkFuture = getBookmarksShared();
    }
    return _bookmarkFuture!;
  }

  Future<List<BookmarkModel>> getBookmarksShared() async {
    return await getBookmarks();
  }

  void add(BookmarkModel bookmark) {
    _bookmarks.add(bookmark);
    notifyListeners();
  }

  void remove(int id) {
    _bookmarks.removeWhere((bookmarkModel) => bookmarkModel.id == id);
    notifyListeners();
  }

  void reset() {
    _bookmarks.clear();
    notifyListeners();
  }

  BookmarkModel getOne(int id) {
    return _bookmarks.firstWhere((bookmarkModel) => bookmarkModel.id == id);
  }

  bool check(int id) {
    return _bookmarks.any((bookmarkModel) => bookmarkModel.id == id);
  }

  List<BookmarkModel> getAll() {
    return _bookmarks;
  }

  List<BookmarkModel> get bookmarks => _bookmarks;
  set bookmarks(List<BookmarkModel> newBookmark) {
    _bookmarks = newBookmark;
    notifyListeners();
  }
}
