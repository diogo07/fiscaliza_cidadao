import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Despesa{
  int ano, codigo;
  double valor;
  String classificacao, funcao;
  Color cor;

  Despesa(this.codigo, this.ano, this.valor, this.classificacao, this.funcao, this.cor);

  String formatMoeda(){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(valor);
  }

  double valorEmMilhoes(){
    NumberFormat formatter = NumberFormat("0.00");
    return valor/1000000;
  }

  String valorEmMilhoesString(){
    NumberFormat formatter = NumberFormat("0.00");
    double valorEmMilhoes = valor/1000000;
    return formatter.format(valorEmMilhoes);
  }

}