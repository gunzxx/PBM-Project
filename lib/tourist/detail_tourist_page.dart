import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitThreeBounce;
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter/material.dart';
import '../auth/login.dart';
import '../components/comment.dart';
import '../mylib/auth.dart';
import '../mylib/bookmark.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../components/back_button.dart';
import '../image/full.dart';
import '../model/bookmark_model.dart';
import '../mylib/color.dart';
import '../mylib/jwt.dart';
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
  final FocusNode _editCommentNode = FocusNode();
  final TextEditingController _editCommentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isCommentValid = false;

  late Future<List<dynamic>> _futureGetComment;

  _deleteComment(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: BeveledRectangleBorder(),
            clipBehavior: Clip.hardEdge,
            content: Text("Hapus ulasan?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tidak")),
              TextButton(onPressed: () {}, child: Text("Iya")),
            ],
          );
        });
  }

  _editComment(int id) async {
    final jwt = await getToken();
    if (!context.mounted) return;
    Navigator.pop(context);
    final response = await http.put(
      Uri.parse('https://paa.gunzxx.my.id/api/review'),
      // body: jsonEncode({
      //   "text": _editCommentController.text,
      //   "tourist_id": id.toString(),
      // }),
      body: {
        "text": _editCommentController.text,
        "tourist_id": id.toString(),
      },
      headers: {
        "Authorization": "Bearer $jwt",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _futureGetComment = _getComment();
      });
      if (!context.mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Komentar berhasil diedit"),
            );
          });
    }

    if (response.statusCode != 200) {
      setState(() {
        _futureGetComment = _getComment();
      });
      showDialog(
          context: context,
          builder: (context2) {
            return AlertDialog(
              content: Text(jsonDecode(response.body)['message']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                    child: Text("Oke", style: TextStyle(color: b1)))
              ],
            );
          });
    }
  }

  _showCommand(data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: BeveledRectangleBorder(),
            clipBehavior: Clip.hardEdge,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _editCommentController.text = data['text'];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        maxLength: 200,
                                        controller: _editCommentController,
                                        focusNode: _editCommentNode,
                                        decoration: InputDecoration(
                                          hintText: 'Edit ulasan...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        _editCommentNode.unfocus();
                                        _editComment(data['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteComment(data['id']);
                  },
                  child: Text('Hapus'),
                ),
              ],
            ),
          );
        });
  }

  Future<List<dynamic>> _getComment() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return Future.error('Tidak ada koneksi internet.');
    }

    try {
      final response = await http.get(
          Uri.parse('https://paa.gunzxx.my.id/api/tourist/${_tourist.id}'));
      final data = jsonDecode(response.body)['data']['review'];
      if (data.isEmpty) {
        return [];
      }
      return data;
    } on Error catch (_) {
      return Future.error("error");
    }
  }

  _DetailTouristPageState(this._tourist);

  void _sendComment() async {
    _commentNode.unfocus();
    if (_isCommentValid) {
      final jwt = await getToken();
      final String id = _tourist.id.toString();
      final response = await http.post(
        Uri.parse('https://paa.gunzxx.my.id/api/review'),
        headers: {
          "Authorization": "Bearer $jwt",
        },
        body: {
          "text": _commentController.text,
          "tourist_id": id,
        },
      );

      _commentController.text = '';
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        saveToken(token);

        setState(() {
          _futureGetComment = _getComment();
        });
      } else if (response.statusCode == 401) {
        setState(() {
          setLogout();
        });
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      } else {
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(jsonDecode(response.body)['message']),
            );
          },
        );
      }
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

    setState(() {
      _futureGetComment = _getComment();
    });
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
              child: Column(
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          const Text("Ulasan",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 15),
                          FutureBuilder<List<dynamic>>(
                            future: _futureGetComment,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 20,
                                );
                              } else if (snapshot.hasError) {
                                return Text("Terjadi kesalahan.");
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                if (data.isEmpty) {
                                  return const Text("Tidak ada ulasan.");
                                }
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: false,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final user = data[index]['user'];
                                      return GestureDetector(
                                        onLongPress: () async {
                                          final String tokenJWT =
                                              await getToken() ?? '';
                                          final authUser = parseJwt(tokenJWT);
                                          if (authUser['id'] != null) {
                                            if (user['id'] == authUser['id']) {
                                              _showCommand(data[index]);
                                            }
                                          }
                                        },
                                        child: CommentWidget(
                                          username: user['name'],
                                          comment: data[index]['text'],
                                          avatarUrl: user['media'][0]
                                              ['original_url'],
                                          index: index,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const Text("Tidak ada ulasan.");
                            },
                          ),
                        ],
                      ),
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
                                maxLength: 200,
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
}
