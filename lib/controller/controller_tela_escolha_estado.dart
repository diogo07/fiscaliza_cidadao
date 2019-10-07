
import 'package:fiscaliza_cidadao/view/tela_ranking_estado.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerTelaEscolhaEstado{

  static void abrirTelaRankingEstados(BuildContext context, String uf){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaRankingEstado(uf)
      ),
    ); 
  }

}