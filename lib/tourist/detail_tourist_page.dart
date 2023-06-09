import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitThreeBounce;
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter/material.dart';
import '../auth/login.dart';
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

// final navigatorKey = GlobalKey<NavigatorState>();
final navigatorKey = GlobalKey();

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
            shape: const BeveledRectangleBorder(),
            clipBehavior: Clip.hardEdge,
            content: const Text("Hapus ulasan?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () async {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Icon(
                                Icons.error_outline,
                                size: 64.0,
                                color: Colors.red,
                              ),
                              content: const Text(
                                "Kesalahan jaringan.",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }

                    final jwt = await getToken();
                    final response = await http.delete(
                      Uri.parse('https://paa.gunzxx.my.id/api/review'),
                      body: {
                        "id": id.toString(),
                      },
                      headers: {
                        "Authorization": "Bearer $jwt",
                      },
                    );
                    if (response.statusCode == 200) {
                      setState(() {
                        _futureGetComment = _getComment();
                      });
                      Navigator.pop(context);
                      if (!context.mounted) return;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Icon(
                                Icons.check_circle,
                                size: 64.0,
                                color: Colors.green,
                              ),
                              content: const Text(
                                'Komentar berhasil dihapus.',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else {
                      // Navigator.pop(context);
                      if (!context.mounted) return;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Icon(
                                Icons.error_outline,
                                size: 64.0,
                                color: Colors.red,
                              ),
                              content: Text(
                                jsonDecode(response.body)['message'] ??
                                    "Data gagal dihapus",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: const Text("Iya")),
            ],
          );
        });
  }

  _editComment(data) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (!context.mounted) return;
      Navigator.pop(context);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Icon(
                Icons.error_outline,
                size: 64.0,
                color: Colors.red,
              ),
              content: const Text(
                "Kesalahan jaringan.",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          });
    }
    final jwt = await getToken();
    if (!context.mounted) return;
    Navigator.pop(context);
    final response = await http.put(
      Uri.parse('https://paa.gunzxx.my.id/api/review'),
      body: {
        "id": data['id'].toString(),
        "text": _editCommentController.text,
        "tourist_id": data['tourist_id'].toString(),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Icon(
                Icons.check_circle,
                size: 64.0,
                color: Colors.green,
              ),
              content: const Text(
                'Komentar berhasil diedit.',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    if (response.statusCode != 200) {
      setState(() {
        _futureGetComment = _getComment();
      });
      if (!context.mounted) return;
      showDialog(
          context: context,
          builder: (context2) {
            return AlertDialog(
              content: Text(jsonDecode(response.body)['message']),
            );
          });
    }
  }

  _showCommand(data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(0),
            clipBehavior: Clip.hardEdge,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
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
                                          decoration: const InputDecoration(
                                            hintText: 'Edit ulasan...',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () {
                                          _editCommentNode.unfocus();
                                          _editComment(data);
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
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: bl1),
                        SizedBox(width: 10),
                        Text(
                          'Edit',
                          style: TextStyle(color: bl1),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteComment(data['id']);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.delete, color: bl1),
                        SizedBox(width: 10),
                        Text(
                          'Hapus',
                          style: TextStyle(color: bl1),
                        ),
                      ],
                    ),
                  ),
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
            pageBuilder: (_, __, ___) => const Login(),
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
                            collapsedTextColor: bl1,
                            collapsedIconColor: bl1,
                            iconColor: bl1,
                            textColor: bl1,
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
                                return const Text("Terjadi kesalahan.");
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
                                      final avatarUrl = jsonEncode(
                                                  user['media']) ==
                                              "[]"
                                          ? "https://paa.gunzxx.my.id/img/profile/default.png"
                                          : user['media'][0]['original_url'];
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
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          color: index % 2 == 1
                                              ? const Color(0xFFF6F6F6)
                                              : Colors.white,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(avatarUrl),
                                                radius: 20.0,
                                                backgroundColor: Colors.white,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user['name'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(data[index]['text']),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  final String tokenJWT =
                                                      await getToken() ?? '';
                                                  final authUser =
                                                      parseJwt(tokenJWT);
                                                  if (authUser['id'] ==
                                                      user['id']) {
                                                    _showCommand(data[index]);
                                                  }
                                                },
                                                icon:
                                                    const Icon(Icons.more_vert),
                                              ),
                                            ],
                                          ),
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
                  const SizedBox(height: 110),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 110,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: w1,
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
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
