import 'package:fiscaliza_cidadao/controller/controller.dart';
import "package:flutter/material.dart";

class ControllerTelaHome extends Controller {
  

   


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

 
}