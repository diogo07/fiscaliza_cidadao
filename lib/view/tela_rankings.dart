
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';

class TelaRankings extends StatefulWidget{
  
   _TelaRankings createState() => new _TelaRankings();

}

class _TelaRankings extends State<TelaRankings>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBarBack("Rankings"),
        ]
      )
    );
  }
  
}