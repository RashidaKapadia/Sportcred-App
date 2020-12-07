import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/layout.dart';
import '../navbar.dart';

class TriviaPickCategoryPage extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<TriviaPickCategoryPage> {
  // key is the cetgory of the trivia and ist value is its route
  // add more categories here
  final categories = {
    'General Sports': '/homepage',
    'Sports Scenarios': '/homepage',
    'Basketball': '/homepage'
  };

  // TODO: Temp hardcoding
  String chosenCategory = 'basketball';

  Widget build(BuildContext context) {
    //final appState = AppStateProvider.of<AppState>(context);
    Widget categoryCarousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 380.0,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: ['General Sports', 'Sports Scenarios', 'Basketball']
            .map((category) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                  color: darkOrange, borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 145, 0, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        // Category label
                        Text(
                          category,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        // Play button
                        margin10(plainButton(
                            text: "Play!",
                            fontColor: Colors.black87,
                            backgroundColor: orange,
                            onPressed: () => Navigator.of(context).pushNamed(
                                "/trivia/mode",
                                arguments: {category: chosenCategory}))),
                      ],
                    )),
              ),
            );
          });
        }).toList(),
      ),
    );

    return Scaffold(
        appBar: AppBar(
            leading: BackButton(
                color: orange,
                onPressed: () => Navigator.of(context).pushNamed("/homepage")),
            title: Text("Trivia", style: TextStyle(color: orange)),
            centerTitle: true,
            backgroundColor: grey),
        bottomNavigationBar: NavBar(0),
        body: Container(
            color: lightGrey,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              vmargin25(Text('Time to build that ACS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey[300]))),
              categoryCarousel,
            ])));
  }
}
