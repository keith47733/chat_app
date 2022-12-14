import 'package:flutter/material.dart';

class clr {
  static const primary = Colors.blue;

  static const light = Colors.white;
  static const grey1 = Colors.grey;
	static final grey2 = Colors.grey.shade700;
  static const dark = Colors.black;

  static final error = Colors.red.shade300;
  static final confirm = Colors.green.shade300;

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }

  static Color darken(Color baseColor, int percent) {
    var f = 1 - percent / 100;
    return Color.fromARGB(
        baseColor.alpha, (baseColor.red * f).round(), (baseColor.green * f).round(), (baseColor.blue * f).round());
  }

  static Color lighten(Color baseColor, int percent) {
    var p = percent / 100;
    return Color.fromARGB(baseColor.alpha, baseColor.red + ((255 - baseColor.red) * p).round(),
        baseColor.green + ((255 - baseColor.green) * p).round(), baseColor.blue + ((255 - baseColor.blue) * p).round());
  }
}
