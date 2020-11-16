import 'package:flutter/material.dart';

Widget plainButton({String text, fontColor, backgroundColor, onPressed}) {
  return RaisedButton(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    highlightElevation: 20.0,
    color: (backgroundColor != null)
        ? backgroundColor
        : Color.fromRGBO(180, 180, 220, 1),
    child: Text(
      'Play!',
      style: TextStyle(
          color: (fontColor != null) ? fontColor : Colors.black, fontSize: 20),
      textAlign: TextAlign.center,
    ),
    shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
    onPressed: onPressed,
  );
}

Widget greyButtonFullWidth(Function onPressed, Widget body) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    width: double.infinity,
    child: RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: body,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12.0)),
      onPressed: onPressed,
    ),
  );
}
