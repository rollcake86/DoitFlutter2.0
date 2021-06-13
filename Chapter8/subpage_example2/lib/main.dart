import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subpageexample/subDetail.dart';
import 'package:subpageexample/thirdDetail.dart';

import 'secondDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SubDetail(),
        '/second' : (context) => SecondDetail(),
        '/third' : (context) => ThirdDetail(),
      },
    );
  }
}

class SubMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubMain();
}

class _SubMain extends State<SubMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Page Main'),
      ),
      body: Container(
        child: Center(
          child: Text('첫번째 페이지'),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SecondPage()));
      } , child: Icon(Icons.add),),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('돌아가기'),
          ),
        ),
      ),
    );
  }
}
