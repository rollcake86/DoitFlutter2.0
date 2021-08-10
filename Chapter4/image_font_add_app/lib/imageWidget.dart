import 'package:flutter/material.dart';

class ImageWidgetApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetApp();
  }
}

class _ImageWidgetApp extends State<ImageWidgetApp> {
  String _text = "HelloFlutter";
  String _imagePath = "image/flutter.png";
  double _size = 200;
  int i = 0;
  var _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Widget'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                _imagePath,
                width: _size,
                height: _size,
                fit: BoxFit.contain,
              ),
              Text(
                '$_text',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 30, color: _color),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          if (i == 3) {
            i = 0;
          }
          switch (i) {
            case 0:
              _text = "Hello Flutter";
              _imagePath = "image/flutter.png";
              _size = 200;
              _color = Colors.blue;
              break;
            case 1:
              _text = "Hello iOS";
              _imagePath = "image/ios.jpg";
              _size = 150;
              _color = Colors.amber;
              break;
            case 2:
              _text = "Hello Android";
              _imagePath = "image/android.png";
              _size = 170;
              _color = Colors.lightGreen;
              break;
          }
          i++;
        });
      }),
    );
  }
}
