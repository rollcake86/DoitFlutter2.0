import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String pw;
  String createTime;

  User(this.id, this.pw, this.createTime);

  User.fromSnapshot(DataSnapshot snapshot)
      :
        id = snapshot.value['id'],
        pw = snapshot.value['pw'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };
  }
}
