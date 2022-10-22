import 'package:flutter/material.dart';

import 'clr.dart';

class txt {
  static const textScaleFactor = 1.0;

  static const textSizeLarge = 40 * textScaleFactor;
  static const textSizeMedium = 22 * textScaleFactor;
  static const textSizeNormal = 18 * textScaleFactor;
  static const textSizeSmall = 16 * textScaleFactor;

  static const large = TextStyle(
    color: clr.dark,
    fontSize: textSizeLarge,
    fontWeight: FontWeight.bold,
  );

  static const medium = TextStyle(
    color: clr.dark,
    fontSize: textSizeMedium,
    fontWeight: FontWeight.bold,
  );

  static const normal = TextStyle(
    color: clr.dark,
    fontSize: textSizeNormal,
    fontWeight: FontWeight.bold,
  );

  static const small = TextStyle(
    color: clr.dark,
    fontSize: textSizeSmall,
    fontWeight: FontWeight.bold,
  );

  static final formFieldLabel = TextStyle(
    color: clr.darken(clr.grey, 35),
    fontSize: textSizeNormal * 0.90,
    fontWeight: FontWeight.normal,
  );

  static const button = TextStyle(
    color: clr.light,
    fontSize: textSizeNormal * 1.20,
    fontWeight: FontWeight.bold,
  );

  static const textButton = TextStyle(
    color: clr.primary,
    fontSize: textSizeNormal,
    fontWeight: FontWeight.bold,
  );
}
