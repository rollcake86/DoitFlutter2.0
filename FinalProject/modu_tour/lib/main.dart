import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';
import 'mainPage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'signPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, tel TEXT , zipcode TEXT , address TEXT , mapx Number , mapy Number , imagePath TEXT)",
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<Database> database =
    initDatabase(); // build 할때 initDatabase() 함수를 호출합니다
    return MaterialApp(
      title: '모두의 여행',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          _getToken();
          _initFirebaseMessaging(context);
          return LoginPage();
        },
        '/sign': (context) => SignPage(),
        '/main': (context) => MainPage(database),
      },
    );
  }

  _initFirebaseMessaging(BuildContext context)  {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print(event.data);
      print(event.notification!.title);
      bool? pushCheck = await _loadData();
      if(pushCheck!){
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
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  Future<bool?> _loadData() async {
    var key = "push";
    SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.getBool(key);
    return value;
  }

  _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print("messaging.getToken() , ${await messaging.getToken()}");
  }
}
