import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

class MemoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoApp();
}

class _MemoApp extends State<MemoApp> {

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  AndroidNotificationChannel? channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://widgetapplication-98eee.firebaseio.com/';
  List<Memo> memos = List.empty(growable: true);
  // final FirebaseMessaging _firebaseMessaging = FirebaseMexssaging();

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }


  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database?.reference().child('memo');
    reference?.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  _initFirebaseMessaging(BuildContext context) async{
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {

        // showDialog(context: context, builder: (context){
        //   return AlertDialog(title: Text("${notification.title}"), content: Text("${notification.body}"),);
        // });

        flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                icon: 'launch_background',
              ),
            ));

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    print("messaging.getToken() , ${await messaging.getToken()}");

  }

  @override
  Widget build(BuildContext context) {
    _initFirebaseMessaging(context);

    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 앱'),
      ),
      body:
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            child: Center(
              child: memos.length == 0
                  ? CircularProgressIndicator()
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Card(
                    child: GridTile(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: SizedBox(
                          child: GestureDetector(
                            onTap: () async {

                              Memo? memo = await Navigator.of(context).push(
                                  MaterialPageRoute<Memo>(
                                      builder: (BuildContext context) =>
                                          MemoDetailPage(
                                              reference!, memos[index])));
                              if (memo != null) {
                                setState(() {
                                  memos[index].title = memo.title;
                                  memos[index].content = memo.content;
                                });
                              }
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(memos[index].title),
                                      content: Text('삭제하시겠습니까?'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              reference!
                                                  .child(memos[index].createTime)
                                                  .remove()
                                                  .then((_) {
                                                setState(() {
                                                  memos.removeAt(index);
                                                  Navigator.of(context).pop();
                                                });
                                              });
                                            },
                                            child: Text('예')),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('아니요')),
                                      ],
                                    );
                                  });
                            },
                            child: Text(memos[index].content),
                          ),
                        ),
                      ),
                      header: Text(memos[index].title),
                      footer: Text(memos[index].createTime.substring(0, 10)),
                    ),
                  );
                },
                itemCount: memos.length,
              ),
            ),
          ),
          if (_anchoredBanner != null)
            Container(
              color: Colors.green,
              width: _anchoredBanner!.size.width.toDouble(),
              height: _anchoredBanner!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredBanner!),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MemoAddApp(reference!)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredBanner?.dispose();
  }
}

