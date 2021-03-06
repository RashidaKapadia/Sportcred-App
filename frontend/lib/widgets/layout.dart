import 'package:flutter/material.dart';

Widget logoBanner() {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: 70, vertical: 45),
      child: Image.asset('assets/Logo.png'));
}

Widget headerBanner(Widget title) {
  return Container(
      width: double.infinity,
      color: Colors.blueGrey[900],
      height: 150,
      padding: EdgeInsets.all(20.0),
      child: title);
}

// All margin

Widget margin20(Widget body) {
  return Container(margin: EdgeInsets.all(20), child: body);
}

Widget margin15(Widget body) {
  return Container(margin: EdgeInsets.all(15), child: body);
}

Widget margin10(Widget body) {
  return Container(margin: EdgeInsets.all(10), child: body);
}

Widget margin5(Widget body) {
  return Container(margin: EdgeInsets.all(5), child: body);
}

// Vertical margin defaults

Widget vmargin30(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 30), child: body);
}

Widget vmargin25(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 25), child: body);
}

Widget vmargin20(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 20), child: body);
}

Widget vmargin15(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 15), child: body);
}

Widget vmargin10(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 10), child: body);
}

Widget vmargin5(Widget body) {
  return Container(margin: EdgeInsets.symmetric(vertical: 5), child: body);
}

// Horizontal margin defaults

Widget hmargin30(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 30), child: body);
}

Widget hmargin25(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 25), child: body);
}

Widget hmargin20(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 20), child: body);
}

Widget hmargin15(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 15), child: body);
}

Widget hmargin10(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 10), child: body);
}

Widget hmargin5(Widget body) {
  return Container(margin: EdgeInsets.symmetric(horizontal: 5), child: body);
}
