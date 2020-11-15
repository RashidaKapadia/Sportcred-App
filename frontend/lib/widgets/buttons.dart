import 'package:flutter/material.dart';

Widget greyButtonFullWidth(Function onPressed, Widget body) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    width: double.infinity,
    child: RaisedButton(
      highlightElevation: 25.0,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: body,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      onPressed: onPressed,
    ),
  );
}
