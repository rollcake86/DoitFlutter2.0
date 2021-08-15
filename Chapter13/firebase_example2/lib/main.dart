import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'memoPage.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: FutureBuilder(
        future: Firebase.initializeApp(), // 선언해야 할 함수
        builder: (context, snapshot) {
          if (snapshot.hasError) { // 만약 선언 시 에러가 나면 출력될 위젯
            return Center(
              child: Text('Error'),
            );
          }
// 선언 완료 후 표시할 위젯
          if (snapshot.connectionState == ConnectionState.done) {
            _getToken();
            _initFirebaseMessaging(context);
            return MemoPage();
          }
// 선언되는 동안 표시할 위젯
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print("messaging.getToken() , ${await messaging.getToken()}");
  }

  _initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print(event.notification!.title);
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("알림"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

}

