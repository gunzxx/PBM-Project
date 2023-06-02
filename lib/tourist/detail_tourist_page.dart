import 'dart:convert';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter/material.dart';

import '../mylib/color.dart';
import '../mylib/string.dart';

class DetailTouristPage extends StatefulWidget {
  final dynamic _tourist;
  const DetailTouristPage(this._tourist, {super.key});

  @override
  State<DetailTouristPage> createState() => _DetailTouristPageState(_tourist);
}

class _DetailTouristPageState extends State<DetailTouristPage> {
  final dynamic _tourist;
  final List<dynamic> _previewUrl = [];
  final url = "https://paa.gunzxx.my.id/img/tourist/default.png";

  _DetailTouristPageState(this._tourist);

  @override
  initState() {
    super.initState();
    final thumb = _tourist['thumb'];
    _previewUrl.add(thumb);

    final List preview = jsonDecode(_tourist['preview_url']);

    for (var i = 0; i < preview.length; i++) {
      _previewUrl.add(preview[i]);
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bl1,
        title: Text(
          strLimit(_tourist['name'], 30),
          style: const TextStyle(color: b1),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Swiper(
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(_previewUrl[index],
                        fit: _previewUrl[index] == url
                            ? BoxFit.contain
                            : BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ));
                    }),
                  );
                },
                itemCount: _previewUrl.length,
                pagination: const SwiperPagination(),
                control: const SwiperControl(
                  color: bl2,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_tourist['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_outline)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Alamat : ",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Text(_tourist['location']),
                    ],
                  ),
                  const Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Deskripsi : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Text(
                        _tourist['description'],
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
