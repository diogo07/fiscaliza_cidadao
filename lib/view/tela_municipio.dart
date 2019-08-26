import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:fiscaliza_cidadao/view/graficos.dart';
import 'package:flutter/cupertino.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaMunicipio extends StatefulWidget {
  int codigo;
  String nome;

  TelaMunicipio(int codigo, String nome) {
    this.codigo = codigo;
    this.nome = nome;
  }

  @override
  _TelaMunicipio createState() => new _TelaMunicipio(this.codigo, this.nome);
}

class _TelaMunicipio extends State<TelaMunicipio> {
  int codigo;
  String nome;
  List<Receita> listaReceitas;
  List<Despesa> listaDespesas;
  List<charts.Series<Receita, String>> seriesReceitas;
  List<charts.Series<Despesa, String>> seriesDespesas;
  Widget graficoReceitasAnuais,
      graficoDespesasAnuais,
      graficoReceitasDespesasAnuais;

  _TelaMunicipio(int codigo, String nome) {
    this.codigo = codigo;
    this.nome = nome;
  }

  @override
  void initState() {
    graficoReceitasAnuais = new Container(width: 10, height: 10);
    listaReceitas = new List<Receita>();
    listaDespesas = new List<Despesa>();
    seriesReceitas = new List<charts.Series<Receita, String>>();
    buscarReceitas(this.codigo.toString());
    buscarDespesas(this.codigo.toString());
    super.initState();
  }

  buscarReceitas(String query) async {
    final response = await http
        .get('http://api.carlosecelso.com.br/api/receita/municipio/' + query);
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);
      // List<dynamic> receitas = dados[0]['receitas'];
      // receitas.forEach((receita){
      //   listaReceitas.add(new Receita(int.parse(query), 2017, dados[0]['receitas'][3]['2017'],
      //       null, null, Colors.green));
      // });

      print(dados);

      try{
        listaReceitas.add(new Receita(int.parse(query), 2014, dados[0]['receitas'][0]['2014'],
            null, null, Colors.green));
      } on RangeError catch(e){
        listaReceitas.add(new Receita(int.parse(query), 2014, 0.0,
            null, null, Colors.green));
      }

      try{
        listaReceitas.add(new Receita(int.parse(query), 2015, dados[0]['receitas'][0]['2015'],
            null, null, Colors.green));
      } on RangeError catch(e){
        listaReceitas.add(new Receita(int.parse(query), 2015, 0.0,
            null, null, Colors.green));
      }

      try{
        listaReceitas.add(new Receita(int.parse(query), 2016, dados[0]['receitas'][0]['2016'],
            null, null, Colors.green));
      } on RangeError catch(e){
        listaReceitas.add(new Receita(int.parse(query), 2016, 0.0,
            null, null, Colors.green));
      }

      try{
        listaReceitas.add(new Receita(int.parse(query), 2017, dados[0]['receitas'][0]['2017'],
            null, null, Colors.green));
      } on RangeError catch(e){
        listaReceitas.add(new Receita(int.parse(query), 2017, 0.0,
            null, null, Colors.green));
      }

      try{
        listaReceitas.add(new Receita(int.parse(query), 2018, dados[0]['receitas'][0]['2018'],
            null, null, Colors.green));
      } on RangeError catch(e){
        listaReceitas.add(new Receita(int.parse(query), 2018, 0.0,
            null, null, Colors.green));
      }

      setState(() {
        graficoReceitasAnuais = Graficos.graficoDeColunasReceita(listaReceitas);
      });
    } else {
      print('Failed to load post');
    }
  }

  buscarDespesas(String query) async {
    final response = await http
        .get('http://api.carlosecelso.com.br/api/despesa/municipio/' + query);
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);

      List<dynamic> despesas = dados[0]['despesas'];
      
      despesas.forEach((despesa){
        if(despesa['classificacao'] == 'Despesas Liquidadas'){
          listaDespesas.add(new Despesa(int.parse(query), despesa['ano'], despesa['valor'],
            null, null, Colors.red),);
        }
      });

      setState(() {
        graficoDespesasAnuais = Graficos.graficoDeColunasDespesa(listaDespesas);
      });
    } else {
      print('Failed to load post');
    }
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  componenteTitulo('Receitas Anuais'),
                  componenteMenuGrafico(1),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(
                              top: 40),
                    child: new Text(
                      'Valores em milhões',
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
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: new Padding(
                          padding: new EdgeInsets.only(
                              top: 0, bottom: 40, left: 40, right: 40),
                          child: graficoReceitasAnuais,
                        ))
                  ])
            ],
          ),
        ),

        new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  componenteTitulo('Despesas Anuais'),
                  componenteMenuGrafico(2),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(
                              top: 40),
                    child: new Text(
                      'Valores em milhões',
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
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: new Padding(
                          padding: new EdgeInsets.all(40),
                          child: graficoDespesasAnuais,
                        ))
                  ])
            ],
          ),
        ),

        // new Center(
        //   child: new Column(
        //     children: <Widget>[

        //       new Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: <Widget>[
        //           Expanded(
        //             flex: 8,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 40),
        //               child: new Text(
        //                 'Receitas x Despesas',
        //                 style: TextStyle(
        //                   fontFamily: 'Poppins',
        //                   fontSize: 18,
        //                   color: Colors.black45
        //                 ),
        //               ),
        //             )
        //           ),

        //           Expanded(
        //             flex: 2,
        //             child: PopupMenuButton<int>(
        //               icon: new Icon(
        //                 Icons.insert_chart,
        //                 color: Colors.black45,
        //                 size: 30,
        //               ),
        //               // onSelected: (item) => mudarGraficoDespesasAnuais(item),
        //               itemBuilder: (context) => [
        //                 PopupMenuItem(
        //                   value: 1,
        //                   child: Text("Gráfico de Barras",
        //                     style: TextStyle(
        //                       fontFamily: 'Poppins',
        //                       fontSize: 15,
        //                       color: Colors.black87
        //                     ),
        //                   ),
        //                 ),
        //                 PopupMenuItem(
        //                   value: 2,
        //                   child: Text("Gráfico de Colunas",
        //                     style: TextStyle(
        //                       fontFamily: 'Poppins',
        //                       fontSize: 15,
        //                       color: Colors.black87
        //                     ),
        //                   ),
        //                 ),
        //                 PopupMenuItem(
        //                   value: 3,
        //                   child: Text("Gráfico de Linhas",
        //                     style: TextStyle(
        //                       fontFamily: 'Poppins',
        //                       fontSize: 15,
        //                       color: Colors.black87
        //                     ),
        //                   ),

        //                 ),
        //                 PopupMenuItem(
        //                   value: 4,
        //                   child: Text("Gráfico Pizza",
        //                     style: TextStyle(
        //                       fontFamily: 'Poppins',
        //                       fontSize: 15,
        //                       color: Colors.black87
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           )
        //         ],
        //       ),

        //       new Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: <Widget>[
        //           new SizedBox(
        //             width: MediaQuery.of(context).size.width,
        //             height: MediaQuery.of(context).size.height * 0.7,
        //             child: new Padding(
        //               padding: new EdgeInsets.all(40),
        //               child: graficoReceitasDespesasAnuais,

        //             )
        //           )
        //         ]
        //       )
        //     ],
        // ),
        // ),
      ]))
    ]));
  }

  void mudarGraficoReceitasAnuais(int item) {
    print(item);
    setState(() {
      switch (item) {
        case 1:
          graficoReceitasAnuais =
              Graficos.graficoDeBarrasReceita(listaReceitas);
          break;
        case 2:
          graficoReceitasAnuais =
              Graficos.graficoDeColunasReceita(listaReceitas);
          break;
        case 3:
          graficoReceitasAnuais = Graficos.graficoDePizzaReceita(listaReceitas);
          break;
        case 4:
          graficoReceitasAnuais = Graficos.graficoDePizzaReceita(listaReceitas);
          break;
      }
    });
  }

  void mudarGraficoDespesasAnuais(int item) {
    setState(() {
      switch (item) {
        case 1:
          graficoDespesasAnuais =
              Graficos.graficoDeBarrasDespesa(listaDespesas);
          break;
        case 2:
          graficoDespesasAnuais =
              Graficos.graficoDeColunasDespesa(listaDespesas);
          break;
        case 3:
          // graficoDespesasAnuais = graficoDeLinhas();
          break;
        case 4:
          graficoDespesasAnuais = Graficos.graficoDePizzaDespesa(listaDespesas);
          break;
      }
    });
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

  Widget componenteMenuGrafico(int numGrafico) {
    return Expanded(
      flex: 2,
      child: PopupMenuButton<int>(
        icon: new Icon(
          Icons.tune,
          color: Colors.black45,
          size: 30,
        ),
        onSelected: (item) => numGrafico == 1
            ? mudarGraficoReceitasAnuais(item)
            : mudarGraficoDespesasAnuais(item),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Gráfico de Barras",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Gráfico de Colunas",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              "Gráfico de Linhas",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Text(
              "Gráfico Pizza",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Widget graficoDeBarras(List<charts.Series<OrdinalSales, String>> dados){
  //   return new charts.BarChart(
  //     dados,
  //     animate: true,
  //     animationDuration: Duration(seconds: 1),

  //     vertical: false,
  //     barRendererDecorator: new charts.BarLabelDecorator<String>(),
  //     domainAxis: new charts.OrdinalAxisSpec(
  //         renderSpec: new charts.SmallTickRendererSpec(
  //             minimumPaddingBetweenLabelsPx: 0,
  //             labelStyle: new charts.TextStyleSpec(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 12, // size in Pts.
  //                 color: charts.MaterialPalette.black),

  //             lineStyle: new charts.LineStyleSpec(
  //                 color: charts.MaterialPalette.black))
  //     ),
  //     primaryMeasureAxis: new charts.NumericAxisSpec(
  //         renderSpec: new charts.GridlineRendererSpec(

  //             // Tick and Label styling here.
  //             labelStyle: new charts.TextStyleSpec(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 12, // size in Pts.
  //                 color: charts.MaterialPalette.black),

  //             // Change the line colors to match text color.
  //             lineStyle: new charts.LineStyleSpec(
  //                 color: charts.MaterialPalette.black))),

  //   );
  // }

  // Widget graficoDePizza(List<charts.Series<OrdinalSales, String>> dados){
  //   return new charts.PieChart(
  //     dados,
  //     animate: true,

  //     animationDuration: Duration(seconds: 1),

  //     behaviors: [
  //       new charts.DatumLegend(
  //         position: charts.BehaviorPosition.end,
  //         horizontalFirst: false,
  //         entryTextStyle: charts.TextStyleSpec(
  //           fontFamily: 'Poppins',
  //           fontSize: 12, // size in Pts.
  //           color: charts.MaterialPalette.black
  //         ),
  //         cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
  //         showMeasures: true,
  //         legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
  //         measureFormatter: (num value) {
  //           return value == null ? '-' : ' - ${value}k';
  //         },

  //       ),
  //     ],
  //   );
  // }

  // Widget graficoDeLinhas(){
  //   return new charts.LineChart(
  //     _dadosLinear(),
  //     animate: true,
  //     domainAxis: new charts.NumericAxisSpec(
  //         // Set the initial viewport by providing a new AxisSpec with the
  //         // desired viewport, in NumericExtents.
  //         viewport: new charts.NumericExtents(2014.0, 2017.0)),

  //     // Optionally add a pan or pan and zoom behavior.
  //     // If pan/zoom is not added, the viewport specified remains the viewport.
  //     behaviors: [new charts.PanAndZoomBehavior()],
  //   );

  // }

  // Widget graficoColunasReceita_Despesa(){

  //    return new charts.BarChart(
  //     _dadosTesteReceita_Despesa(listaReceitas, listaDespesas),
  //     animate: true,
  //     animationDuration: new Duration(seconds: 1),
  //     barGroupingType: charts.BarGroupingType.grouped,
  //     domainAxis: new charts.OrdinalAxisSpec(
  //         renderSpec: new charts.SmallTickRendererSpec(
  //             minimumPaddingBetweenLabelsPx: 0,
  //             labelStyle: new charts.TextStyleSpec(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 12, // size in Pts.
  //                 color: charts.MaterialPalette.black),

  //             lineStyle: new charts.LineStyleSpec(
  //                 color: charts.MaterialPalette.black))
  //     ),
  //     primaryMeasureAxis: new charts.NumericAxisSpec(
  //         renderSpec: new charts.GridlineRendererSpec(

  //             // Tick and Label styling here.
  //             labelStyle: new charts.TextStyleSpec(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 12, // size in Pts.
  //                 color: charts.MaterialPalette.black),

  //             // Change the line colors to match text color.
  //             lineStyle: new charts.LineStyleSpec(
  //                 color: charts.MaterialPalette.black))),
  //     behaviors: [
  //       new charts.SeriesLegend(
  //         entryTextStyle: charts.TextStyleSpec(
  //           fontFamily: 'Poppins',
  //           fontSize: 12, // size in Pts.
  //           color: charts.MaterialPalette.black
  //         ),
  //         defaultHiddenSeries: ['Other'],
  //       )
  //     ],
  //   );
  // }

  // static List<charts.Series<OrdinalSales, String>> _dadosTesteReceita(List<OrdinalSales> lista) {

  //   return [
  //     new charts.Series<OrdinalSales, String>(
  //         id: 'Sales',
  //         domainFn: (OrdinalSales sales, _) => sales.year,
  //         measureFn: (OrdinalSales sales, _) => sales.sales,
  //         data: lista,
  //         insideLabelStyleAccessorFn: (OrdinalSales sales, _) => charts.TextStyleSpec(
  //           fontFamily: 'Poppins',
  //                 fontSize: 12, // size in Pts.
  //                 color: charts.MaterialPalette.white
  //         ),
  //         colorFn: (OrdinalSales sales, _) =>
  //           charts.ColorUtil.fromDartColor(sales.color),
  //         // Set a label accessor to control the text of the bar label.
  //         labelAccessorFn: (OrdinalSales sales, _) =>
  //             'R\$ ${sales.sales.toString()}')
  //   ];
  // }

  // static List<charts.Series<OrdinalSales, String>> _dadosTesteDespesa() {
  //   final data = [
  //     new OrdinalSales('2014', 255, Colors.red),
  //     new OrdinalSales('2015', 274, Colors.blue),
  //     new OrdinalSales('2016', 258, Colors.indigo),
  //     new OrdinalSales('2017', 273, Colors.green),
  //   ];

  //   return [
  //     new charts.Series<OrdinalSales, String>(
  //         id: 'Sales',
  //         domainFn: (OrdinalSales sales, _) => sales.year,
  //         measureFn: (OrdinalSales sales, _) => sales.sales,
  //         data: data,
  //         colorFn: (OrdinalSales sales, _) =>
  //           charts.ColorUtil.fromDartColor(sales.color),
  //         // Set a label accessor to control the text of the bar label.
  //         labelAccessorFn: (OrdinalSales sales, _) =>
  //             '${sales.year}: \$${sales.sales.toString()}')
  //   ];
  // }

  // static List<charts.Series<LinearSales, int>> _dadosLinear() {

  //   final data = [
  //     new LinearSales(2014, 5),
  //     new LinearSales(2015, 25),
  //     new LinearSales(2016, 100),
  //     new LinearSales(2017, 75),
  //   ];

  //   return [
  //     new charts.Series<LinearSales, int>(
  //       id: 'Sales',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (LinearSales sales, _) => sales.year,
  //       measureFn: (LinearSales sales, _) => sales.sales,
  //       data: data,
  //     )
  //   ];

  // }

  // static List<charts.Series<OrdinalSales, String>> _dadosTesteReceita_Despesa(List<OrdinalSales> receitasList, List<OrdinalSales> despesasList) {

  //   return [
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Receitas',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //        colorFn: (OrdinalSales sales, _) =>
  //           charts.ColorUtil.fromDartColor(Colors.green),
  //       data: receitasList,
  //     ),
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Despesas',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //        colorFn: (OrdinalSales sales, _) =>
  //           charts.ColorUtil.fromDartColor(Colors.red),
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: despesasList,
  //     )
  //   ];
  // }

  // }

}

// class OrdinalSales {
//   final String year;
//   final double sales;
//   final Color color;

//   OrdinalSales(this.year, this.sales, this.color);
// }

// class LinearSales {
//   final int year;
//   final int sales;

//   LinearSales(this.year, this.sales);
// }

// class Sales{
//   String ano, valor;
//   Sales(this.ano, this.valor);
// }
