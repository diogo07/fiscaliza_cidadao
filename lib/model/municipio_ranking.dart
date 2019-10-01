import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MunicipioRanking{
  int ano;
  String nome, uf;
  double porcentagem;
  Color cor;

  MunicipioRanking(this.ano, this.nome, this. uf, this.porcentagem, this.cor);

  String formatPorcentagem(){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(porcentagem).replaceAll('.', ',')+'%';
  }


}