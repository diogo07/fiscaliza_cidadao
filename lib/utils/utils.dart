
import 'package:intl/intl.dart';

class Utils{

  static final API = "http://op.repsys.com.br/api/"; 

  static String removerCaracteresEspeciais(String query){
    query = query.toLowerCase();
    query = query.replaceAll(' ', '_');
    query = query.replaceAll('ã', '__tila__');
    query = query.replaceAll('õ', '__tilo__');
    query = query.replaceAll('â', '__circunflexoa__');
    query = query.replaceAll('ê', '__circunflexoe__');
    query = query.replaceAll('ô', '__circunflexoo__');
    query = query.replaceAll('á', '__agudoa__');
    query = query.replaceAll('é', '__agudoe__');
    query = query.replaceAll('í', '__agudoi__');
    query = query.replaceAll('ó', '__agudoo__');
    query = query.replaceAll('ú', '__agudou__');
    query = query.replaceAll('ç', '__cedilha__');

    return query;
  }

  static String valorEmString(double valor){
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

}