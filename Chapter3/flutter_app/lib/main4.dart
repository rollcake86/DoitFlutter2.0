import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{
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
            child: Switch(value: switchValue, onChanged: (value) {
              print(value);
              switchValue = value;
            }),
          ),
        )
    );
  }
}
