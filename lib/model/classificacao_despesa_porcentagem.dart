import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ClassificacaoDespesaPorcentagem{
  int ano;
  double valor;
  String tipo;
  Color cor;

  ClassificacaoDespesaPorcentagem(this.ano, this.valor, this.tipo, this.cor);

  String formatPorcentagem(){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(valor);
  }

}