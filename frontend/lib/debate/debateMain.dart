import 'package:flutter/material.dart';
import '../navbar.dart';

class Debate extends StatefulWidget {
  @override
  _Debate createState() => _Debate();
}

class _Debate extends State<Debate> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed("/homepage")),
        title: Text('Debate'),
        backgroundColor: Colors.greenAccent,
      ),
      bottomNavigationBar: NavBar(0),
      body: Column(children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/debate/dailyQuestion'),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.help_center_outlined),
                  title: Text('Daily Debate Question'),
                  subtitle: Text('Can you answer today\'s question?'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed('/debateCurrentResponses'),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.stars),
                  title: Text('Rate a Debate'),
                  subtitle: Text('Who said it best?'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed('/debatePreviousResults'),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.announcement_outlined),
                  title: Text('Results'),
                  subtitle: Text('View yesterday\'s results'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed('/debateCurrentResponses'),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.record_voice_over),
                  title: Text('Ongoing Debates for other Tiers'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed('/debatePreviousQuestions'),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.watch_later),
                  title: Text('Past Debates'),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
