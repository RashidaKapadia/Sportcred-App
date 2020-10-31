import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// Form field Validators
final requiredValidator = RequiredValidator(errorText: 'Required');

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Required'),
  MinLengthValidator(8, errorText: 'Password must have at least 8 characters'),
  //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'Passwords must have at least one special character')
]);

final matchedValidator = (value1, value2) => MatchValidator(
      errorText: 'Passwords do not match',
    ).validateMatch(value1, value2);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Required'),
  EmailValidator(errorText: "Enter a valid email address."),
]);

InputDecoration inputDecorator(String label, Icon icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: icon,
  );
}

Text txtField(String value) {
  return Text(value, style: TextStyle(fontSize: 17, color: Colors.black54));
}

String checkInput(String value, String field) {
  if (value.isEmpty) {
    return "Please enter your $field!";
  }
  return null;
}

void errorPopup(BuildContext context, String errorMsg) {
  showCupertinoDialog(
    context: context,
    builder: (alertContext) {
      return CupertinoAlertDialog(
        title: Text('ERROR', style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text(errorMsg),
        actions: [
          CupertinoDialogAction(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              })
        ],
      );
    },
  );
}
