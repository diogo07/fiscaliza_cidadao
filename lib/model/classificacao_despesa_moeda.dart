
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ClassificacaoDespesaMoeda{
  int ano;
  double valor;
  String tipo;
  Color cor;

  ClassificacaoDespesaMoeda(this.ano, this.valor, this.tipo, this.cor);

  double valorEmMilhoes(){
    return valor/1000000;
  }

  double valorEmMilhares(){
    return valor/1000;
  }

  String valorEmMilhoesString(){
    NumberFormat formatter = NumberFormat("0.00");
    double valorEmMilhoes = valor/1000000;
    return formatter.format(valorEmMilhoes);
  }

  String valorEmMilharesString(){
    NumberFormat formatter = NumberFormat("0.00");
    double valorEmMilhoes = valor/1000;
    return formatter.format(valorEmMilhoes);
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

}