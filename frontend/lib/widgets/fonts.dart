import 'package:flutter/material.dart';

Widget bold(String text) {
  return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ));
}

Widget heading(String text, {double size, color}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
    child: Text(text,
        style: TextStyle(
          fontSize: size,
          color: (color == null) ? Colors.black : color,
          fontWeight: FontWeight.bold,
        )),
  );
}

Widget h1(String text) {
  return heading(text, size: 30.0);
}

Widget h2(String text) {
  return heading(text, size: 25.0);
}

Widget h3(String text) {
  return heading(text, size: 20.0);
}

Widget superLargeHeading(String text, {color}) {
  return Text(
    'Result',
    style: TextStyle(
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        color: (color != null) ? color : Colors.black),
  );
}

Widget largeButtonTextGrey(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.blueGrey[800], fontSize: 20),
    textAlign: TextAlign.center,
  );
}
