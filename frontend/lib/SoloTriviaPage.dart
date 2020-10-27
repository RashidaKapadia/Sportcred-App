import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './navbar.dart';

class SoloTriviaPage extends StatefulWidget {
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<SoloTriviaPage> {
  // key is the cetgory of the trivia and ist value is its route
  // add more categories here
  final categories = {
    'General Sports': '/homepage',
    'Sports Scenarios': '/homepage',
    'Basketball': '/homepage'
  };

  Future<Widget> DialogBox(BuildContext context, String val) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 250.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.lightGreen[800],
                  highlightColor: Colors.lightGreen[700],
                  elevation: 10.0,
                  highlightElevation: 25.0,
                  child: Text(
                    '1-1',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  //shape: RoundedRectangleBorder(
                  //borderRadius: new BorderRadius.circular(25.0)),
                  shape: StadiumBorder(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(categories[val]);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.lightGreen[800],
                  highlightColor: Colors.lightGreen[700],
                  elevation: 10.0,
                  highlightElevation: 25.0,
                  child: Text(
                    'Solo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  //shape: RoundedRectangleBorder(
                  //  borderRadius: new BorderRadius.circular(25.0)),
                  shape: StadiumBorder(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(categories[val]);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    Widget category_carousel = new Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
          autoPlay: false,
          enlargeCenterPage: true,
        ),
        // Items list will require to be updated here as well anytime new category is added
        items: ['General Sports', 'Sports Scenarios', 'Basketball'].map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.lightGreen[900],
                  borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 150.0,
                      ),
                      Text(
                        i,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      RaisedButton(
                        highlightElevation: 25.0,
                        color: Colors.lightGreen[800],
                        child: Text(
                          'Play!',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0)),
                        onPressed: () {
                          DialogBox(context, i);
                          //Navigator.of(context).pushNamed(categories[i]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
    return Scaffold(
        bottomNavigationBar: NavBar(0),
        body: Container(
            padding: EdgeInsets.all(10),
            child: ListView(children: [
              Text('Trivia',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text('Time to build that ACS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Color(0xFF9E9E9E))),
              SizedBox(
                height: 50.0,
              ),
              category_carousel,
            ])));
  }
}
