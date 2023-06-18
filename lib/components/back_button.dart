import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        Positioned,
        IconButton,
        Icon,
        Icons,
        Navigator,
        Shadow;

import '../mylib/color.dart' show bl1, w1;

Widget tombolKembali(BuildContext context) {
  return Positioned(
    top: 10,
    left: 10,
    // width: double.maxFinite,
    child: IconButton(
      icon: const Icon(Icons.arrow_back, color: w1, shadows: [
        Shadow(
          blurRadius: 2,
          color: bl1,
        )
      ]),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
