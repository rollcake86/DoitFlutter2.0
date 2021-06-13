import 'package:flutter/material.dart';

import '../animalItem.dart';

class FirstApp extends StatelessWidget {
  final List<Animal> list; // Animal List 선언
  FirstApp({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView.builder(
              itemBuilder: (context, position) {
                return GestureDetector(
                  child:  Card(
                    child: Row(
                      children: <Widget>[
                        Image.asset(list[position].imagePath , height: 100, width: 100, fit: BoxFit.contain,),
                        Text(list[position].animalName),
                      ],
                    ),
                  ),
                  onTap: (){
                    AlertDialog dialog = AlertDialog(
                      content: Text('이 동물은 ${list[position].kind} 입니다' , style: TextStyle(fontSize: 30.0),),
                    );
                    showDialog(
                        context: context, builder: (BuildContext context) => dialog);
                  },
                  onLongPress: (){
                    list.removeAt(position);
                  },
                );
              },
              itemCount: list.length),
        ),
      ),
    );
  }
}
