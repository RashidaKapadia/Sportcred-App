import 'package:flutter/material.dart';

InputDecoration inputDecorator(String label, Icon icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: icon,
  );
}

String checkInput(String value, String field) {
  if (value.isEmpty) {
    return "Please provide your $field!";
  }
  return null;
}

Text txtField(String value) {
  return Text(value, style: TextStyle(fontSize: 17, color: Colors.black54));
}
