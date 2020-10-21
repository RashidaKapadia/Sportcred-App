import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  int defaultIndex = 0;
  @override
  State<NavBar> createState() {
    return NavBarState();
  }

  NavBar(int startingIndex) {
    defaultIndex = startingIndex;
  }
}

class NavBarState extends State<NavBar> {
  List<BottomNavigationBarItem> items;
  final tabs = [
    Center(child: Text("Home")),
    Center(child: Text("Search")),
    Center(child: Text("Profile")),
    Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.black45,
      // type: BottomNavigationBarType.fixed,
      type: BottomNavigationBarType.shifting,
      iconSize: 20,
      //selectedFontSize: 25,
      backgroundColor: Colors.blue,
      currentIndex: widget.defaultIndex,
      selectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
          backgroundColor: Colors.lightGreen,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
          backgroundColor: Colors.green,
        ),
      ],
      onTap: (index) {
        setState(() {
          if (index == 0) {
            Navigator.of(context).pushNamed("/homepage");
          } else if (index == 1) {
            // Navigator stuff
          } else if (index == 2) {
            Navigator.of(context).pushNamed("/profile");
          } else if (index == 3) {
            //Navigator.of(context).pushNamed("/settings");
          }
        });
      },
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
