
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fiscaliza_cidadao/controller/controller_tela_municipio.dart';
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graficos{

  static List<charts.Series<Receita, String>> gerarSeriesReceita(List<Receita> receitas, int codigoMunicipio){
    return [ 
      new charts.Series<Receita, String>(
              id: codigoMunicipio.toString(),
              domainFn: (Receita receita, _) => receita.ano.toString(),
              measureFn: (Receita receita, _) => receita.valor,
              data: receitas,
              insideLabelStyleAccessorFn: (Receita receita, _) => charts.TextStyleSpec(
                fontFamily: 'Poppins',
                      fontSize: 12, // size in Pts.
                      color: charts.MaterialPalette.white
              ),
              colorFn: (Receita receita, _) =>
                charts.ColorUtil.fromDartColor(receita.cor),
              outsideLabelStyleAccessorFn: (Receita receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
              labelAccessorFn: (Receita receita, _) =>
                 receita.valorEmString())
    ];
  }

  static List<charts.Series<Despesa, String>> gerarSeriesDespesa(List<Despesa> despesas, int codigoMunicipio){
    return [ 
      new charts.Series<Despesa, String>(
              id: codigoMunicipio.toString(),
              domainFn: (Despesa despesa, _) => despesa.ano.toString(),
              measureFn: (Despesa despesa, _) => despesa.valor,
              data: despesas,
              insideLabelStyleAccessorFn: (Despesa despesa, _) => charts.TextStyleSpec(
                fontFamily: 'Poppins',
                      fontSize: 12, // size in Pts.
                      color: charts.MaterialPalette.white
              ),
              colorFn: (Despesa despesa, _) =>
                charts.ColorUtil.fromDartColor(despesa.cor),
              outsideLabelStyleAccessorFn: (Despesa despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
              labelAccessorFn: (Despesa despesa, _) =>
                  despesa.valorEmString())
    ];
  }

  static Widget graficoDeBarrasReceita(List<Receita> receitas, int codigoMunicipio, String nomeMunicipio, BuildContext context){
    return new charts.BarChart(
      gerarSeriesReceita(receitas, codigoMunicipio),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      vertical: false,
      // barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if(model.hasDatumSelection){  

              Receita receita = Receita(
                int.parse(model.selectedSeries[0].id) , 
                int.parse(model.selectedSeries[0].domainFn(model.selectedDatum[0].index)),
                model.selectedSeries[0].measureFn(model.selectedDatum[0].index),
                null, null, null
              );
              ControllerTelaMunicipio.abrirTelaReceitas(context, receita, nomeMunicipio);
            }
          }
        )
      ],
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
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
    );
  }

  static Widget graficoDePizzaReceita(List<Receita> receitas, int codigoMunicipio){
    return new charts.PieChart(
      gerarSeriesReceita(receitas, codigoMunicipio),
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

  static Widget graficoDeColunasReceita(List<Receita> receitas, int codigoMunicipio){
    return new charts.BarChart(
      gerarSeriesReceita(receitas, codigoMunicipio),
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

  static Widget graficoDeBarrasDespesa(List<Despesa> despesas, int codigoMunicipio, String nomeMunicipio, BuildContext context){
    return new charts.BarChart(
      gerarSeriesDespesa(despesas, codigoMunicipio),
      animate: true,
      animationDuration: Duration(seconds: 1), 
      vertical: false,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if(model.hasDatumSelection){
              int index = model.selectedDatum[0].index;
              ControllerTelaMunicipio.abrirTelaDespesas(context, despesas[index], nomeMunicipio);
            }
          }
        )
      ],
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

  static Widget graficoDePizzaDespesa(List<Despesa> despesas, int codigoMunicipio){
    
    return new charts.PieChart(
      gerarSeriesDespesa(despesas, codigoMunicipio),
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

  static Widget graficoDeColunasDespesa(List<Despesa> despesas, int codigoMunicipio){
    return new charts.BarChart(
      gerarSeriesDespesa(despesas, codigoMunicipio),
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