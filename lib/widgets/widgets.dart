import 'package:flutter/material.dart';

import '../shared/clr.dart';
import '../shared/layout.dart';
import '../shared/txt.dart';

final textInputDecoration = InputDecoration(
  labelStyle: txt.formFieldLabel,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: clr.primary, width: layout.borderWidth),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: clr.primary, width: layout.borderWidth),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: clr.error, width: layout.borderWidth),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: clr.error, width: layout.borderWidth),
  ),
);

void nextPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}

void nextPageReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => page)));
}

void showSnackBar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: txt.small.copyWith(color: clr.light),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
    ),
  );
}
