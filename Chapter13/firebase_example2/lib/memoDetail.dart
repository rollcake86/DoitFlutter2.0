import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  final DatabaseReference reference;
  final Memo memo;
  MemoDetailPage(this.reference, this.memo);
  @override
  State<StatefulWidget> createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  TextEditingController? titleController;
  TextEditingController? contentController;


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: '제목', fillColor: Colors.blueAccent),
              ),
              Expanded(
                  child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration(labelText: '내용'),
              )),
              MaterialButton(
                onPressed: () {
                  Memo memo = Memo(titleController!.value.text,
                      contentController!.value.text, widget.memo.createTime);
                  widget.reference
                      .child(widget.memo.createTime.toString())
                      .set(memo.toJson())
                      .then((_) {
                    Navigator.of(context).pop(memo);
                  });
                },
                child: Text('수정하기'),
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
