
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';
import "package:fiscaliza_cidadao/view/app_bar.dart";

class TelaReceitas extends StatelessWidget{
  // final List<charts.Series> seriesList;
  // final bool animate;

  // TelaReceitas(this.seriesList, {this.animate});

  // factory TelaReceitas.withSampleData() {
  //   return new TelaReceitas(
  //     dadosTeste(),
  //     animate: true,
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[

          new GradientAppBar('Receitas'),

          new Text(
            'Teste',
            style: TextStyle(backgroundColor: Color.fromRGBO(249, 60, 60, 1))
          ),
              
          // Expanded(
          //   child: graficoColunas(dadosTeste(), true)
          // )
        ]
      )      
    );
  }


  static List<charts.Series<OrdinalSales, String>> dadosTeste() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    List<charts.Series<OrdinalSales, String>> listaDados = new List();
    
    for (int i = 0; i < data.length; i++){
      listaDados.add(
        new charts.Series(
          id: 'Receitas',
          fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(new Color(0XFF7F50)),
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
        )
      );
    }

    // return [
    //   new charts.Series<OrdinalSales, String>(
    //     id: 'Sales',
    //     colorFn: (_, __) => cores(data.length),
    //     domainFn: (OrdinalSales sales, _) => sales.year,
    //     measureFn: (OrdinalSales sales, _) => sales.sales,
    //     data: data,
    //   )
    // ];
  }

  // static List<Color> listColors(int size){
  //   final colors = [
  //     new Color(0XFF7F50),
  //     new Color(0XFF6347),
  //     new Color(0XFF4500),
  //     new Color(0XFFD700),
  //     new Color(0XFFA500),
  //     new Color(0XFF8C00),
  //     new Color(0X3CB371),
  //     new Color(0X00CED1),
  //     new Color(0X00008B),
  //     new Color(0X191970),
  //     new Color(0XA52A2A),
  //     new Color(0X800000),
  //   ];


  //   List<Color> listColors = new List();
  //   for(int i = 0; i < size; i++){
  //     listColors.add(colors[i]);
  //   }
    

  //   return listColors;
  // }


  Widget graficoCirculo(seriesList, animate){
    return new charts.PieChart(seriesList,
        animate: animate,
        animationDuration: Duration(seconds: 1),
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  _requisicaoGet() async {
    String url = 'http://127.0.0.1:8080/api/despesa/municipio/2512309';
    Response response = await get(url);
     if (response.statusCode == 200) {
      String json = response.body;
      print(json);
    } else {
      print('A network error occurred');
    }

    
    
  }


  static Widget graficoBarras(seriesList, animate){
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      animationDuration: Duration(seconds: 1),
          behaviors: [
            charts.DatumLegend(
              entryTextStyle: charts.TextStyleSpec(
                color:  charts.MaterialPalette.red.shadeDefault,
                
              )
            )
          ],
          defaultRenderer: new charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(30)),
        
    );
  }


  Widget graficoColunas(seriesList, animate){
    return new charts.BarChart(
          seriesList,
          animate: animate,
          animationDuration: Duration(seconds: 1),
          behaviors: [
            charts.DatumLegend(
              entryTextStyle: charts.TextStyleSpec(
                color:  charts.MaterialPalette.red.shadeDefault,
                
              )
            )
          ],
          defaultRenderer: new charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(30)),
        );
  }




  
}


class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}