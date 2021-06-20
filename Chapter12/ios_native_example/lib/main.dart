import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      return CupertinoApp(
        home: CupertinoNativeApp(),
      );
    }else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NativeApp(),
      );
    }
  }
}

class CupertinoNativeApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CupertinoNative();
  }
}

class _CupertinoNative extends State<CupertinoNativeApp> {
  static const platform = const MethodChannel('com.flutter.dev/calc');

  TextEditingController num1Controller =
  TextEditingController(text: 0.toString());
  TextEditingController num2Controller =
  TextEditingController(text: 0.toString());
  int? _result;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                CupertinoTextField(
                  controller: num1Controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                    controller: num2Controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                CupertinoButton(
                    child: Text('더해보기'),
                    onPressed: () {
                      _getCalc(
                          num1Controller.value.text, num2Controller.value.text);
                    }),
                SizedBox(
                  height: 10,
                ),
                Text(_result.toString())
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ));
  }

  Future<void> _getCalc(String value1, String value2) async {
    int result;
    try {
      result = await platform
          .invokeMethod('add', [int.parse(value1), int.parse(value2)]);
    } on PlatformException catch (e) {
      result = -1;
    }
    setState(() {
      _result = result;
    });
  }

}




class NativeApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class _NativeApp extends State<NativeApp>{
  String _deviceInfo = ''; // 나중에 네이티브 정보가 들어올 변수
  static const platform = const MethodChannel('com.flutter.dev/info');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Natvie 통신 예제'),),
      body: Container(
        child: Center(
          child: Text(_deviceInfo , style: TextStyle(fontSize: 30),),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _getDeviceInfo();
      } , child: Icon(Icons.get_app),),
    );
  }


  Future<void> _getDeviceInfo() async{
    String batteryLevel;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      batteryLevel = 'Device info : $result';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get Device info: '${e.message}'.";
    }
    setState(() {
      _deviceInfo = batteryLevel;
    });
  }
}
