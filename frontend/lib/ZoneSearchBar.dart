import 'dart:html';
import 'package:flutter/material.dart';
import './navbar.dart';

class ZoneSearchBar extends StatefulWidget {
  @override
  _ZoneSearchBarState createState() => _ZoneSearchBarState();
}

class _ZoneSearchBarState extends State<ZoneSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("The Zone", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {}),
            ],
            backgroundColor: Colors.black),
        bottomNavigationBar: NavBar(1),
        body: Container());
  }
}
