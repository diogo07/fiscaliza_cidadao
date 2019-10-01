import "package:fiscaliza_cidadao/view/app_bar.dart" ;
import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return new Scaffold(
      body: new Column(
        children: <Widget>[
          GradientAppBarBack('Sobre'),
          Expanded(
            child:ListView(
              children: <Widget>[              
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                  child: Text('Fiscaliza Cidadão', textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18, color: Colors.black54),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                  child: Text('\t\t\t\t\t\tO Fiscaliza Cidadão é um projeto acadêmico, que utiliza dados abertos sobre o orçamento público dos municípios brasileiros. O seu principal intuito é proporcionar para a sociedade uma maneira amigável de analisar o orçamento anual de cada município brasileiro. Desde a forma como o município arrecada suas fontes de renda, até o modo como esses valores são distribuídos em prol da população.', textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                  child: Text('\t\t\t\t\t\tAtualmente, ele se encontra na versão 1.0.', textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                  child: Text('Fonte dos Dados', textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18, color: Colors.black54),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                  child: Text('\t\t\t\t\t\tOs dados apresentados são coletados do Sistema de Informações Contábeis e Fiscais do Setor Público Brasileiro - Siconfi. Este sistema é responsável pelo recebimento de informações contábeis, financeiras e de estatísticas fiscais oriundas de um universo que compreende 5.570 municípios, 26 estados, o Distrito Federal e a União.', textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 60, left: 30, right: 30),
                  child: Text('\t\t\t\t\t\tÉ importante destacar que, por se tratar de dados públicos e pela massiva quantidade de informações, divergências entre valores apresentados na aplicação podem ocorrer. Uma vez que este projeto se limita apenas a analisar os dados declarados pelos muninípios brasileiros.', textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),)
                )
              ]
            )
          )
        ],
      ),
    );
  }

}

