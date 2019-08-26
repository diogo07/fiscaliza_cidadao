import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';

class TelaConsultasPersonalizas extends StatefulWidget{
  
   _TelaConsultasPersonalizas createState() => new _TelaConsultasPersonalizas();

}

class _TelaConsultasPersonalizas extends State<TelaConsultasPersonalizas>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBarBack("Comparações"),
        ]
      )
    );
  }
  
}