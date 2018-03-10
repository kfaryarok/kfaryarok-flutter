import 'package:flutter/material.dart';
import 'updates.dart';
import 'settings.dart' as settings;
import 'about.dart' as about;

void main() => runApp(new KfarYarokApp());

class KfarYarokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'KfarYarok-Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new KfarYarokHome(),
      routes: <String, WidgetBuilder>{
        "/settings": (_) => new settings.SettingsScreen(),
        "/about": (_) => new about.AboutScreen(),
      },
    );
  }
}

class KfarYarokHome extends StatefulWidget {
  @override
  KfarYarokHomeState createState() => new KfarYarokHomeState();
}

class KfarYarokHomeState extends State<KfarYarokHome> {
  List<Update> _updatesListViewItems;
  List<Update> get updatesListViewItems => _updatesListViewItems;
  set updatesListViewItems(List<Update> updates) => setState(() {
        _updatesListViewItems = updates;
      });
  bool get updatesListViewItemsSet => updatesListViewItems != null;

  /// Gets updates and assigns them to the field.
  /// If already set doesn't do anything.
  syncUpdates() async {
    if (updatesListViewItems == null) {
      updatesListViewItems = await getUpdates();
    }
  }

  @override
  Widget build(BuildContext context) {
    syncUpdates();
    return new Scaffold(
      // AppBar
      appBar: new AppBar(
        title: new Text('KfarYarok-Flutter'),
        actions: <Widget>[buildBarMenu()],
      ),

      // Body of the app
      body: new Directionality(
        textDirection: TextDirection.rtl,
        child: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 8.0),
          child: new Column(
            children: <Widget>[
              // Text at the top that shows when updates were last synced
              new Container(
                margin: const EdgeInsetsDirectional.only(top: 16.0),
                child: new Text("\$lastupdated"),
              ),

              // Divider between synced text and the updates themselves
              new Container(
                margin: const EdgeInsetsDirectional.only(top: 16.0),
                child: new Divider(color: Colors.grey[600], height: 1.0),
              ),

              // Body content
              // a ListView containing updates or a progress bar if loading
              buildBodyContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates either the main ListView or a [CircularProgressIndicator] when
  /// it hasn't finished getting updates.
  Widget buildBodyContent() {
    // Checking if it has finished loading is as simple as checking if the
    // update list is null
    return updatesListViewItemsSet
        ? new Expanded(
            // Update list isn't null, so we can show the ListView
            child: new ListView.builder(
              // Returns .length if updatesListViewItems isn't null, and if it
              // is returns 0 instead of updstesListViewItems (because of ??)
              itemCount: updatesListViewItems?.length ?? 0,
              itemBuilder: (_, int index) {
                return new UpdateWidget(
                  update: updatesListViewItems[index],
                  margin: const EdgeInsetsDirectional.only(top: 4.0),
                );
              },
            ),
          )
        : new Container(
            margin: const EdgeInsetsDirectional.only(top: 16.0),
            child: new CircularProgressIndicator(
              // Update list is null, so we need to show the progress bar
              value: null,
            ),
          );
  }

  /// Creates the appbar's menu button and populates it.
  PopupMenuButton buildBarMenu() {
    return new PopupMenuButton(
      icon: new Icon(Icons.more_vert),
      tooltip: "אפשרויות",
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
            Navigator.of(context).pushNamed("/settings");
            break;
          case MenuValue.about:
            Navigator.of(context).pushNamed("/about");
            break;
        }
      },
    );
  }
}

/// Possible items selected in the appbar's menu
enum MenuValue { settings, about }
