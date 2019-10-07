import 'package:fiscaliza_cidadao/controller/controller.dart';
import 'package:fiscaliza_cidadao/view/tela_ajuda.dart';
import 'package:fiscaliza_cidadao/view/tela_consultas_personalizadas.dart';
import 'package:fiscaliza_cidadao/view/tela_contato.dart';
import 'package:fiscaliza_cidadao/view/tela_escolha_tipo_ranking.dart';
import 'package:fiscaliza_cidadao/view/tela_pesquisa.dart';
import 'package:fiscaliza_cidadao/view/tela_rankings.dart';
import 'package:fiscaliza_cidadao/view/tela_sobre.dart';
import "package:flutter/material.dart";
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/services.dart';


class TelaHome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBar('Início'),
          new Expanded(            
          child: new ListView(            
            shrinkWrap: true,
            children: <Widget>[
             
              new Container(              
              child: new Column(                
                children: <Widget>[            

                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,                  
                  children: <Widget>[
                    componentCard(context, "\nMunicípios", TelaPesquisaMunicipios(), Icons.search),
                    componentCard(context, "\nRankings", TelaEscolhaTipoRanking(), Icons.insert_chart),
                    componentCard(context, "\nComparações", TelaConsultasPersonalizas(), Icons.compare),
                                    
                  ],  
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                  children: <Widget>[
                    componentCard(context, "\nSobre", TelaSobre(), Icons.priority_high),
                    componentCard(context, "\nAjuda", TelaAjuda(), Icons.help),
                    componentCard(context, "\nContato", TelaContato(), Icons.contact_mail),                          
                  ],  
                ),

                        
                  
                  
                ],
              )
            
            )
             ],
          )
          ),
        ],
      ),
    );
  }

  Widget componentCard(BuildContext context, String titulo, Widget tela, IconData icon){
    return new Expanded(
      flex: 2,                
      child: 
        new Card(
            margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 40.0),   
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            // color: Color.fromRGBO(227,61,61, 1),
            // color: Color.fromRGBO(20, 184, 66, 1),
            color: Colors.blue[300],
            child: new Container(          
              padding: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: InkWell(
                onTap: (){ 
                  Controller.abrirTela(tela, context);                         
                },
                child:                
                  new Column(
                  children: <Widget>[                      
                    new Icon(icon, size: 35, color: Colors.white,),
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
                      )
                    )
                  ],
                ),
              ),
            )            
          ),
        );
  }

 
}

