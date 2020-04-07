import 'dart:math';

import 'package:flutter/material.dart';

class MatColor {
  static const Color primaryDarkColor = const Color(0xFF512DA8);
  static const Color primaryLightColor = const Color(0xFFD1C4E9);
  static const Color primaryLightColor2 = const Color(0xFFF1EDF8);
  static const Color primaryLightColor3 = const Color(0xFFF5F3FA);
  static const Color primaryColor = const Color(0xFF673AB7);
  static const Color accentColor = const Color(0xFF03A9F4);
  static const Color textColor = const Color(0xFFFFFFFF);
  static const Color primaryTextColor = const Color(0xFF212121);
  static const Color secondaryTextColor = const Color(0xFF757575);
  static const Color dividerColor = const Color(0xFFBDBDBD);
  static const Color lightGreyColor = const Color(0xe7e7e7);
}

class RandomColor {

  static List<int> colors = [
    0xFF2195F2,
    0xffF34336,
    0xFFFEC007,
    0xffE81E63,
    0xFF03A8F3,
    0xff9B27AF,
    0xFFCCDB39,
    0xFF673AB6,
    0xFF3F51B4,
    0xFFFE5722,
    0xFF00BBD3,
    0xFF009587,
    0xFF4CAE50,
    0xFF8AC24A,
    0xFF785548,
    0xFFFE9700,
    0xFF607C8A,
    0xffF44336,
    0xff9C27B0,
    0xffE91E63,
    0xff673AB7,
    0xff3F51B5,
    0xff2196F3,
    0xff03A9F4,
    0xff00BCD4,
    0xff009688,
    0xff4CAF50,
    0xff8BC34A,
    0xffFF9800,
    0xffFF5722,
    0xff795548,
    0xff9E9E9E,
    0xff607D8B
  ];

  static int _pIdx = -1;

  static Color getRandomColor() {
    Random random = new Random();
    int idx = random.nextInt(colors.length);

    while (_pIdx == idx) {
      idx = random.nextInt(colors.length);
    }

    _pIdx = idx;
    return Color(colors[idx]);
  }
}
