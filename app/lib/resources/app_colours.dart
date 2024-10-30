import 'package:flutter/material.dart';


class MyAppColours {

  // Opacities
  static const fullOpac = 0xFF000000;
  static const halfOpac = 0xFF000000;
  static const fullTransp = 0x00000000;

  // Tentative main colour palette
  static const mainOrange = Color(0xff9b09 + fullOpac);
  static const mainYellow = Color(0xf1d01f + fullOpac);
  static const mainGreen = Color(0x93d593 + fullOpac);
  static const mainBlue = Color(0x1c434e + fullOpac);
  static const mainBlack = Color(0x251e32 + fullOpac);

  static const linGradColours = [mainOrange, Colors.white];

  // New colours:
  static const primary = Color(0x87CEEB + fullOpac);
  static const secondary = Color(0xA7C7E7 + fullOpac); // 0xF0FFFF + fullOpac);
  static const accent1 = (0xFFFAA0 + fullOpac);
  static const accent2 = (0xC0C0C0 + fullOpac);

  // Gradient Palette:
  // Generated using: https://pinetools.com/monochromatic-colors-generator
  static const g1 = Color(0x000000 + fullOpac);
  static const g2 = Color(0x153350 + fullOpac);
  static const g3 = Color(0x2a66a1 + fullOpac);
  static const g4 = Color(0x5d99d4 + fullOpac);
  static const g5 = Color(0xaecce9 + fullOpac);
  static const g6 = Color(0xfffffe + fullOpac);
}