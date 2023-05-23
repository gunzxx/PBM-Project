import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  const ListCard({super.key});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  List<dynamic> _data = [];

  Future<void> ambilData() async {
    final response =
        await http.get(Uri.parse('https://paa.gunzxx.my.id/api/tourist'));
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body)['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
