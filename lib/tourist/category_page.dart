import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/bookmark_model.dart';
import '../mylib/color.dart';
import 'detail_tourist_page.dart';

class CategoryPage extends StatefulWidget {
  final CategoryFrame category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState(category: category);
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryFrame category;
  late Future<List<BookmarkModel>> _futureGetCategory;

  _CategoryPageState({required this.category});

  Future<List<BookmarkModel>> _getCategory() async {
    final response = await http
        .get(Uri.parse("https://paa.gunzxx.my.id/api/category/${category.id}"));
    if (response.statusCode == 200) {
      List<BookmarkModel> datas = [];
      final List tourists = jsonDecode(response.body)['data']['tourist'];
      for (var i = 0; i < tourists.length; i++) {
        final tourist = tourists[i];
        final data = BookmarkModel(
          id: tourist['id'],
          name: tourist['name'],
          description: tourist['description'],
          latitude: tourist['latitude'],
          longitude: tourist['longitude'],
          location: tourist['location'],
          thumb: tourist['thumb'],
          previewUrl: jsonDecode(tourist['preview_url']),
        );
        datas.add(data);
      }
      return datas;
    }
    return Future.error('Terjadi kesalahan.');
  }

  @override
  initState() {
    super.initState();
    _futureGetCategory = _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bl1,
        title: Text(
          category.name,
          style: TextStyle(color: w1),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _futureGetCategory,
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
                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: IconButton(
                          //       onPressed: () async {
                          //         await removeBookmark(_tourists[index].id);
                          //         bookmarkState.bookmarks =
                          //             await getBookmarks();
                          //       },
                          //       padding: EdgeInsets.zero,
                          //       icon: const Icon(Icons.delete)),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Expanded(
                  child: Column(
                children: [
                  Text('Terjadi kesalahan.'),
                ],
              ));
            }
            return Expanded(
              child: SpinKitCubeGrid(
                color: bl1,
                size: 50.0,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryFrame {
  final String name;
  final int id;

  CategoryFrame({required this.name, required this.id});
}
