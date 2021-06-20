import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendDataExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SendDataExample();
}

class _SendDataExample extends State<SendDataExample> {
  static const platform = const MethodChannel('com.flutter.dev/encryto');

  TextEditingController controller = new TextEditingController(text: '안녕하세요  flutter');
  String _changeText = 'Nothing';
  String _reChangedText = 'Nothing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Data Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _changeText,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  _decodeText(_changeText);
                },
                child: Text('디코딩 하기'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _reChangedText,
                style: TextStyle(fontSize: 20),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendData(controller.value.text);
        },
        child: Text('변환'),
      ),
    );
  }

  Future<void> _sendData(String text) async {
    final String result = await platform.invokeMethod('getEncryto', text);
    print(result);
    setState(() {
      _changeText = result;
    });
  }

  void _decodeText(String changeText) async{
    final String result = await platform.invokeMethod('getDecode', changeText);
    setState(() {
      _reChangedText = result;
    });
  }
}
