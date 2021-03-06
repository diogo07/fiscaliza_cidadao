import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ClassificacaoReceitaPorcentagem{
  int ano;
  double valor;
  String tipo;
  Color cor;

  ClassificacaoReceitaPorcentagem(this.ano, this.valor, this.tipo, this.cor);

  String formatPorcentagem(){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(valor);
  }

  String getTipo(){
    if(tipo == 'Receitas Correntes'){
      return 'R. Cor.';
    }else if(tipo == 'Receitas de Capital'){
      return 'R. Cap.';
    }else if(tipo == 'Receitas Correntes - Intraorçamentárias'){
      return 'R. Cor. Int.';
    }else{
      return 'R. Cap. Int.';
    }
  }

}