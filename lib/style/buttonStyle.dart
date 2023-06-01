import 'package:flutter/material.dart';

import '../mylib/color.dart';

ButtonStyle button1() {
  return ButtonStyle(
    alignment: Alignment.center,
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    ),
    backgroundColor: MaterialStateProperty.all(b1),
    elevation: MaterialStateProperty.all(3),
  );
}
