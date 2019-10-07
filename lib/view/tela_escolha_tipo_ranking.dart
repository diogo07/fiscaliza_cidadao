import 'package:fiscaliza_cidadao/controller/controller.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:fiscaliza_cidadao/view/tela_escolha_estado.dart';
import 'package:fiscaliza_cidadao/view/tela_rankings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TelaEscolhaTipoRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      GradientAppBarBack('Ranking'),
      Expanded(
          child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          
          Container(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Escolha a forma como você deseja visualizar as informações:',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 15,
                      color: Colors.black87),
                ),
              ),
          ),
          
          Container(
              child: new Column(children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                componentCard(context, "\nRanking Por Estado", TelaEscolhaEstado(),
                    Icons.location_city),
                componentCard(
                    context, "\nRanking Nacional", TelaRankings(), Icons.select_all),
              ],
            ),
          ])),
          
        ],
      )),
    ]));
  }

  Widget componentCard(
      BuildContext context, String titulo, Widget tela, IconData icon) {
    return new Expanded(
      flex: 2,
      child: new Card(
          margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 40.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.blue[300],
          child: new Container(
            padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: InkWell(
              onTap: () {
                Controller.abrirTela(tela, context);
              },
              child: new Column(
                children: <Widget>[
                  new Icon(
                    icon,
                    size: 35,
                    color: Colors.white,
                  ),
                  new Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: new Text(
                        titulo,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
