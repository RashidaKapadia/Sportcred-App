import 'dart:html';
import 'package:flutter/material.dart';
import './navbar.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();

  Container displayComments() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Comments", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {}),
            ],
            backgroundColor: Colors.black),
        bottomNavigationBar: NavBar(1),
        body: Column(children: <Widget>[
          Expanded(child: displayComments()
              //     child: ListView(
              //   children: [
              //     ListTile(
              //       title: Text('Primary text'),
              //       leading: Icon(Icons.label),
              //       trailing: Text('Metadata'),
              //     ),
              //   ],
              // )
              ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write comment ...",
              ),
              onChanged: (value) {
                // add/display commet
                // setState(() {
                // });
              },
            ),
            trailing:
                OutlineButton(borderSide: BorderSide.none, child: Text("Post")),
          )
        ]));
  }
}
