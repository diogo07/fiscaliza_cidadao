import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';

class TelaAjuda extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBarBack('Ajuda'),

        ],
      ),
    );
  }

}