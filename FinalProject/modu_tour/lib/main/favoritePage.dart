import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modu_tour/data/tour.dart';
import 'package:modu_tour/main/tourDetailPage.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  FavoritePage({this.databaseReference, this.db, this.id});

  @override
  State<StatefulWidget> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {

  Future<List<TourData>>? _tourList;
  @override
  void initState() {
    super.initState();
    _tourList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        List<TourData> tourList = snapshot.data as List<TourData>;
                        TourData info = tourList[index];
                        return Card(
                          child: InkWell(
                            child: Row(
                              children: <Widget>[
                                Hero(
                                    tag: 'tourinfo$index',
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: getImage(info.imagePath))))),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        info.title!,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('주소 : ${info.address}'),
                                      info.tel != 'null'
                                          ? Text('전화 번호 : ${info.tel}')
                                          : Container(),
                                    ],
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                  ),
                                  width:
                                  MediaQuery.of(context).size.width - 150,
                                )
                              ],
                            ),
                            onTap: () {
                              // 상세페이지 이동은 TourDetailPage를 재사용하도록 합니다
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TourDetailPage(
                                    id: widget.id,
                                    tourData: info,
                                    index: index,
                                    databaseReference:
                                    widget.databaseReference,
                                  )));
                            },
                            onDoubleTap: (){
                              deleteTour(widget.db!, info);
                            },
                          ),
                        );
                      },
                      itemCount: (snapshot.data! as List<TourData>).length,
                    );
                  } else {
                    return Text('No data');
                  }
              }
              return CircularProgressIndicator();
            },
            future: _tourList,
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(String? imagePath){
    if(imagePath != null) {
      return NetworkImage(imagePath);
    }else{
      return AssetImage('repo/images/map_location.png');
    }
  }

  void deleteTour(Future<Database> db, TourData info) async {
    final Database database = await db;
    await database.delete('place', where: 'title=?', whereArgs: [info.title]).then((value){
      setState(() {
        _tourList = getTodos();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('즐겨찾기를 해제합니다')));
    });
  }

  Future<List<TourData>> getTodos() async {
    final Database database = await widget.db!;
    final List<Map<String, dynamic>> maps = await database.query('place');

    return List.generate(maps.length, (i) {
      return TourData(
          title: maps[i]['title'].toString(),
          tel: maps[i]['tel'].toString(),
          address: maps[i]['address'].toString(),
          zipcode: maps[i]['zipcode'].toString(),
          mapy: maps[i]['mapy'].toString(),
          mapx: maps[i]['mapx'].toString(),
          imagePath: maps[i]['imagePath'].toString());
    });
  }
}
