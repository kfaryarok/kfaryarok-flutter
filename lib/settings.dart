import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("הגדרות"),
      ),
    );
  }
}
