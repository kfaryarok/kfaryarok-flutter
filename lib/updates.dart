/// This is an API class containing stuff related to parsing updates from
/// the server and representing the updates in code.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Update {
  final String text;
  final List<String> classes;

  Update({this.text, this.classes});
}

class UpdateWidget extends StatelessWidget {
  final Update update;
  final EdgeInsetsGeometry margin;
  UpdateWidget({@required this.update, this.margin});

  @override
  Widget build(BuildContext context) {
    return new Container(
      // Container holding the card
      margin: this.margin,
      child: new Card(
        // The card itself
        child: new Container(
          // Container inside the card
          margin: const EdgeInsets.all(12.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                child: new Text(
                  update.text,
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              new Container(
                margin: const EdgeInsetsDirectional.only(top: 8.0),
                child: new Text(
                  formatClassString(update.classes),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Update> getTestUpdates() => [
      new Update(text: "test1", classes: ["d2", "e3"]),
      new Update(text: "test2", classes: ["d3", "d2"]),
      new Update(text: "test3", classes: ["d4", "t3"]),
      new Update(text: "test4", classes: ["d2", "e3"]),
      new Update(text: "test5", classes: ["d3", "d1"]),
      new Update(
          text:
              "test6 but this is a very long test because I need to see what happens when there is a lot of text and a lot of classes",
          classes: [
            "d3",
            "d1",
            "e3",
            "a1",
            "b2",
            "c3",
            "f5",
            "g4",
            "p9",
            "d2",
            "o9",
            "o2",
            "h2",
            "i2"
          ]),
    ];

/// Function for creating a formatted string of the classes in the classes
/// list, comma separated. If the list contains the user's class, as defined
/// in userClass, it will be the first class in the formatted string, however
/// the list doesn't have to include the user's class, and will handle it fine.
/// This is a direct port of the UpdateHelper method in v2.
String formatClassString(List<String> classes, {String userClass: ""}) {
  StringBuffer classBuilder = new StringBuffer();

  // Used to know if a class was already added to the string, and if so
  // whether or not to append a comma
  bool appendComma = false;

  // Remove user's class from the list already to put it first in the string
  if (classes.contains(userClass)) {
    classBuilder.write(userClass);
    classes.remove(userClass);
    appendComma = true;
  }

  // Check if there are any classes left after removing the user's class
  if (classes.isNotEmpty) {
    // We've been told to add a comma (because of already adding the user's class)
    if (appendComma) {
      classBuilder.write(", ");
    }

    // Go through all of the left classes and append them to the string
    for (int i = 0; i < classes.length; i++) {
      String clazz = classes[i];
      classBuilder.write(clazz);

      // If the appended class isn't the last one, also append a comma
      if (i < classes.length - 1) {
        classBuilder.write(", ");
      }
    }
  }

  return classBuilder.toString();
}
