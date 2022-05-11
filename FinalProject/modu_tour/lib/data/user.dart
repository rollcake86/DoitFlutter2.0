import 'package:firebase_database/firebase_database.dart';

class User {
  late String key;
  String id;
  String pw;
  String createTime;

  User(this.id , this.pw , this.createTime);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key!,
        id = (snapshot.value as Map)['id'],
        pw = (snapshot.value as Map)['pw'],
        createTime = (snapshot.value as Map)['createTime'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };
  }
}