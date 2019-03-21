import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = "/setting";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置闹钟'),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: new Center(
        child: new Text('content'),
      )
    );
  }
}


