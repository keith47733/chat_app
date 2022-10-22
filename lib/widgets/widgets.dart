import 'package:flutter/material.dart';

import '../shared/clr.dart';
import '../shared/layout.dart';
import '../shared/txt.dart';

final textInputDecoration = InputDecoration(
  labelStyle: txt.normal.copyWith(
    color: clr.darken(clr.grey, 40),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: clr.primaryColor, width: layout.borderWidth),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: clr.primaryColor, width: layout.borderWidth),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: clr.primaryColor, width: layout.borderWidth),
  ),
);
