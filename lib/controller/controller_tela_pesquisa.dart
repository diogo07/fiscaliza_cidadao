import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fiscaliza_cidadao/view/tela_municipio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ControllerTelaPesquisa{

  static Future<List<Municipio>> buscarMunicipios(String query) async {
    final response = await http.get('http://api.carlosecelso.com.br/api/municipio/'+query+'/');
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);
      List<Municipio> listaMunicipios = new List<Municipio>();
      dados.forEach((dado){
        listaMunicipios.add(new Municipio(dado['codigo'], dado['nome'], dado['uf'], dado['regiao']));
      });
      print(listaMunicipios);
      return listaMunicipios;  
    } else {    
      return null;
    }
  }

  static void abrirTelaMunicipio(BuildContext context, int codigo, String nomeMunicipio){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaMunicipio(codigo, nomeMunicipio)
      ),
    ); 
  }


}