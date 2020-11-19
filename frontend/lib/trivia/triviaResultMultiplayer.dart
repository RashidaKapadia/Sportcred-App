// Reference:
// flutter-quizstar. https://github.com/desi-programmer/flutter-quizstar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/requests/trivia.dart';
import 'dart:async';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';

class TriviaResultMulti extends StatefulWidget {
  String username;
  int gameId;
  TriviaResultMulti({@required this.username, @required this.gameId});

  @override
  State<StatefulWidget> createState() =>
      _TriviaResultMultiState(username: username, gameId: gameId);
}

// Get questions, then call the actually quiz page after questions are recieved
class _TriviaResultMultiState extends State<TriviaResultMulti> {
  String username = "";
  int gameId;
  _TriviaResultMultiState({@required this.username, @required this.gameId});
  Future<List<TriviaQuestion>> _futureTriviaQuestions;

  @override
  void initState() {
    super.initState();
    setState(() {
      // _futureTriviaQuestions = getQuestions(category);
    });
  }

  Widget loadTrivia() {
    return FutureBuilder<List<TriviaQuestion>>(
      future: _futureTriviaQuestions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PageBody(
            username: username,
          );
        } else {
          return margin10(CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => loadTrivia();
}

// Page with changing questions
class PageBody extends StatefulWidget {
  String username = "";
  PageBody({Key key, @required this.username}) : super(key: key);

  @override
  _PageBodyState createState() => _PageBodyState(
        username: username,
      );
}

class _PageBodyState extends State<PageBody> with TickerProviderStateMixin {
  String username = "";
  _PageBodyState({
    @required this.username,
  });

  @override
  void initState() {
    super.initState();
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
        child: Table(
      border: TableBorder.all(
          color: Colors.black26, width: 1, style: BorderStyle.none),
      children: [
        TableRow(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey[200], width: 1)),
            ),
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Text("Hi " + username),
              )
            ]),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.brown[300]),
        // bottomNavigationBar: NavBar(1),
        body: body(context));
  }
}
