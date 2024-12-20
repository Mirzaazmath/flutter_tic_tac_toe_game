import 'package:flutter/material.dart';

/// Here we are creating a custom class to handle color theming
class ColorTheme {
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;

  ColorTheme(
      {required this.primaryColor,
      required this.primaryColorLight,
      required this.primaryColorDark});
}

List<ColorTheme> themeList = [
  ColorTheme(
      primaryColor: const Color(0xff1d3557),
      primaryColorLight: const Color(0xFFf1faee),
      primaryColorDark: const Color(0xffe63946)),

  ColorTheme(
      primaryColor: const Color(0xffFF4b4b),
      primaryColorLight: const Color(0xffffca27),
      primaryColorDark: const Color(0xff4169e8)),
  ColorTheme(
      primaryColor: const Color(0xff000000),
      primaryColorLight: const Color(0xFFffffff),
      primaryColorDark: const Color(0xff8d99ae)),
  ColorTheme(
      primaryColor: const Color(0xff472d30),
      primaryColorLight: const Color(0xFFfff3b0),
      primaryColorDark: const Color(0xff335c67)),
  ColorTheme(
      primaryColor: const Color(0xff6bf178),
      primaryColorLight: const Color(0xFFffffff),
      primaryColorDark: const Color(0xff35a7ff)),
  ColorTheme(
      primaryColor: const Color(0xff0d1321),
      primaryColorLight: const Color(0xFFf0ebd8),
      primaryColorDark: const Color(0xff748cab)),
];
