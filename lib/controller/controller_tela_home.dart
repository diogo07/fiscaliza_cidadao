import 'package:fiscaliza_cidadao/controller/controller.dart';
import "package:flutter/material.dart";
import 'package:fiscaliza_cidadao/view/tela_sobre.dart';
import 'package:fiscaliza_cidadao/view/tela_pesquisa.dart';
import 'package:fiscaliza_cidadao/view/tela_contato.dart';
import 'package:fiscaliza_cidadao/view/tela_ajuda.dart';

class ControllerTelaHome extends Controller {
  
  static void abrirTelaMunicipios(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPesquisaMunicipios()
      ),
    ); 
  }

  static void abrirTelaRankings(BuildContext context){
          
  }

  static void abrirTelaConsultasPersonalizadas(BuildContext context){
          
  }
   
  static void abrirTelaSobre(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaSobre()
      ),
    ); 
  }


  static void abrirTelaAjuda(BuildContext context){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => TelaAjuda()
      )
    );
  }

  static void abrirMsg(BuildContext context, String titulo, String texto){
    _showDialog(context, titulo, texto);
  }

  static void _showDialog(BuildContext context, String titulo, String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(titulo),
          content: new Text(texto),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  static void abrirTelaContato(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaContato()
      ),
    ); 
  }

 
}