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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.white38,
      // type: BottomNavigationBarType.fixed,
      type: BottomNavigationBarType.shifting,
      iconSize: 20,
      //selectedFontSize: 25,
      backgroundColor: Colors.blue,
      currentIndex: widget.defaultIndex,
      selectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text('Notifications'),
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
          backgroundColor: Colors.blueGrey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
          backgroundColor: Colors.black,
        ),
      ],
      onTap: (index) {
        setState(() {
          if (index == 0) {
            Navigator.of(context).pushNamed("/homepage");
          } else if (index == 1) {
            Navigator.of(context).pushNamed("/notifications");
          } else if (index == 2) {
            Navigator.of(context).pushNamed("/profile");
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/settings");
          }
        });
      },
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
