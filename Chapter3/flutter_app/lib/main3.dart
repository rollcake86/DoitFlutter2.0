import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var switchValue = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        darkTheme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: Switch(value : switchValue  , onChanged: (value) {
              switchValue = value;
            }),
          ),
        )
    );
  }
}

