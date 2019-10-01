import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:fiscaliza_cidadao/model/classificacao_receita_moeda.dart';
import 'package:fiscaliza_cidadao/model/classificacao_receita_porcentagem.dart';
import 'package:http/http.dart' as http;
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

class TelaComparativoReceitaMunicipios extends StatefulWidget {
  Municipio primeiroMunicipio, segundoMunicipio;
  int ano;

  TelaComparativoReceitaMunicipios(
      this.primeiroMunicipio, this.segundoMunicipio, this.ano);

  @override
  _TelaComparativoReceitaMunicipios createState() =>
      new _TelaComparativoReceitaMunicipios(
          this.primeiroMunicipio, this.segundoMunicipio, this.ano);
}

class _TelaComparativoReceitaMunicipios
    extends State<TelaComparativoReceitaMunicipios> {
  Municipio primeiroMunicipio, segundoMunicipio;
  int ano;
  List<ClassificacaoReceitaMoeda>
      listaClassificacaoReceitaMoedaPrimeiroMunicipio;
  List<ClassificacaoReceitaMoeda>
      listaClassificacaoReceitaMoedaSegundoMunicipio;
  List<ClassificacaoReceitaPorcentagem>
      listaClassificacaoReceitaPorcentagemPrimeiroMunicipio;
  List<ClassificacaoReceitaPorcentagem>
      listaClassificacaoReceitaPorcentagemSegundoMunicipio;
  Widget grafico;
  String tipoFuncaoPrimeiroMunicipio, tipoFuncaoSegundoMunicipio;

  _TelaComparativoReceitaMunicipios(
      this.primeiroMunicipio, this.segundoMunicipio, this.ano);

  @override
  void initState() {
    
    tipoFuncaoPrimeiroMunicipio = '';
    tipoFuncaoSegundoMunicipio = '';
    grafico = componentePreLoading();
    listaClassificacaoReceitaMoedaPrimeiroMunicipio =
        new List<ClassificacaoReceitaMoeda>();
    listaClassificacaoReceitaMoedaSegundoMunicipio =
        new List<ClassificacaoReceitaMoeda>();
    listaClassificacaoReceitaPorcentagemPrimeiroMunicipio =
        new List<ClassificacaoReceitaPorcentagem>();
    listaClassificacaoReceitaPorcentagemSegundoMunicipio =
        new List<ClassificacaoReceitaPorcentagem>();
    buscarReceitasMunicipios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(children: <Widget>[
      new GradientAppBarBack('Comparativo Receitas'),
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
                  'Receitas de ' + ano.toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.black87),
                ),
              )
            ],
          ),

           Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 40, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\t '+ textoMunicipios(tipoFuncaoPrimeiroMunicipio, tipoFuncaoSegundoMunicipio)+'.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 1.0,
                    child: new Padding(
                        padding: new EdgeInsets.all(20), child: grafico))
              ])
        ]))
      ]))
    ]));
  }

  void buscarReceitasMunicipios() async {
    final response = await http.get(Utils.api +
        'receita/funcao/municipio/' +
        primeiroMunicipio.codigo.toString() +
        '/ano/' +
        ano.toString());

    if (response.statusCode == 200) {
      List<dynamic> dadosPrimeiroMunicipio = jsonDecode(response.body);
      List<dynamic> listaPrimeiroMunicipio =
          dadosPrimeiroMunicipio[0]['despesas'];
      listaPrimeiroMunicipio.forEach((receita) {
        listaClassificacaoReceitaMoedaPrimeiroMunicipio.add(
          new ClassificacaoReceitaMoeda(ano, receita['valor'],
              receita['funcao'].toString(), Colors.teal),
        );
        listaClassificacaoReceitaPorcentagemPrimeiroMunicipio.add(
            new ClassificacaoReceitaPorcentagem(
                ano,
                ((receita['valor']) /
                        calcReceitaTotal(listaPrimeiroMunicipio)) *
                    100,
                receita['funcao'].toString(),
                Colors.teal));
      });

      final resposta = await http.get(Utils.api +
          'receita/funcao/municipio/' +
          segundoMunicipio.codigo.toString() +
          '/ano/' +
          ano.toString());
      if (resposta.statusCode == 200) {
        List<dynamic> dadosSegundoMunicipio = jsonDecode(resposta.body);
        List<dynamic> listaSegundoMunicipio =
            dadosSegundoMunicipio[0]['despesas'];
            
        listaSegundoMunicipio.forEach((receita) {
          listaClassificacaoReceitaMoedaSegundoMunicipio.add(
            new ClassificacaoReceitaMoeda(ano, receita['valor'],
                receita['funcao'].toString(), Colors.indigo),
          );
          listaClassificacaoReceitaPorcentagemSegundoMunicipio.add(
              new ClassificacaoReceitaPorcentagem(
                  ano,
                  ((receita['valor']) /
                          calcReceitaTotal(listaSegundoMunicipio)) *
                      100,
                  receita['funcao'].toString(),
                  Colors.indigo));
        });

        setState(() {
          tipoFuncaoPrimeiroMunicipio = listaPrimeiroMunicipio[0]['funcao'].toString();
          tipoFuncaoSegundoMunicipio = listaSegundoMunicipio[0]['funcao'].toString();
          grafico = graficoClassificacaoReceitasMoeda();
        });
      }
    }
  }


  Widget graficoClassificacaoReceitasMoeda() {
    return new charts.BarChart(
      gerarSeriesClassificacaoReceitaMoeda(),
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

  List<charts.Series<ClassificacaoReceitaMoeda, String>> gerarSeriesClassificacaoReceitaMoeda() {
    return [
      new charts.Series<ClassificacaoReceitaMoeda, String>(
          id: primeiroMunicipio.nome,
          domainFn: (ClassificacaoReceitaMoeda receita, _) => receita.getTipo(),
          measureFn: (ClassificacaoReceitaMoeda receita, _) =>
              receita.valor,
          data: listaClassificacaoReceitaMoedaPrimeiroMunicipio,
          insideLabelStyleAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.ColorUtil.fromDartColor(receita.cor),
          labelAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              receita.valorEmString()
              ),


      new charts.Series<ClassificacaoReceitaMoeda, String>(
          id: segundoMunicipio.nome,
          domainFn: (ClassificacaoReceitaMoeda receita, _) => receita.getTipo(),
          measureFn: (ClassificacaoReceitaMoeda receita, _) =>
              receita.valor,
          data: listaClassificacaoReceitaMoedaSegundoMunicipio,
          insideLabelStyleAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoReceitaMoeda receita, _) =>
              charts.ColorUtil.fromDartColor(receita.cor),
          labelAccessorFn: (ClassificacaoReceitaMoeda receita, _) =>
              receita.valorEmString()
              )
    ];
  }

  calcReceitaTotal(List listaPrimeiroMunicipio) {
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

  String textoMunicipios(String tipoFuncaoPrimeiroMunicipio, String tipoFuncaoSegundoMunicipio){
    if(tipoFuncaoPrimeiroMunicipio == '' && tipoFuncaoPrimeiroMunicipio == tipoFuncaoSegundoMunicipio){
      return "";
    }else if(tipoFuncaoPrimeiroMunicipio != '' && tipoFuncaoPrimeiroMunicipio == tipoFuncaoSegundoMunicipio){
      return "Tanto a arrecadação do município de "+primeiroMunicipio.nome+", quanto de "+segundoMunicipio.nome+" vem em sua maior parte de "+tipoFuncaoPrimeiroMunicipio+", que são formadas pelos recursos arrecadados que incrementam o patrimônio do Estado como prestação de serviços, atividades industriais, e os impostos, taxas e contribuições que pagamos.";
    }else{
      return "";
    }
  }
}
