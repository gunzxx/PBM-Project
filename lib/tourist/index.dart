import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        Widget,
        BuildContext,
        GestureDetector,
        FocusScope,
        Scaffold,
        Color,
        AppBar,
        Text,
        TextStyle,
        Center,
        Container,
        EdgeInsets,
        Column,
        TextField,
        TextInputAction,
        InputDecoration,
        IconButton,
        Icon,
        Icons,
        SizedBox,
        Expanded,
        RefreshIndicator,
        FutureBuilder,
        ConnectionState,
        MainAxisAlignment,
        TextButton,
        ListView,
        ListTile,
        Card,
        Image,
        BoxFit,
        showDialog,
        FocusNode,
        CrossAxisAlignment,
        AlertDialog,
        Row,
        Navigator,
        MaterialPageRoute;
import 'package:http/http.dart' as http show get;
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;

import '../mylib/color.dart';
import 'search.dart';

class Tourist extends StatefulWidget {
  const Tourist({super.key});

  @override
  State<Tourist> createState() => _TouristState();
}

class _TouristState extends State<Tourist> {
  late Future<List<dynamic>> _tourists;
  String url = 'https://paa.gunzxx.my.id/api/tourist';
  String _errorMessage = '';
  FocusNode _searchInput = FocusNode();

  Future<List<dynamic>> _getTourists(
      {String url = 'https://paa.gunzxx.my.id/api/tourist'}) async {
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

  Future<void> _refreshData() async {
    setState(() {
      _tourists = _getTourists();
      _errorMessage = '';
    });
    await _tourists;
  }

  @override
  initState() {
    super.initState();
    _tourists = _getTourists();
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
          backgroundColor: bl1,
          title: const Text(
            "Pariwisata Jember",
            style: TextStyle(color: b1),
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  focusNode: _searchInput,
                  onTap: () {
                    _searchInput.unfocus();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Search()));
                  },
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Cari...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: null,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      setState(() {
                        _tourists = _getTourists();
                        _errorMessage = '';
                      });
                      return _tourists;
                    },
                    child: FutureBuilder<List<dynamic>>(
                      future: _tourists,
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
                          final data = snapshot.data!;
                          return data.isEmpty
                              ? const Text("Tidak ada data.")
                              : ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final item = data[index];
                                    final category = item['category'];
                                    return Card(
                                      child: ListTile(
                                        leading: SizedBox(
                                          width: 60,
                                          child: Image.network(item['thumb'],
                                              fit: BoxFit.cover),
                                        ),
                                        title: Text(item['name']),
                                        subtitle: Text(category['name']),
                                        hoverColor: const Color.fromRGBO(
                                            255, 255, 255, .3),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(item['name']),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          height: 100,
                                                          child: Image.network(
                                                              item['thumb']),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                        "Lokasi : ${item['location']}"),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10),
                                                      child: Text(
                                                          item['description']),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("OK"))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                        } else {
                          return const Text("Tidak ada data");
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
