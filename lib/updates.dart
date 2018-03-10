import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// This is an API file containing stuff related to parsing updates from
/// the server and representing the updates in code.

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
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                child: new Text(
                  update.text,
                  style: const TextStyle(fontSize: 20.0),
                  textDirection: TextDirection.rtl,
                ),
              ),
              new Container(
                margin: const EdgeInsetsDirectional.only(top: 8.0),
                child: new Text(
                  formatClassString(update.classes),
                  style: const TextStyle(fontSize: 16.0),
                  textDirection: TextDirection.rtl,
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
      new Update(text: "עדכון 1", classes: ["ט2", "י3"]),
      new Update(text: "עדכון 2", classes: ["ט3", "ט2"]),
      new Update(text: "עדכון 3", classes: ["ט4", "ט3"]),
      new Update(text: "עדכון 4", classes: ["ט2", "י3"]),
      new Update(text: "עדכון 5", classes: ["ט3", "ט1"]),
      new Update(
          text:
              "עדכון 6 ארוך כי צריך לבדוק מה קורה כשיש עדכון מאוד ארוך ואיך הטקסט מופיע על המסך כשזה מופיע כי צריך שזה ירד למטה",
          classes: [
            "ט3",
            "ט1",
            "י3",
            "ח1",
            "יא2",
            "יב3",
            "י5",
            "י4",
            "י9",
            "ט2",
            "ז9",
            "ז2",
            "ח2",
            "יב2"
          ]),
    ];

/// Function for creating a formatted string of the classes in the classes
/// list, comma separated. If the list contains the user's class, as defined
/// in userClass, it will be the first class in the formatted string, however
/// the list doesn't have to include the user's class, and will handle it fine.
/// If the list is null/empty, it assumes that means it's a global update and
/// will return a fitting classes string for global updates.
/// This is a direct port of the UpdateHelper method in v2.
String formatClassString(List<String> classes, {String userClass: ""}) {
  // Classes are null/empty, return global update string
  if (classes == null || classes == []) {
    return "הודעה כללית";
  }

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

/// All-in-One function for fetching, decoding, parsing and filtering updates.
/// Gets the updates from the server, decodes the JSON, parses it to [Update]
/// objects and filters out updates that aren't relevant to the user.
/// If fetching data fails, it returns null.
Future<List<Update>> getUpdates() async {
  String data;
  try {
    data = await fetchFromServerAsync();
  } on Exception catch (e) {
    print(e);
    return null;
  }
  var decodedJson = decodeJson(data);
  List<Update> updates = parseJsonToUpdates(decodedJson);
  List<Update> filteredUpdates = filterUpdates(updates);
  return filteredUpdates;
}

/// Fetches the specified server URL.
/// Use this and not http.read() because this function supports Hebrew
/// characters, unlike http.read().
/// This function doesn't handle any exceptions!
/// TODO: Use an actual update server, and not a fake test server
Future<String> fetchFromServerAsync() async {
  var request =
      new Request("GET", Uri.parse("https://tbscdev.xyz/update.json"));
  StreamedResponse response = await request.send();
  return response.stream.bytesToString();
}

/// Use in conjunction with [fetchFromServerAsync] to decode the returned
/// JSON string.
/// Use this and not directly access [JSON] incase how decoding works ever
/// changes, so it'll be easy to update everywhere.
/// Returns a dynamic variable ([List], [Map], [Object]) based on the JSON.
dynamic decodeJson(String data) {
  return JSON.decode(data);
}

/// Parses the JSON to a list of [Update]s.
/// Starts parsing without checking according to the specification at
/// https://github.com/kfaryarok/kfaryarok-android/blob/master/JSONDATA.md.
List<Update> parseJsonToUpdates(dynamic decodedJson) {
  List<Update> result = <Update>[];

  List<dynamic> globalUpdates = decodedJson["global_updates"];
  List<dynamic> updates = decodedJson["updates"];

  // Go through the entries in the global_updates and updates JSON arrays and
  // add each to the parsed update objects list
  globalUpdates.forEach(
    (s) => result.add(new Update(text: s["text"])),
  );
  updates.forEach(
    (s) => result.add(new Update(text: s["text"], classes: s["classes"])),
  );

  return result;
}

/// Returns all updates that are global or affect the user's class.
List<Update> filterUpdates(List<Update> updates, {String userClass: ""}) {
  // No user class was given, therefore no filter can even be done.
  if (userClass == "") {
    return updates;
  }

  // Removes all updates that aren't global and don't include the user's class
  updates.removeWhere(
    (update) =>
        update.classes != null &&
        update.classes != [] &&
        !update.classes.contains(userClass),
  );

  return updates;
}
