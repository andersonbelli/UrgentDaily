// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

abstract class AppColors {
  static const MaterialColor mainColor = MaterialColor(
    _mainPrimaryValue,
    <int, Color>{
      50: Color(0xFFf2faeb),
      100: Color(0xFFe6f5d6),
      200: Color(0xFFd9efc2),
      300: Color(0xFFbfe59a),
      400: Color(0xFFa6da71),
      500: _mainPrimaryColor,
      600: Color(0xFF80cb34),
      700: Color(0xFF73b62f),
      800: Color(0xFF598e25),
      900: Color(0xFF40651a),
    },
  );
  static const int _mainPrimaryValue = 0xFF8fd14f;
  static const Color _mainPrimaryColor = Color(_mainPrimaryValue);

  /// Main Colors
  static const GREEN = _mainPrimaryColor;
  static const RED = Color.fromRGBO(222, 62, 31, 1.0);

  static const CREAM = Color.fromRGBO(251, 247, 239, 1);
  static const DARK = Color.fromRGBO(26, 26, 26, 1);
  static const DARK_LIGHT = Color.fromRGBO(51, 51, 51, 1);
  static const GRAY = Color.fromRGBO(128, 128, 128, 1.0);
  static const BLUE = Color.fromRGBO(57, 169, 255, 1.0);

  /// Priority colors
  static const PINK = Color.fromRGBO(218, 0, 99, 1.0);
  static const PURPLE = Color.fromRGBO(101, 44, 179, 1.0);
  static const BLUE_LIGHT = Color.fromRGBO(45, 155, 240, 1.0);
  static const GRAY_LIGHT = Color.fromRGBO(206, 206, 206, 1.0);
}
