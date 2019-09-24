
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/view/tela_comparativo_municipios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerTelaConsultasPersonalizadas{
  
  
  static void abrirTelaComparativoMunicipios(BuildContext context, Municipio primeiroMunicipio, Municipio segundoMunicipio){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaComparativoMunicipios(primeiroMunicipio, segundoMunicipio)
      ),
    ); 
  }



}