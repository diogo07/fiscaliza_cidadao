import 'package:fiscaliza_cidadao/model/classificacao_despesa_moeda.dart';
import 'package:fiscaliza_cidadao/model/classificacao_despesa_porcentagem.dart';
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaDespesaMunicipio extends StatefulWidget {
  Despesa despesa;
  String nome;

  TelaDespesaMunicipio(Despesa despesa, String nome) {
    this.despesa = despesa;
    this.nome = nome;
  }

  @override
  _TelaDespesaMunicipio createState() =>
      new _TelaDespesaMunicipio(this.despesa, this.nome);
}

class _TelaDespesaMunicipio extends State<TelaDespesaMunicipio> {
  Despesa despesa;
  String nome;
  bool moedaSelect = true;
  List<ClassificacaoDespesaMoeda> listaClassificacaoDespesaMoeda;
  List<ClassificacaoDespesaPorcentagem> listaClassificacaoDespesaPorcentagem;
  List<Widget> graficos;
  Widget graficoDespesasLiquidadas;

  _TelaDespesaMunicipio(Despesa despesa, String nome) {
    this.despesa = despesa;
    this.nome = nome;
  }

  @override
  void initState() {
    graficoDespesasLiquidadas = componentePreLoading();
    listaClassificacaoDespesaMoeda = new List<ClassificacaoDespesaMoeda>();
    listaClassificacaoDespesaPorcentagem =
        new List<ClassificacaoDespesaPorcentagem>();
    graficos = new List<Widget>();
    buscarDespesas(this.despesa.codigo.toString(), this.despesa.ano.toString());
    moedaSelect = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(children: <Widget>[
      new GradientAppBarBack(this.nome),
      new Expanded(
          child: new ListView(shrinkWrap: true, children: <Widget>[
        new Center(
          child: new Column(
            children: <Widget>[
              moedaSelect
                  ? componenteMenuDados(Colors.cyan, Colors.white)
                  : componenteMenuDados(Colors.white, Colors.cyan),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 40),
                    child: FittedBox(
                      fit:BoxFit.fitWidth,                    
                      child:new Text(
                        classificacaoDespesas(despesa.classificacao)+': R\$ ' + despesa.valorEmString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    )
                  )
                ],
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 1.2 : MediaQuery.of(context).size.height * 1.9,
                        child: new Padding(
                            padding: new EdgeInsets.all(20),
                            child: graficoDespesasLiquidadas))
                  ])
            ],
          ),
        ),
      ]))
    ]));
  }

  buscarDespesas(String codigo, String ano) async {
    final response = await http
        .get(Utils.api + 'despesa/funcao/municipio/' + codigo + '/ano/' + ano);
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);

      List<dynamic> despesas = dados[0]['despesas'];
      int i = 0;
      despesas.forEach((despesa) {
        if (despesa['classificacao'] == this.despesa.classificacao) {
          listaClassificacaoDespesaMoeda.add(
            new ClassificacaoDespesaMoeda(int.parse(ano), despesa['valor'],
                despesa['funcao'].toString(), getCor(i)),
          );
          listaClassificacaoDespesaPorcentagem.add(
            new ClassificacaoDespesaPorcentagem(
                int.parse(ano),
                ((despesa['valor']) / this.despesa.valor) * 100,
                despesa['funcao'].toString(),
                getCor(i)),
          );

          i++;
        }
      });

      setState(() {
        graficoDespesasLiquidadas = graficoDeBarrasClassificacaoDespesaMoeda(
            listaClassificacaoDespesaMoeda, this.despesa.codigo);
      });
    } else {
      print('Failed to load post');
    }
  }

  void setMoedaSelect(bool value) {
    setState(() {
      moedaSelect = value;
      if (value) {
        graficoDespesasLiquidadas = graficoDeBarrasClassificacaoDespesaMoeda(
            listaClassificacaoDespesaMoeda, despesa.codigo);
      } else {
        graficoDespesasLiquidadas =
            graficoDeBarrasClassificacaoDespesaPorcentagem(
                listaClassificacaoDespesaPorcentagem, despesa.codigo);
      }
    });
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

  Widget componenteMenuDados(Color color1, Color color2) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        componenteTitulo('Despesas de ' + this.despesa.ano.toString()),
        new InkWell(
          onTap: () {
            setMoedaSelect(true);
          },
          child: new Container(
            width: 40.0,
            height: 30.0,
            decoration: new BoxDecoration(
              color: color1,
              border: new Border.all(color: Colors.cyan, width: 1.0),
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: new Center(
              child: new Text(
                'R\$',
                style: new TextStyle(
                    fontSize: 14.0, fontFamily: 'Poppins', color: color2),
              ),
            ),
          ),
        ),
        new InkWell(
          onTap: () {
            setMoedaSelect(false);
          },
          child: new Container(
            width: 40.0,
            height: 30.0,
            margin: EdgeInsets.only(right: 20),
            decoration: new BoxDecoration(
              color: color2,
              border: new Border.all(color: Colors.cyan, width: 1.0),
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: new Center(
              child: new Text(
                '%',
                style: new TextStyle(
                    fontSize: 14.0, fontFamily: 'Poppins', color: color1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget componenteTitulo(String titulo) {
    return Expanded(
        flex: 8,
        child: Padding(
          padding: EdgeInsets.only(left: 40),
          child: new Text(
            titulo,
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, color: Colors.black45),
          ),
        ));
  }

  

  Widget graficoDeBarrasClassificacaoDespesaMoeda(
      List<ClassificacaoDespesaMoeda> despesas, int codigoMunicipio) {

    return new charts.BarChart(
      gerarSeriesClassificacaoDespesaMoeda(despesas, codigoMunicipio),
      animate: true,
      animationDuration: Duration(seconds: 1),
      vertical: false,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
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
        // lineStyle: new charts.LineStyleSpec(
        //     color: charts.MaterialPalette.black)
      )),
    );
  }

  Widget graficoDeBarrasClassificacaoDespesaPorcentagem(
      List<ClassificacaoDespesaPorcentagem> despesas, int codigoMunicipio) {
    return new charts.BarChart(
      gerarSeriesClassificacaoDespesaPorPorcentagem(despesas, codigoMunicipio),
      animate: true,
      animationDuration: Duration(seconds: 1),
      vertical: false,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30),
          barRendererDecorator: new charts.BarLabelDecorator<String>(),      
      ),
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
        // lineStyle: new charts.LineStyleSpec(
        //     color: charts.MaterialPalette.black)
      )),
    );
  }

  List<charts.Series<ClassificacaoDespesaMoeda, String>>
      gerarSeriesClassificacaoDespesaMoeda(
          List<ClassificacaoDespesaMoeda> despesas, int codigoMunicipio) {
    return [
      new charts.Series<ClassificacaoDespesaMoeda, String>(
          id: codigoMunicipio.toString(),
          domainFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.tipo,
          measureFn: (ClassificacaoDespesaMoeda despesa, _) => despesa.valor,
          data: despesas,
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

  List<charts.Series<ClassificacaoDespesaPorcentagem, String>>
      gerarSeriesClassificacaoDespesaPorPorcentagem(
          List<ClassificacaoDespesaPorcentagem> despesas, int codigoMunicipio) {
    return [
      new charts.Series<ClassificacaoDespesaPorcentagem, String>(
          id: codigoMunicipio.toString(),
          domainFn: (ClassificacaoDespesaPorcentagem d, _) => d.tipo,
          measureFn: (ClassificacaoDespesaPorcentagem d, _) => d.valor,
          data: despesas,
          insideLabelStyleAccessorFn: (ClassificacaoDespesaPorcentagem d, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoDespesaPorcentagem d, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoDespesaPorcentagem d, _) =>
              charts.ColorUtil.fromDartColor(d.cor),
          labelAccessorFn: (ClassificacaoDespesaPorcentagem d, _) =>
              ' ${d.formatPorcentagem()}%')
    ];
  }

  String classificacaoDespesas(String tipo) {
      print(tipo);

      if(tipo == 'Despesas Empenhadas'){
        return "Valor Total Empenhado";
      }

      else if(tipo == 'Despesas Liquidadas'){
        return "Valor Total Liquidado";
      }

      else if(tipo == 'Despesas Pagas'){
        return "Valor Total Pago";
      }

      else{
        return "Total Restos a Pagar";
      }  
  }

  Color getCor(int index) {
    final list = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.grey,
      Colors.indigo,
      Colors.orange,
      Colors.orangeAccent,
      Colors.pink,
      Colors.teal,
    ];

    list.shuffle();

    if (list.length - 1 >= index) {
      return list[index];
    } else {
      return list[0];
    }
  }
}
