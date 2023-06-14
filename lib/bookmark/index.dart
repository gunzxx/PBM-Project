import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../mylib/bookmark.dart';
import '../state/bookmark_state.dart';
import 'package:provider/provider.dart';

import '../model/bookmark_model.dart';
import '../mylib/color.dart';
import '../tourist/detail_tourist_page.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  // Future<List<BookmarkModel>>? _touristFuture;
  // List<BookmarkModel> _tourists = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = Provider.of<BookmarkState>(context);
    // _touristFuture = bookmarkState.getData();
    return Scaffold(
      backgroundColor: w1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bl1,
        title: const Text(
          "Penanda",
          style: TextStyle(color: b1),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: bookmarkState.getBookmarksShared(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<BookmarkModel> _tourists = snapshot.data!;
              return GridView.builder(
                itemCount: _tourists.length,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              DetailTouristPage(_tourists[index]),
                          transitionsBuilder: (_, a, __, c) =>
                              FadeTransition(opacity: a, child: c),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                          color: w1,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .1),
                              blurRadius: 10,
                            )
                          ]),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    _tourists[index].thumb,
                                    fit: _tourists[index].thumb !=
                                            "https://paa.gunzxx.my.id/img/tourist/default.png"
                                        ? BoxFit.cover
                                        : BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                          child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _tourists[index].name,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () async {
                                  await removeBookmark(_tourists[index].id);
                                  bookmarkState.bookmarks =
                                      await getBookmarks();
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Column(children: [
              SpinKitCubeGrid(
                color: bl1,
                size: 50.0,
              ),
            ]);
          },
        ),
      ),
    );
  }
}
