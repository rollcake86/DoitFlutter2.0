import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliverPage();
}

class _SliverPage extends State<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // 앱바의 높이 설정
            expandedHeight: 150.0,
            // SliverAppBar 공간에 어떤 위젯을 만들지 설정
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Sliver Example'),
              background: Image.asset('repo/images/sunny.png'),
            ),
            backgroundColor: Colors.deepOrangeAccent,
          ),],),);
  }
}
