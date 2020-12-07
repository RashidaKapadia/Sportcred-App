import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// Colors
Color darkGrey = HexColor('#222629');
Color grey = HexColor('#474B4F');
Color greyNav = HexColor('#4F4A4F');
Color lightGrey = HexColor('#6B6E70');
Color lightGrey8 = HexColor('#7B7E80');
Color brightPeachOrange = HexColor('#ff803f');
Color darkOrange = HexColor('#da8a30');
Color orange = HexColor('#f2c230');
Color yellow = HexColor('#ffea00');
Color darkGreen = HexColor('#10b250');
Color green = HexColor('#4ee04e');
Color lightGreen = HexColor('#aaf050');
Color teal = HexColor('#008967');
Color red = HexColor('#ff5030');
Color neutralRed = HexColor('#ea5555');

Widget logoBanner() {
  return Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 45),
      child: Image.asset('assets/Logo.png'));
}

Widget headerBanner(Widget title, {int ht = 0}) {
  return Container(
      width: double.infinity,
      color: Colors.blueGrey[900],
      height: (ht == 0) ? 150 : ht,
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
