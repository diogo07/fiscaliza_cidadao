import 'dart:convert';
import 'package:fiscaliza_cidadao/model/classificacao_despesa_moeda.dart';
import 'package:fiscaliza_cidadao/model/classificacao_despesa_porcentagem.dart';
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import 'app_bar.dart';

class TelaComparativoDespesaMunicipios extends StatefulWidget {
  Municipio primeiroMunicipio, segundoMunicipio;
  int ano;

  TelaComparativoDespesaMunicipios(
      this.primeiroMunicipio, this.segundoMunicipio, this.ano);

  _TelaComparativoDespesaMunicipios createState() =>
      _TelaComparativoDespesaMunicipios(
          this.primeiroMunicipio, this.segundoMunicipio, this.ano);
}

class _TelaComparativoDespesaMunicipios
    extends State<TelaComparativoDespesaMunicipios> {
  Municipio primeiroMunicipio, segundoMunicipio;
  int ano;
  List<ClassificacaoDespesaMoeda>
      listaClassificacaoDespesaMoedaPrimeiroMunicipio;
  List<ClassificacaoDespesaMoeda>
      listaClassificacaoDespesaMoedaSegundoMunicipio;
  List<ClassificacaoDespesaPorcentagem>
      listaClassificacaoDespesaPorcentagemPrimeiroMunicipio;
  List<ClassificacaoDespesaPorcentagem>
      listaClassificacaoDespesaPorcentagemSegundoMunicipio;
  Widget grafico;

  _TelaComparativoDespesaMunicipios(
      this.primeiroMunicipio, this.segundoMunicipio, this.ano);

  @override
  void initState() {
    grafico = componentePreLoading();
    listaClassificacaoDespesaMoedaPrimeiroMunicipio =
        new List<ClassificacaoDespesaMoeda>();
    listaClassificacaoDespesaMoedaSegundoMunicipio =
        new List<ClassificacaoDespesaMoeda>();
    listaClassificacaoDespesaPorcentagemPrimeiroMunicipio =
        new List<ClassificacaoDespesaPorcentagem>();
    listaClassificacaoDespesaPorcentagemSegundoMunicipio =
        new List<ClassificacaoDespesaPorcentagem>();
    buscarDespesasMunicipios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(children: <Widget>[
      new GradientAppBarBack('Comparativo Despesas'),
      new Expanded(
          child: new ListView(shrinkWrap: true, children: <Widget>[
        Center(
            child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.all(10),
                child: Text(
                    primeiroMunicipio.nome +
                        '-' +
                        primeiroMunicipio.uf +
                        ' / ' +
                        segundoMunicipio.nome +
                        '-' +
                        segundoMunicipio.uf,
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
                  'Despesas de ' + ano.toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.black87),
                ),
              )
            ],
          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.9 : MediaQuery.of(context).size.height * 1.9,
                    child: new Padding(
                        padding: new EdgeInsets.all(20), child: grafico))
              ])
        ]))
      ]))
    ]));
  }

  void buscarDespesasMunicipios() async {
    final response = await http.get(Utils.api +
        'despesa/funcao/municipio/' +
        primeiroMunicipio.codigo.toString() +
        '/ano/' +
        ano.toString());

    if (response.statusCode == 200) {
      List<dynamic> dadosPrimeiroMunicipio = jsonDecode(response.body);
      List<dynamic> listaPrimeiroMunicipio =
          dadosPrimeiroMunicipio[0]['despesas'];
      int count = 0;
      listaPrimeiroMunicipio.forEach((despesa) {
        if (count < 20) {
          listaClassificacaoDespesaMoedaPrimeiroMunicipio.add(
            new ClassificacaoDespesaMoeda(ano, despesa['valor'],
                despesa['funcao'].toString(), Colors.teal),
          );
          listaClassificacaoDespesaPorcentagemPrimeiroMunicipio.add(
              new ClassificacaoDespesaPorcentagem(
                  ano,
                  ((despesa['valor']) /
                          calcDespesaTotal(listaPrimeiroMunicipio)) *
                      100,
                  despesa['funcao'].toString(),
                  Colors.teal));
          count++;
        }
      });

      final resposta = await http.get(Utils.api +
          'despesa/funcao/municipio/' +
          segundoMunicipio.codigo.toString() +
          '/ano/' +
          ano.toString());
      if (resposta.statusCode == 200) {
        List<dynamic> dadosSegundoMunicipio = jsonDecode(resposta.body);
        List<dynamic> listaSegundoMunicipio =
            dadosSegundoMunicipio[0]['despesas'];
        count = 0;
        listaSegundoMunicipio.forEach((despesa) {
          if (count < 20) {
            listaClassificacaoDespesaMoedaSegundoMunicipio.add(
              new ClassificacaoDespesaMoeda(ano, despesa['valor'],
                  despesa['funcao'].toString(), Colors.indigo)
            );
            listaClassificacaoDespesaPorcentagemSegundoMunicipio.add(
                new ClassificacaoDespesaPorcentagem(
                    ano,
                    ((despesa['valor']) /
                            calcDespesaTotal(listaSegundoMunicipio)) *
                        100,
                    despesa['funcao'].toString(),
                    Colors.indigo));
            count++;
          }
        });

        setState(() {
          grafico = graficoClassificacaoDespesasMoeda();
        });
      }
    }
  }

  Widget graficoClassificacaoDespesasMoeda() {
    return new charts.BarChart(
      gerarSeriesClassificacaoDespesaMoeda(),
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: false,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
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

  List<charts.Series<ClassificacaoDespesaMoeda, String>>
      gerarSeriesClassificacaoDespesaMoeda() {
    return [
      new charts.Series<ClassificacaoDespesaMoeda, String>(
          id: primeiroMunicipio.nome,
          domainFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.tipo,
          measureFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.valor,
          data: listaClassificacaoDespesaMoedaPrimeiroMunicipio,
          insideLabelStyleAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.ColorUtil.fromDartColor(despesa.cor),
          labelAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              despesa.valorEmString()),
      new charts.Series<ClassificacaoDespesaMoeda, String>(
          id: segundoMunicipio.nome,
          domainFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.tipo,
          measureFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.valor,
          data: listaClassificacaoDespesaMoedaSegundoMunicipio,
          insideLabelStyleAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              charts.ColorUtil.fromDartColor(despesa.cor),
          labelAccessorFn: (ClassificacaoDespesaMoeda despesa, _) =>
              despesa.valorEmString())
    ];
  }

  calcDespesaTotal(List listaPrimeiroMunicipio) {
    double valor = 0.0;
    listaPrimeiroMunicipio.forEach((r) {
      valor += r['valor'];
    });

    return valor;
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
}
