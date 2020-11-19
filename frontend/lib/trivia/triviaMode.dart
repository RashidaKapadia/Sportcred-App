import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:frontend/requests/user.dart';
import '../navbar.dart';
import 'triviaOngoing.dart';

class TriviaModePage extends StatefulWidget {
  String category;
  TriviaModePage(this.category);

  @override
  _TriviaHomePageState createState() => _TriviaHomePageState(category);
}

class _TriviaHomePageState extends State<TriviaModePage> {
  String category;
  _TriviaHomePageState(this.category);
  Future<UserDailyPlays> _futureUserTriviaPlays;
  String username;

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  void loadUsername() {
    FlutterSession().get('username').then((value) {
      this.setState(() {
        username = value.toString();
        _futureUserTriviaPlays = getDailyPlays(username, 'triviaMulti');
      });
    });
  }

  goToTrivia() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            TriviaOngoing(category: category, opponent: null)));
  }

  selectUser() {
    Navigator.of(context).pushNamed('/trivia/searchOpponent');
  }

  Widget loadTrivia({String text, Function onPressed, String activityID}) {
    String _text = (text != null) ? text : "";
    Function _onPressed = (onPressed != null) ? onPressed : () {};
    return (activityID != null)
        ? FutureBuilder<UserDailyPlays>(
            future: _futureUserTriviaPlays,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return gameModeTile(
                    text: _text,
                    onPressed: _onPressed,
                    avaliable: snapshot.data.available,
                    gamesLeft: snapshot.data.gamesLeft);
              } else {
                return gameModeTile(text: _text, onPressed: _onPressed);
              }
            },
          )
        : gameModeTile(text: _text, onPressed: _onPressed);
  }

  Widget gameModeTile(
      {@required String text,
      @required Function onPressed,
      bool avaliable,
      int gamesLeft}) {
    //
    Function _onPRessed = onPressed;
    Color fontColor = Colors.black;
    Color bgcolor = Color.fromRGBO(220, 180, 100, 0.35);

    Color grey = Colors.black38;

    if (avaliable == false) {
      _onPRessed = () {};
      fontColor = Colors.grey;
      bgcolor = grey;
    }

    return ButtonTheme(
        height: MediaQuery.of(context).size.height / 3,
        child: RaisedButton(
            padding: EdgeInsets.all(0),
            color: bgcolor,
            onPressed: _onPRessed,
            child: Container(
              padding: EdgeInsets.all(10),
              color: grey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(text.toUpperCase(),
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold)),
                    Text(
                        "Games Left: " +
                            ((gamesLeft == null)
                                ? "Infinite"
                                : gamesLeft.toString()),
                        style: TextStyle(color: fontColor)),
                  ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/trivia/category")),
            title: Text("Trivia", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.deepOrange),
        bottomNavigationBar: NavBar(0),
        body: (Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              loadTrivia(onPressed: () => goToTrivia(), text: "Solo Trivia"),
              loadTrivia(
                  onPressed: () => selectUser(),
                  text: "1 - 1 Trivia",
                  activityID: "triviaMulti"),
            ],
          ),
        )));
  }
}
