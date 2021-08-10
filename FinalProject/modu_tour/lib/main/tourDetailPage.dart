import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modu_tour/data/disableInfo.dart';
import 'package:modu_tour/data/reviews.dart';
import 'dart:math' as math;
import 'package:modu_tour/data/tour.dart';

class TourDetailPage extends StatefulWidget {
  final TourData? tourData;
  final int? index;
  final DatabaseReference? databaseReference;
  final String? id;

  TourDetailPage({this.tourData, this.index, this.databaseReference, this.id});

  @override
  State<StatefulWidget> createState() => _TourDetailPage();
}

class _TourDetailPage extends State<TourDetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _GoogleMapCamera;
  TextEditingController? _reviewTextController;
  Marker? marker;
  List<Review> reviews = List.empty(growable: true);
  bool _disableWidget = false;
  DisableInfo? _disableInfo;
  double disableCheck1 = 0;
  double disableCheck2 = 0;

  @override
  void initState() {
    super.initState();
    widget.databaseReference!
        .child('tour')
        .child(widget.tourData!.id.toString())
        .child('review').onChildAdded
        .listen((event) {
      if(event.snapshot.value != null) {
        setState(() {
          reviews.add(Review.fromSnapshot(event.snapshot));
        });
      }
    });

    _reviewTextController = TextEditingController();
    _GoogleMapCamera = CameraPosition(
      target: LatLng(double.parse(widget.tourData!.mapy.toString()),
          double.parse(widget.tourData!.mapx.toString())),
      zoom: 16,
    );
    MarkerId markerId = MarkerId(widget.tourData.hashCode.toString());
    marker = Marker(
        position: LatLng(double.parse(widget.tourData!.mapy.toString()),
            double.parse(widget.tourData!.mapx.toString())),
        flat: true,
        markerId: markerId);
    markers[markerId] = marker!;
    getDisableInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.tourData!.title}',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(top: 10),
            ),
            pinned: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Hero(
                            tag: 'tourinfo${widget.index}',
                            child: Container(
                                width: 300.0,
                                height: 300.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                    Border.all(color: Colors.black, width: 1),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: getImage(widget.tourData!.imagePath)
                                      ,)))),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            widget.tourData!.address!,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        getGoogleMap(),
                        _disableWidget == false ? setDisableWidget() : showDisableWidget() ,
                        //  reviewWidget()
                      ],
                    ),
                  ),
                ),
              ])),
          SliverPersistentHeader(
            delegate: _HeaderDelegate(
                minHeight: 50,
                maxHeight: 100,
                child: Container(
                  color: Colors.lightBlueAccent,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '후기',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                )),
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      child: Text(
                        '${reviews[index].id} : ${reviews[index].review}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    onDoubleTap: (){
                      if(reviews[index].id == widget.id){
                        widget.databaseReference!
                            .child('tour')
                            .child(widget.tourData!.id.toString())
                            .child('review').child(widget.id!)
                            .remove();
                        setState(() {
                          reviews.removeAt(index);
                        });
                      }
                    },
                  ),
                );
              }, childCount: reviews.length)),
          SliverList(
              delegate: SliverChildListDelegate([
                MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('후기 쓰기'),
                            content: TextField(
                              controller: _reviewTextController,
                            ),
                            actions: <Widget>[
                              MaterialButton(
                                  onPressed: () {
                                    Review review = Review(
                                        widget.id!,
                                        _reviewTextController!.value.text,
                                        DateTime.now().toIso8601String());
                                    widget.databaseReference!
                                        .child('tour')
                                        .child(widget.tourData!.id.toString())
                                        .child('review').child(widget.id!)
                                        .set(review.toJson());
                                  },
                                  child: Text('후기 쓰기')),
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('종료하기')),
                            ],
                          );
                        });
                  },
                  child: Text('댓글 쓰기'),
                )
              ]))
        ],
      ),
    );
  }

  getDisableInfo() {
    widget.databaseReference!
        .child('tour')
        .child(widget.tourData!.id.toString())
        .onValue
        .listen((event) {
      _disableInfo = DisableInfo.fromSnapshot(event.snapshot);
      if (_disableInfo!.id == null) {
        setState(() {
          _disableWidget = false;
        });
      } else {
        setState(() {
          _disableWidget = true;
        });
      }
    });
  }

  ImageProvider getImage(String? imagePath){
    if(imagePath != null) {
      return NetworkImage(imagePath);
    }else{
      return AssetImage('repo/images/map_location.png');
    }
  }

  Widget setDisableWidget() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text('데이터가 없습니다. 추가해주세요'),
            Text('시각 장애인 이용 점수 :  ${disableCheck1.floor()}'),
            Padding(
              padding: EdgeInsets.all(20),
              child: Slider(
                  value: disableCheck1,
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    setState(() {
                      disableCheck1 = value;
                    });
                  }),
            ),
            Text('지체 장애인 이용 점수 : ${disableCheck2.floor()}'),
            Padding(
              padding: EdgeInsets.all(20),
              child: Slider(
                  value: disableCheck2,
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    setState(() {
                      disableCheck2 = value;
                    });
                  }),
            ),
            MaterialButton(
              onPressed: () {
                DisableInfo info = DisableInfo(widget.id ,disableCheck1.floor(),
                    disableCheck2.floor(), DateTime.now().toIso8601String());
                widget.databaseReference!
                    .child("tour")
                    .child(widget.tourData!.id.toString())
                    .set(info.toJson())
                    .then((value) {
                  setState(() {
                    _disableWidget = true;
                  });
                });
              },
              child: Text('데이터 저장하기'),
            )
          ],
        ),
      ),
    );
  }

  getGoogleMap() {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width - 50,
      child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _GoogleMapCamera!,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values)),
    );
  }

  showDisableWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.accessible , size: 40, color: Colors.orange),
              Text('지체 장애 이용 점수 : ${_disableInfo!.disable2}' ,style: TextStyle(fontSize: 20),)
            ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.remove_red_eye, size: 40 , color: Colors.orange,),
              Text('시각 장애 이용 점수 : ${_disableInfo!.disable1}',style: TextStyle(fontSize: 20))
            ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          SizedBox(
            height: 20,
          ),
          Text('작성자  : ${_disableInfo!.id}'),
          SizedBox(
            height: 20,
          ),
          MaterialButton(onPressed: (){
            setState(() {
              _disableWidget = false;
            });
          } , child: Text('새로 작성하기'),)
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  _HeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => math.max(maxHeight!, minHeight!);

  @override
  double get minExtent => minHeight!;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
