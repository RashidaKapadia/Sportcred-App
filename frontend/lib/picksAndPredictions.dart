import 'package:flutter/material.dart';
import 'package:frontend/widgets/fonts.dart';
import 'package:frontend/widgets/layout.dart';
import './navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'games_data.dart';

class PicksAndPredictions extends StatefulWidget {
  @override
  _PicksAndPredictions createState() => _PicksAndPredictions();
}

List players = [
  "Warren",
  "Josh",
  "Spence",
  "JB",
  "Arman",
  "Philly",
  "Marshall",
  "Bryse",
  "Yacob",
  "G-Sam",
  "Boon",
  "Jordan"
];
String dropdownValue = 'WEEK 1';
int totalGames = 7;

class _PicksAndPredictions extends State<PicksAndPredictions> {
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     data = parseJson();
  //     print(game);
  //     data.then((game) => game = jsonData[0]['WEEK 1'][0]['Games']);
  //     print(game);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: brightPeachOrange,
              onPressed: () => Navigator.of(context).pushNamed("/homepage")),
          title: Text('Past Season Picks',
              style: TextStyle(color: brightPeachOrange)),
          backgroundColor: grey,
        ),
        bottomNavigationBar: NavBar(0),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              dropdown(context),
              SizedBox(height: 10),
              _renderWeekWidget(),
              SizedBox(height: 30),
              Text(
                'Total Games: ' + totalGames.toString(),
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ])));
  }

  Widget _renderWeekWidget() {
    switch (dropdownValue) {
      case "WEEK 1":
        {
          return gamesCarousel(context, Games.week1_games);
        }
      case "WEEK 2":
        {
          print("IN HEERE");
          return gamesCarousel(context, Games.week2_games);
        }
      case "WEEK 3":
        {
          return gamesCarousel(context, Games.week3_games);
        }
      case "WEEK 4":
        {
          return gamesCarousel(context, Games.week4_games);
        }
      case "WEEK 5":
        {
          return gamesCarousel(context, Games.week5_games);
        }
      case "WEEK 6":
        {
          return gamesCarousel(context, Games.week6_games);
        }
      case "WEEK 7":
        {
          return gamesCarousel(context, Games.week7_games);
        }
      case "WEEK 8":
        {
          return gamesCarousel(context, Games.week8_games);
        }
      case "WEEK 9":
        {
          return gamesCarousel(context, Games.week9_games);
        }
      case "WEEK 10":
        {
          return gamesCarousel(context, Games.week10_games);
        }
      case "WEEK 11":
        {
          return gamesCarousel(context, Games.week11_games);
        }
    }
  }

  Widget dropdown(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        'WEEK 1',
        'WEEK 2',
        'WEEK 3',
        'WEEK 4',
        'WEEK 5',
        'WEEK 6',
        'WEEK 7',
        'WEEK 8',
        'WEEK 9',
        'WEEK 10',
        'WEEK 11'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String _displayPlayers(int index, dynamic i) {
    if (i[index] == '5') {
      return '\u{2705}';
    } else {
      return '\u{274C}';
    }
  }

  Widget gamesCarousel(BuildContext context, List week) {
    totalGames = week.length;
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        height: 450,
        autoPlay: false,
        enlargeCenterPage: true,
      ),
      items: week.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 20),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(children: [
                      Text(
                        '${i[0]}',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${i[1]}',
                        style: TextStyle(fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Winner: ${i[2]}',
                        style: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      for (int index = 3; index < 15; index++)
                        Text(
                            players[index - 3] +
                                ": " +
                                _displayPlayers(index, i),
                            style: TextStyle(fontSize: 16, height: 1.7),
                            textAlign: TextAlign.center)
                    ])));
          },
        );
      }).toList(),
    ));
  }
}
