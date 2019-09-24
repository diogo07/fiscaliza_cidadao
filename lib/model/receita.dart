import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Receita{
  int ano, codigo;
  double valor;
  String classificacao, funcao;
  Color cor;

  Receita(this.codigo, this.ano, this.valor, this.classificacao, this.funcao, this.cor);
 
 
  String formatMoeda(){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(valor);
  }

  String valorEmString(){
    NumberFormat formatter = NumberFormat("0.00");

    if(valor > 1000000000.0){
      double valorEmMilhoes = valor/1000000000;
      return "R\$ "+formatter.format(valorEmMilhoes)+" bilhões".replaceAll('.', ',');
    }else if(valor > 1000000.0){
      double valorEmMilhoes = valor/1000000;
      return "R\$ "+formatter.format(valorEmMilhoes)+" milhões".replaceAll('.', ',');
    }else if(valor < 1000000.0 && valor > 1000.0){
      double valorEmMilhares = valor/1000;
      return "R\$ "+formatter.format(valorEmMilhares)+" mil".replaceAll('.', ',');
    }else{
      return "R\$ "+formatter.format(valor).replaceAll('.', ',');
    }
    
  }

  double valorFormatado(){

    if(valor > 1000000000.0){
      return valor/1000000000;
    }else if(valor > 1000000.0){
      return valor/1000000;
    }else if(valor < 1000000.0 && valor > 1000.0){
      return valor/1000;
    }else{
      return valor;
    }
    
  }

  double valorEmMilhoes(){
    return valor / 1000000;
  }

  String valorEmMilhoesString(){
    NumberFormat formatter = NumberFormat("0.00");
    double valorEmMilhoes = valor / 1000000;
    return formatter.format(valorEmMilhoes);
  }

}