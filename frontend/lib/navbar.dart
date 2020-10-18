import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() {
    return NavBarState();
  }
}

class NavBarState extends State<NavBar> {
  int _currentIndex = 0;
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
      unselectedItemColor: Colors.black,
      //type: BottomNavigationBarType.fixed,
      iconSize: 20,
      //selectedFontSize: 25,
      backgroundColor: Colors.blue,
      currentIndex: _currentIndex,
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
          _currentIndex = index;
        });
      },
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
