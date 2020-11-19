import 'package:flutter/material.dart';

Color negateColor(int r, int g, int b, double rate) {
  Function nColor = (int value, double rate) => (value * rate).toInt();
  return Color.fromRGBO(nColor(r, rate), nColor(g, rate), nColor(r, rate), 1);
}

Widget tag(String text, int r, int g, int b) {
  // background color
  var c1 = Color.fromRGBO(r, g, b, 1);
  // text color
  var c2 = negateColor(r, g, b, 0.4);
  // border color
  var c3 = negateColor(r, g, b, 0.6);

  return Container(
      // color: (color != null) ? color : Colors.lightBlue,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: c3, width: 1.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: c1,
      ),
      child: Text(text.toUpperCase(),
          textAlign: TextAlign.center,
          style:
              TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: c2)));
}

Widget bold(String text) {
  return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ));
}

Widget heading(String text, {double size, color, textAlign}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
    child: Text(text,
        textAlign: (textAlign == null) ? TextAlign.left : textAlign,
        style: TextStyle(
          fontSize: size,
          color: (color == null) ? Colors.black : color,
          fontWeight: FontWeight.bold,
        )),
  );
}

Widget h1(String text, {color, textAlign}) {
  return heading(text, size: 30.0, color: color, textAlign: textAlign);
}

Widget h2(String text, {color, textAlign}) {
  return heading(text, size: 25.0, color: color, textAlign: textAlign);
}

Widget h3(String text, {color, textAlign}) {
  return heading(text, size: 20.0, color: color, textAlign: textAlign);
}

Widget h4(String text, {color, textAlign}) {
  return heading(text, size: 15.0, color: color, textAlign: textAlign);
}

Widget superLargeHeading(String text, {color}) {
  return Text(
    'Result',
    style: TextStyle(
        fontSize: 45.0,
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
