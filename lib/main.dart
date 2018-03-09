import 'package:flutter/material.dart';
import 'updates.dart';

void main() => runApp(new KfarYarokApp());

class KfarYarokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'KfarYarok-Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new KfarYarokHome(),
    );
  }
}

class KfarYarokHome extends StatefulWidget {
  @override
  KfarYarokHomeState createState() => new KfarYarokHomeState();
}

class KfarYarokHomeState extends State<KfarYarokHome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('KfarYarok-Flutter'),
        actions: <Widget>[buildBarMenu()],
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(horizontal: 8.0),
        child: new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsetsDirectional.only(top: 16.0),
              child: new Text("\$lastupdated"),
            ),
            new Container(
              margin: const EdgeInsetsDirectional.only(top: 16.0),
              child: new Divider(color: Colors.grey[600], height: 1.0),
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: getTestUpdates().length,
                itemBuilder: (_, int index) {
                  return new UpdateWidget(
                    update: getTestUpdates()[index],
                    margin: const EdgeInsetsDirectional.only(top: 4.0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates the appbar's menu button and populates it.
  PopupMenuButton buildBarMenu() {
    return new PopupMenuButton(
      icon: new Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuEntry<MenuValue>>[
            // Settings menu button
            new PopupMenuItem<MenuValue>(
              value: MenuValue.settings,
              child: new Text(
                "הגדרות",
                textDirection: TextDirection.rtl,
              ),
            ),
            // About menu button
            new PopupMenuItem<MenuValue>(
              value: MenuValue.about,
              child: new Text(
                "אודות",
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
      onSelected: (value) {
        switch (value) {
          case MenuValue.settings:
            break;
          case MenuValue.about:
            break;
        }
      },
    );
  }
}

/// Possible items selected in the appbar's menu
enum MenuValue { settings, about }
