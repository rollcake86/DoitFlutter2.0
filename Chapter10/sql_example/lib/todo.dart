class Todo{
  String? title;
  String? content;
  int? active;
  int? id;

  Todo({this.title, this.content, this.active , this.id});

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'title': title,
      'content': content,
      'active': active,
    };
  }
}
