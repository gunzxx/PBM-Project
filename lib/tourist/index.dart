import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;

import '../mylib/color.dart';
import '../mylib/string.dart';
import 'detail_tourist_page.dart';
import 'search.dart';

class Tourist extends StatefulWidget {
  const Tourist({super.key});

  @override
  State<Tourist> createState() => _TouristState();
}

class _TouristState extends State<Tourist> {
  late Future<List<dynamic>> _categories;
  late Future<List<dynamic>> _tourists;
  String _errorMessage = '';
  String _errorMessageTourist = '';
  final FocusNode _searchInput = FocusNode();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<List<dynamic>> _getCategories(
      {String url = 'https://paa.gunzxx.my.id/api/category'}) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        setState(() {
          _errorMessage = "Gagal mengambil data.";
        });
        return [];
      }
    } catch (_) {
      setState(() {
        _errorMessage = "Terjadi kesalahan.";
      });
      return [];
    }
  }

  Future<List<dynamic>> _getTourists(int id) async {
    try {
      final response = await http
          .get(Uri.parse('https://paa.gunzxx.my.id/api/category/$id'))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['tourist'];
      } else {
        setState(() {
          _errorMessageTourist = "Gagal mengambil data.";
        });
        return [];
      }
    } catch (_) {
      setState(() {
        _errorMessageTourist = "Terjadi kesalahan.";
      });
      return [];
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _categories = _getCategories();
      _errorMessage = '';
    });
    await _categories;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _categories = _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: w1,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bl1,
          title: const Text(
            "Pariwisata Jember",
            style: TextStyle(color: b1),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _categories = _getCategories();
              _errorMessage = '';
            });
            return _categories;
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 30),
                    child: TextField(
                      focusNode: _searchInput,
                      onTap: () {
                        _searchInput.unfocus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Search()));
                      },
                      enableInteractiveSelection: false,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Cari...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitCubeGrid(
                                color: bl1,
                                size: 50.0,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError ||
                            _errorMessage.isNotEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_errorMessage.isNotEmpty
                                  ? _errorMessage
                                  : "Data gagal diambil"),
                              TextButton(
                                  onPressed: _refreshData,
                                  child: const Text("Ulangi"))
                            ],
                          );
                        } else if (snapshot.hasData) {
                          final categories = snapshot.data!;
                          return categories.isEmpty
                              ? const Center(child: Text("Tidak ada data."))
                              : ListView.builder(
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    _tourists = _getTourists(category['id']);
                                    return Column(
                                      children: [
                                        Text(
                                          category['name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 180,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: FutureBuilder(
                                            future: _tourists,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child: SpinKitCubeGrid(
                                                    color: bl1,
                                                    size: 50.0,
                                                  ),
                                                );
                                              } else if (snapshot.hasError ||
                                                  _errorMessageTourist
                                                      .isNotEmpty) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(_errorMessageTourist
                                                            .isNotEmpty
                                                        ? _errorMessageTourist
                                                        : "Data gagal diambil"),
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _tourists =
                                                                _getTourists(
                                                                    category[
                                                                        'id']);
                                                            _errorMessageTourist =
                                                                '';
                                                          });
                                                        },
                                                        child: const Text(
                                                            "Ulangi"))
                                                  ],
                                                );
                                              } else if (snapshot.hasData) {
                                                final tourists = snapshot.data!;
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: tourists.length,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final tourist =
                                                        tourists[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DetailTouristPage(
                                                                        tourist)));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                            color: w1,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        .1),
                                                                blurRadius: 10,
                                                              )
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            AspectRatio(
                                                              aspectRatio:
                                                                  16 / 9,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child: Image
                                                                    .network(
                                                                  tourist[
                                                                      'thumb'],
                                                                  fit: tourist[
                                                                              'thumb'] !=
                                                                          "https://paa.gunzxx.my.id/img/tourist/default.png"
                                                                      ? BoxFit
                                                                          .cover
                                                                      : BoxFit
                                                                          .contain,
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              loadingProgress.expectedTotalBytes!
                                                                          : null,
                                                                    ));
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              tourist['name'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                                strLimit(
                                                                    tourist[
                                                                        'description'],
                                                                    15),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              return const Center(
                                                child: Text("Tidak ada data"),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                        } else {
                          return const Text("Tidak ada data");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
