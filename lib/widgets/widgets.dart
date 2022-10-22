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
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: clr.primary, width: layout.borderWidth),
  ),
);

void nextPage(context, page) {
	Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}

void nextPageReplace(context, page) {
	Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => page)));
}
