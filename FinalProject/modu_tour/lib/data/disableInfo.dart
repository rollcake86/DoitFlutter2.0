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
        id = snapshot.value['id'],
        disable1 = snapshot.value['disable1'],
        disable2 = snapshot.value['disable2'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'id': id,
      'disable1': disable1,
      'disable2': disable2,
      'createTime': createTime,
    };
  }
}
