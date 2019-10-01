
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/view/tela_comparativo_despesa_municipios.dart';
import 'package:fiscaliza_cidadao/view/tela_comparativo_receita_municipios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerTelaComparativoMunicipios{


  static void abrirTelaComparativoReceitasMunicipios(BuildContext context, Municipio primeiroMunicipio, Municipio segundoMunicipio, int ano){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaComparativoReceitaMunicipios(primeiroMunicipio, segundoMunicipio, ano)
      ),
    ); 
  }

  static void abrirTelaComparativoDespesasMunicipios(BuildContext context, Municipio primeiroMunicipio, Municipio segundoMunicipio, int ano){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaComparativoDespesaMunicipios(primeiroMunicipio, segundoMunicipio, ano)
      ),
    ); 
  }
}