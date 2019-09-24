
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:fiscaliza_cidadao/view/tela_despesa_municipio.dart';
import 'package:fiscaliza_cidadao/view/tela_receita_municipio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerTelaMunicipio{



    static void abrirTelaDespesas(BuildContext context, Despesa despesa, String nome){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDespesaMunicipio(despesa, nome)
      ),
    ); 
  }

   static void abrirTelaReceitas(BuildContext context, Receita receita, String nome){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaReceitaMunicipio(receita, nome)
      ),
    ); 
  }
}