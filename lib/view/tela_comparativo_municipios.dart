import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fiscaliza_cidadao/controller/controller_tela_comparativo_municipios.dart';
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaComparativoMunicipios extends StatefulWidget {
  Municipio primeiroMunicipio, segundoMunicipio;

  TelaComparativoMunicipios(
      Municipio primeiroMunicipio, Municipio segundoMunicipio) {
    this.primeiroMunicipio = primeiroMunicipio;
    this.segundoMunicipio = segundoMunicipio;
  }

  _TelaComparativoMunicipios createState() => new _TelaComparativoMunicipios(
      this.primeiroMunicipio, this.segundoMunicipio);
}

class _TelaComparativoMunicipios extends State<TelaComparativoMunicipios> {
  Municipio primeiroMunicipio, segundoMunicipio;
  List<Receita> receitasPrimeiroMunicipio, receitasSegundoMunicipio;
  List<Despesa> despesasPrimeiroMunicipio, despesasSegundoMunicipio;
  Widget graficoReceitas, graficoDespesas;

  _TelaComparativoMunicipios(
      Municipio primeiroMunicipio, Municipio segundoMunicipio) {
    this.primeiroMunicipio = primeiroMunicipio;
    this.segundoMunicipio = segundoMunicipio;
  }

  @override
  void initState() {
    receitasPrimeiroMunicipio = new List<Receita>();
    receitasSegundoMunicipio = new List<Receita>();
    despesasPrimeiroMunicipio = new List<Despesa>();
    despesasSegundoMunicipio = new List<Despesa>();
    graficoReceitas = componentePreLoading();
    graficoDespesas = componentePreLoading();
    buscarReceitasMunicipios();
    buscarDespesasMunicipios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(children: <Widget>[
      new GradientAppBarBack('Comparativo Municípios'),
      new Expanded(
          child: new ListView(shrinkWrap: true, children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: new EdgeInsets.all(10),
                  child: Text(
                      primeiroMunicipio.nome + '-'+primeiroMunicipio.uf+' / ' + segundoMunicipio.nome+'-'+segundoMunicipio.uf,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black87)),
                ),
              ],
            ),
            Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(20),
                    child: new Text(
                      'Receitas',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.black87),
                    ),
                  )
                ],
              ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 1.2,
                      child: new Padding(
                          padding: new EdgeInsets.all(20),
                          child: graficoReceitas))
                ]),
            
            Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(20),
                    child: new Text(
                      'Despesas',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.black87),
                    ),
                  )
                ],
              ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 1.2,
                      child: new Padding(
                          padding: new EdgeInsets.all(20),
                          child: graficoDespesas))
                ])
          ],
        ))
      ]))
    ]));
  }

  void buscarReceitasMunicipios() async {
    final response = await http.get(
        Utils.api + 'receita/municipio/' + primeiroMunicipio.codigo.toString());
    if (response.statusCode == 200) {
      List<dynamic> dadosPrimeiroMunicipio = jsonDecode(response.body);
      List<dynamic> listaPrimeiroMunicipio =
          dadosPrimeiroMunicipio[0]['receitas'];
      listaPrimeiroMunicipio.forEach((receita) {
        receitasPrimeiroMunicipio.add(new Receita(primeiroMunicipio.codigo,
            receita['ano'], receita['valor'], null, null, Colors.teal));
      });

      final resposta = await http.get(Utils.api +
          'receita/municipio/' +
          segundoMunicipio.codigo.toString());
      if (resposta.statusCode == 200) {
        List<dynamic> dadosSegundoMunicipio = jsonDecode(resposta.body);
        List<dynamic> listaSegundoMunicipio =
            dadosSegundoMunicipio[0]['receitas'];
        listaSegundoMunicipio.forEach((receita) {
          receitasSegundoMunicipio.add(new Receita(segundoMunicipio.codigo,
              receita['ano'], receita['valor'], null, null, Colors.indigo));
        });

        setState(() {
          graficoReceitas = graficoDeReceitas();
        });
      }
    }
  }

  void buscarDespesasMunicipios() async {
    final response = await http.get(
        Utils.api + 'despesa/municipio/' + primeiroMunicipio.codigo.toString());
    if (response.statusCode == 200) {
      List<dynamic> dadosPrimeiroMunicipio = jsonDecode(response.body);
      List<dynamic> listaPrimeiroMunicipio = dadosPrimeiroMunicipio[0]['despesas'];
      listaPrimeiroMunicipio.forEach((despesa) {
        if(despesa['classificacao'] == 'Despesas Liquidadas'){
          despesasPrimeiroMunicipio.add(new Despesa(primeiroMunicipio.codigo, despesa['ano'], despesa['valor'], null, null, Colors.teal));
        }
      });

      final resposta = await http.get(Utils.api +
          'despesa/municipio/' +
          segundoMunicipio.codigo.toString());
      if (resposta.statusCode == 200) {
        List<dynamic> dadosSegundoMunicipio = jsonDecode(resposta.body);
        List<dynamic> listaSegundoMunicipio =
            dadosSegundoMunicipio[0]['despesas'];
        listaSegundoMunicipio.forEach((despesa) {
          if(despesa['classificacao'] == 'Despesas Liquidadas'){
            despesasSegundoMunicipio.add(new Despesa(segundoMunicipio.codigo,
              despesa['ano'], despesa['valor'], null, null, Colors.indigo));
          }
        });

        setState(() {
          graficoDespesas = graficoDeDespesas();
        });
      }
    }
  }

  Widget graficoDeReceitas() {
    return new charts.BarChart(
      gerarSeriesReceita(),
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          // barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
      barGroupingType: charts.BarGroupingType.grouped,
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if(model.hasDatumSelection){
              int index = model.selectedDatum[0].index;
              ControllerTelaComparativoMunicipios.abrirTelaComparativoReceitasMunicipios(context, primeiroMunicipio, segundoMunicipio, receitasPrimeiroMunicipio[index].ano);
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
      behaviors: [
        new charts.SeriesLegend(
          defaultHiddenSeries: ['Other'],
          entryTextStyle: charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
        )
      ],
    );
  }

  Widget graficoDeDespesas() {
    return new charts.BarChart(
      gerarSeriesDespesa(),
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30), 
      ),
      barGroupingType: charts.BarGroupingType.grouped,
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if(model.hasDatumSelection){
              int index = model.selectedDatum[0].index;
              ControllerTelaComparativoMunicipios.abrirTelaComparativoDespesasMunicipios(context, primeiroMunicipio, segundoMunicipio, despesasPrimeiroMunicipio[index].ano);
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
      behaviors: [
        new charts.SeriesLegend(
          defaultHiddenSeries: ['Other'],
          entryTextStyle: charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
        )
      ],
    );
  }

  Widget componentePreLoading() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new CircularProgressIndicator(),
      ],
    );
  }

  List<charts.Series<Receita, String>> gerarSeriesReceita() {
    return [
      new charts.Series<Receita, String>(
          id: primeiroMunicipio.nome,
          domainFn: (Receita receita, _) => receita.ano.toString(),
          measureFn: (Receita receita, _) => receita.valor,
          data: receitasPrimeiroMunicipio,
          insideLabelStyleAccessorFn: (Receita receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (Receita receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
          colorFn: (Receita receita, _) =>
              charts.ColorUtil.fromDartColor(receita.cor),
          labelAccessorFn: (Receita receita, _) => receita.valorEmString()
      ),
      new charts.Series<Receita, String>(
          id: segundoMunicipio.nome,
          domainFn: (Receita receita, _) => receita.ano.toString(),
          measureFn: (Receita receita, _) => receita.valor,
          data: receitasSegundoMunicipio,
          insideLabelStyleAccessorFn: (Receita receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (Receita receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
          colorFn: (Receita receita, _) =>
              charts.ColorUtil.fromDartColor(receita.cor),
          labelAccessorFn: (Receita receita, _) => receita.valorEmString()
      )
    ];
  }


  List<charts.Series<Despesa, String>> gerarSeriesDespesa() {
    return [
      new charts.Series<Despesa, String>(
          id: primeiroMunicipio.nome,
          domainFn: (Despesa despesa, _) => despesa.ano.toString(),
          measureFn: (Despesa despesa, _) => despesa.valor,
          data: despesasPrimeiroMunicipio,
          insideLabelStyleAccessorFn: (Despesa despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (Despesa despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
          colorFn: (Despesa despesa, _) =>
              charts.ColorUtil.fromDartColor(despesa.cor),
          labelAccessorFn: (Despesa despesa, _) => despesa.valorEmString()
      ),
      new charts.Series<Despesa, String>(
          id: segundoMunicipio.nome,
          domainFn: (Despesa despesa, _) => despesa.ano.toString(),
          measureFn: (Despesa despesa, _) => despesa.valor,
          data: despesasSegundoMunicipio,
          insideLabelStyleAccessorFn: (Despesa despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (Despesa despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
          colorFn: (Despesa despesa, _) =>
              charts.ColorUtil.fromDartColor(despesa.cor),
          labelAccessorFn: (Despesa despesa, _) => despesa.valorEmString()
      )
    ];
  }
}
