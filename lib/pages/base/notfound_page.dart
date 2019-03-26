import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.red,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Page not found :-(",
            style: new TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          new IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 70.0,
              onPressed: () {
                Navigator.of(context).pop(false);
//                Navigator.of(context).pushAndRemoveUntil(
//                    new MaterialPageRoute(
//                        builder: (BuildContext context) => new LandingPage()),
//                    (Route route) => route == null);
              })
        ],
      ),
    );
  }
}
