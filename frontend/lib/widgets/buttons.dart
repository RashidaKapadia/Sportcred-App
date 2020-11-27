import 'package:flutter/material.dart';

Widget orangeButtonLarge({String text, Function onPressed}) {
  String _text = (text != null) ? text : "";
  Function _onPressed = (onPressed != null) ? onPressed : () {};

  return Container(
      width: 400,
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RaisedButton(
        textColor: Colors.white,
        color: Color(0xFFFF8F00),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0)),
        child: Text(
          _text,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: _onPressed,
      ));
}

Widget plainButton(
    {String text, fontColor, backgroundColor, onPressed, width}) {
  return Container(
      width: (width != null) ? width : null,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        color: (backgroundColor != null) ? backgroundColor : Colors.black12,
        child: Text(
          text,
          style: TextStyle(
              color: (fontColor != null) ? fontColor : Colors.black,
              fontSize: 14),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(12.0)),
        onPressed: onPressed,
      ));
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

Widget backButton(BuildContext context){
   return BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage"));
}
