import 'dart:convert';

import 'package:flutter/material.dart';

import '../mylib/bookmark.dart';
import '../mylib/color.dart';
import '../mylib/string.dart';
import '../tourist/detail_tourist_page.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  late Future _bookmarks;
  bool _onLoading = false;

  @override
  initState() {
    super.initState();
    _bookmarks = getBookmark();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _bookmarks = getBookmark();
          });
          await _bookmarks;
        },
        child: FutureBuilder(
          future: _bookmarks,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Terjadi kesalahan."),
              );
            } else if (snapshot.hasData) {
              final tourists = jsonDecode(snapshot.data!);
              _onLoading = false;
              return GridView.builder(
                itemCount: tourists.length,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailTouristPage(tourists[index])));
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
                                    tourists[index]['thumb'],
                                    fit: tourists[index]['thumb'] !=
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
                                tourists[index]['name'],
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(strLimit(tourists[index]['description'], 15),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: _onLoading == true
                                    ? null
                                    : () async {
                                        await removeBookmark(
                                            tourists[index]['id']);
                                        setState(() {
                                          _bookmarks = getBookmark();
                                          _onLoading = true;
                                        });
                                      },
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.delete)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text("OKe"));
          },
        ),
      ),
    );
  }
}
