import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCubeGrid;

import '../color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> _tourists;
  String _errorMessage = '';

  Future<List<dynamic>> _getTourists() async {
    try {
      final response = await http
          .get(Uri.parse('https://paa.gunzxx.my.id/api/tourist'))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        setState(() {
          _errorMessage = "Gagal mengambil data!";
        });
        return [];
      }
    } catch (_) {
      setState(() {
        _errorMessage = "Terjadi kesalahan!";
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
    return Scaffold(
      backgroundColor: const Color(0xfff6efdc),
      appBar: AppBar(
        backgroundColor: const Color(0xffaddbd0),
        title: const Text(
          "Pariwisata Jember",
          style: TextStyle(color: c1),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitCubeGrid(
                    color: c2,
                    size: 50.0,
                  );
                } else if (snapshot.hasError || _errorMessage.isNotEmpty) {
                  return Column(
                    children: [
                      Text(_errorMessage.isNotEmpty
                          ? _errorMessage
                          : "Data gagal diambil"),
                      TextButton(
                          onPressed: _refreshData, child: const Text("Ulangi"))
                    ],
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final category = item['category'];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            child:
                                Image.network(item['thumb'], fit: BoxFit.cover),
                          ),
                          title: Text(item['name']),
                          subtitle: Text(category['name']),
                          onTap: () {
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
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              height: 100,
                                              child:
                                                  Image.network(item['thumb']),
                                            ),
                                          ],
                                        ),
                                        Text("Lokasi : ${item['location']}"),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(item['description']),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                });
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
      ),
    );
  }
}
