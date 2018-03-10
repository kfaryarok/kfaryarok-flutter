import 'package:flutter/material.dart';

// TODO: Check if this can possibly be stateless
class AboutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("אודות"),
      ),
    );
  }
}
