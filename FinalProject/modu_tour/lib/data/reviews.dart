import 'package:firebase_database/firebase_database.dart';

class Review {
  String id;
  String review;
  String createTime;

  Review(this.id, this.review, this.createTime);

  Review.fromSnapshot(DataSnapshot snapshot)
      : id = (snapshot.value as Map)['id'],
        review = (snapshot.value as Map)['review'],
        createTime = (snapshot.value as Map)['createTime'];

  toJson() {
    return {
      'id': id,
      'review': review,
      'createTime': createTime,
    };
  }
}
