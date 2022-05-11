import 'package:firebase_database/firebase_database.dart';

class DisableInfo {
  String? key;
  int? disable1;
  int? disable2;
  String? id;
  String? createTime;

  DisableInfo(this.id, this.disable1, this.disable2, this.createTime);

  DisableInfo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = (snapshot.value as Map)['id'],
        disable1 = (snapshot.value as Map)['disable1'],
        disable2 = (snapshot.value as Map)['disable2'],
        createTime = (snapshot.value as Map)['createTime'];

  toJson() {
    return {
      'id': id,
      'disable1': disable1,
      'disable2': disable2,
      'createTime': createTime,
    };
  }
}
