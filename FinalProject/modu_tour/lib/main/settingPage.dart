import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final String? id;

  SettingPage({this.databaseReference, this.id});

  @override
  State<StatefulWidget> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  bool pushCheck = true;

  static const _adUnitID = "ca-app-pub-4874780746681507/1727641684";
  // final _nativeAdController = NativeAdmobController();

  @override
  void dispose() {
    super.dispose();
    // _nativeAdController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // if(_bannerAd !=null && mounted) {
    //   _bannerAd
    //     ..load()
    //     ..show(
    //       anchorOffset: 60,
    //       anchorType: AnchorType.bottom,
    //     );
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('설정하기'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '푸시 알림',
                    style: TextStyle(fontSize: 20),
                  ),
                  Switch(
                      value: pushCheck,
                      onChanged: (value) {
                        setState(() {
                          pushCheck = value;
                        });
                        _setData(value);
                      })
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              SizedBox(
                height: 50,
              ),
              MaterialButton(
                onPressed: () {
                  showsDialog(context);
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                },
                child: Text('로그아웃', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(
                height: 50,
              ),
              MaterialButton(
                onPressed: () {
                  AlertDialog dialog = new AlertDialog(
                    title: Text('아이디 삭제'),
                    content: Text('아이디를 삭제하시겠습니까?'),
                    actions: <Widget>[
                      MaterialButton(
                          onPressed: () {
                            print(widget.id);
                            widget.databaseReference!
                                .child('user')
                                .child(widget.id!)
                                .remove();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          },
                          child: Text('예')),
                      MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('아니요')),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (context) {
                        return dialog;
                      });
                },
                child: Text('회원 탈퇴', style: TextStyle(fontSize: 20)),
              ),
              // NativeAdmob(
              //   // Your ad unit id
              //   adUnitID: _adUnitID,
              //   numberAds: 3,
              //   controller: _nativeAdController,
              //   type: NativeAdmobType.banner,
              // ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  void _setData(bool value) async {
    var key = "push";
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  void _loadData() async {
    var key = "push";
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var value = pref.getBool(key);
      if (value == null) {
        setState(() {
          pushCheck = true;
        });
      } else {
        setState(() {
          pushCheck = value;
        });
      }
    });
  }

  void showsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text("축하합니다"),
          subtitle: Text("모두의 여행앱을 완성했어요"),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
