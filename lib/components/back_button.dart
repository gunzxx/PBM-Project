import 'package:flutter/material.dart'
    show Widget, BuildContext, Positioned, IconButton, Icon, Icons, Navigator;

import '../mylib/color.dart' show w1;

Widget tombolKembali(BuildContext context) {
  return Positioned(
    top: 10,
    left: 10,
    child: IconButton(
      icon: const Icon(Icons.arrow_back, color: w1),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
