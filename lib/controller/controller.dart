
import 'package:flutter/material.dart';

class Controller{
  static void abrirTela(Widget tela, BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => tela
      ),
    ); 
  } 
}