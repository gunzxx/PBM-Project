import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter/material.dart';
import '../mylib/bookmark.dart';
import 'package:provider/provider.dart';

import '../components/back_button.dart';
import '../image/full.dart';
import '../model/bookmark_model.dart';
import '../mylib/color.dart';
import '../state/bookmark_state.dart';
import 'tourist_map.dart';

class DetailTouristPage extends StatefulWidget {
  final BookmarkModel _tourist;
  const DetailTouristPage(this._tourist, {super.key});

  @override
  State<DetailTouristPage> createState() => _DetailTouristPageState(_tourist);
}

class _DetailTouristPageState extends State<DetailTouristPage> {
  final BookmarkModel _tourist;
  final List<dynamic> _previewUrl = [];
  int _index = 0;
  final url = "https://paa.gunzxx.my.id/img/tourist/default.png";
  final FocusNode _commentNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isCommentValid = false;

  _DetailTouristPageState(this._tourist);

  void _sendComment() {
    if (_isCommentValid) {
      print(_commentController.text);
    }
  }

  @override
  initState() {
    super.initState();
    final thumb = _tourist.thumb;
    _previewUrl.add(thumb);

    final List preview = _tourist.previewUrl;

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
      body: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                _commentNode.unfocus();
              },
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenImageScreen(
                              imageUrls: _previewUrl, currentIndex: _index),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 220,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              _previewUrl[index],
                              fit: _previewUrl[index] == url
                                  ? BoxFit.contain
                                  : BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                    child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ));
                              },
                            ),
                          );
                        },
                        itemCount: _previewUrl.length,
                        onIndexChanged: (value) {
                          setState(() {
                            _index = value;
                          });
                        },
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(
                          color: bl2,
                        ),
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
                            Text(_tourist.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TouristMap(_tourist)));
                                  },
                                  icon: const Icon(Icons.map),
                                ),
                                Consumer<BookmarkState>(
                                    builder: (_, bookmarkNotifier, __) {
                                  return IconButton(
                                    onPressed: bookmarkNotifier
                                            .check(_tourist.id)
                                        ? () async {
                                            await removeBookmark(_tourist.id);
                                            bookmarkNotifier.bookmarks =
                                                await getBookmarks();
                                          }
                                        : () async {
                                            await addBookmark(_tourist);
                                            bookmarkNotifier.bookmarks =
                                                await getBookmarks();
                                          },
                                    icon: bookmarkNotifier.check(_tourist.id)
                                        ? const Icon(Icons.bookmark)
                                        : const Icon(Icons.bookmark_outline),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Alamat : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Text(_tourist.location),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: ExpansionTile(
                            childrenPadding: const EdgeInsets.only(bottom: 10),
                            initiallyExpanded: true,
                            expandedAlignment: Alignment.centerLeft,
                            title: const Text("Deskripsi : ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            children: [
                              Text(
                                _tourist.description,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              print("OKE");
                            },
                            child: const Text("Ulasan (45)",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const SizedBox(height: 15),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                              Text('Halo guys'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: w1,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _commentController,
                                focusNode: _commentNode,
                                decoration: const InputDecoration(
                                  hintText: 'Tambahkan ulasan...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _isCommentValid = value.trim().isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _isCommentValid ? _sendComment : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tombolKembali(context),
          ],
        ),
      ),
    );
  }

  // void _addBookmark() async {
  //   await addBookmark(_tourist);
  //   setState(() {
  //     _isBookmark = true;
  //   });
  // }

  // void _removeBookmark() async {
  //   await removeBookmark(_tourist['id'].runtimeType == int
  //       ? _tourist['id']
  //       : int.parse(_tourist['id']));

  //   setState(() {
  //     _isBookmark = false;
  //   });
  // }
}
