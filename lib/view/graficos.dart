
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graficos{

  static List<charts.Series<Receita, String>> gerarSeriesReceita(List<Receita> receitas){
    return [ 
      new charts.Series<Receita, String>(
              id: 'Receitas',
              domainFn: (Receita receita, _) => receita.ano.toString(),
              measureFn: (Receita receita, _) => receita.valorEmMilhoes(),
              data: receitas,
              insideLabelStyleAccessorFn: (Receita receita, _) => charts.TextStyleSpec(
                fontFamily: 'Poppins',
                      fontSize: 12, // size in Pts.
                      color: charts.MaterialPalette.white
              ),
              colorFn: (Receita receita, _) =>
                charts.ColorUtil.fromDartColor(receita.cor),
              labelAccessorFn: (Receita receita, _) =>
                 'R\$ ${receita.valorEmMilhoesString()} milhões')
    ];
  }

  static List<charts.Series<Despesa, String>> gerarSeriesDespesa(List<Despesa> despesas){
    return [ 
      new charts.Series<Despesa, String>(
              id: 'Despesas',
              domainFn: (Despesa despesa, _) => despesa.ano.toString(),
              measureFn: (Despesa despesa, _) => despesa.valorEmMilhoes(),
              data: despesas,
              insideLabelStyleAccessorFn: (Despesa despesa, _) => charts.TextStyleSpec(
                fontFamily: 'Poppins',
                      fontSize: 12, // size in Pts.
                      color: charts.MaterialPalette.white
              ),
              colorFn: (Despesa despesa, _) =>
                charts.ColorUtil.fromDartColor(despesa.cor),
              labelAccessorFn: (Despesa despesa, _) =>
                  'R\$ ${despesa.valorEmMilhoesString()} milhões')
    ];
  }

  static Widget graficoDeBarrasReceita(List<Receita> receitas){
    return new charts.BarChart(
      gerarSeriesReceita(receitas),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, 
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))), 
    );
  }

  static Widget graficoDePizzaReceita(List<Receita> receitas){
    return new charts.PieChart(
      gerarSeriesReceita(receitas),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      behaviors: [
        new charts.DatumLegend(     
          position: charts.BehaviorPosition.end,       
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: charts.MaterialPalette.black
          ),
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : ' - $value';
          },
        ),
      ],
    );
  }

  static Widget graficoDeColunasReceita(List<Receita> receitas){
    return new charts.BarChart(
      gerarSeriesReceita(receitas),
      animate: true,      
      animationDuration: Duration(seconds: 1), 
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, 
                  color: charts.MaterialPalette.black),              
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))
      ), 
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),           
    );
  }

  static Widget graficoDeBarrasDespesa(List<Despesa> despesas){
    return new charts.BarChart(
      gerarSeriesDespesa(despesas),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, 
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))), 
    );
  }

  static Widget graficoDePizzaDespesa(List<Despesa> despesas){
    
    return new charts.PieChart(
      gerarSeriesDespesa(despesas),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      behaviors: [
        new charts.DatumLegend(     
          position: charts.BehaviorPosition.top,       
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: charts.MaterialPalette.black
          ),
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          // measureFormatter: (num value) {
          //   return value == null ? '-' : "- "+formatMoeda('$value')+"";
          // },
        ),
      ],
      defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()])
    );
  }

  static Widget graficoDeColunasDespesa(List<Despesa> despesas){
    return new charts.BarChart(
      gerarSeriesDespesa(despesas),
      animate: true,      
      animationDuration: Duration(seconds: 1),     
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, 
                  color: charts.MaterialPalette.black),              
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))
      ), 
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),           
    );
  }

  String formatMoeda(double valor){
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(valor);
  }

}