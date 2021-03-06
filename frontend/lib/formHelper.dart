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
        title: Text(
          'ERROR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

void popUp(BuildContext context, String title, String msg) {
  showCupertinoDialog(
    context: context,
    builder: (alertContext) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(msg),
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

void checkStatus(BuildContext context, Future status, String nextPage) async {
  await status.then((snapshot) {
    print('YAYY');
    print(snapshot.message);
    if (snapshot.success) {
      Navigator.of(context).pushNamed(nextPage);
    } else {
      errorPopup(context, snapshot.message);
    }
  });
}

Widget getStatus(BuildContext context, Future status) {
  return FutureBuilder(
    future: status,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data.message);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      } else {
        return Container(
            alignment: Alignment.center,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ));
      }
    },
  );
}
