import 'package:flutter/material.dart';

import '../mylib/color.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
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
    );
  }
}
