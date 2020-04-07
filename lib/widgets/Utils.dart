import 'package:flutter/material.dart';

getAppBar(String tittle) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: 0,
    title: Text(
      tittle,
      style: TextStyle(
          color: Colors.white, fontFamily: 'Lato', fontWeight: FontWeight.w600),
    ),
  );
}

Widget getAvatar(final String title) {
  final RegExp re = RegExp(r'([a-z|A-Z])');
  if (title != null && title.isNotEmpty) {
    if (re.hasMatch(title.trim()[0])) {
      // isAlphabets
      return Text(title.trim()[0],
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ));
    }
  }
  return Icon(
    Icons.person,
    color: Colors.white,
    size: 24,
  );
}
