import 'package:fiscaliza_cidadao/model/classificacao_receita_moeda.dart';
import 'package:fiscaliza_cidadao/model/classificacao_receita_porcentagem.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaReceitaMunicipio extends StatefulWidget {
  Receita receita;
  String nome;

  TelaReceitaMunicipio(Receita receita, String nome) {
    this.receita = receita;
    this.nome = nome;
  }

  @override
  _TelaReceitaMunicipio createState() =>
      new _TelaReceitaMunicipio(this.receita, this.nome);
}

class _TelaReceitaMunicipio extends State<TelaReceitaMunicipio> {
  Receita receita;
  String nome, tipoDeMaiorValor = "";
  bool moedaSelect = true;
  List<ClassificacaoReceitaMoeda> listaClassificacaoReceitaMoeda;
  List<ClassificacaoReceitaPorcentagem> listaClassificacaoReceitaPorcentagem;
  Widget graficoReceitasLiquidadas;

  _TelaReceitaMunicipio(Receita receita, String nome) {
    this.receita = receita;
    this.nome = nome;
  }

  @override
  void initState() {
    tipoDeMaiorValor = "";
    graficoReceitasLiquidadas = componentePreLoading();
    listaClassificacaoReceitaMoeda = new List<ClassificacaoReceitaMoeda>();
    listaClassificacaoReceitaPorcentagem = new List<ClassificacaoReceitaPorcentagem>();
    buscarDespesas(this.receita.codigo.toString(), this.receita.ano.toString());
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

              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 40, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\t A maior parte da arrecadação do município de '+this.nome+' vem de '+tipoDeMaiorValor+''+getTextoExplicacao()+'.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(
                              top: 40),
                    child: new Text(
                      'Total: R\$ '+receita.valorEmString(),
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
                        height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.8,
                        child: new Padding(
                          padding: new EdgeInsets.all(20),
                          child: graficoReceitasLiquidadas
                            
    
                        ))
                  ]),
              
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                    child: RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        fontFamily: 'Poppins-Regular', 
                        fontSize: 15, 
                        color: Colors.black87
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'LEGENDA', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: '\nCor.', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' - Receitas Correntes'),
                        new TextSpan(text: '\nCap.', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' - Receitas de Capital'),
                        new TextSpan(text: '\nCap. Int.', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' - Receitas de Capital - Intraorçamentárias'),
                        new TextSpan(text: '\nCor. Int.', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ' - Receitas Correntes - Intraorçamentárias'),
                      ],
                    ),
                  )              
                ),
            ],
          ),
        ),
      ]))
    ]));
  }

  
  buscarDespesas(String codigo, String ano) async {
    final response = await http.get(
        Utils.api + 'receita/funcao/municipio/' +
            codigo +
            '/ano/' +
            ano);
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);

      List<dynamic> receitas = dados[0]['despesas'];
      int i = 0;
      
      receitas.forEach((receita) {
            listaClassificacaoReceitaMoeda.add(
              new ClassificacaoReceitaMoeda(int.parse(ano), receita['valor'],
                  receita['funcao'].toString(), getCor(i)),
            );
            listaClassificacaoReceitaPorcentagem.add(            
              new ClassificacaoReceitaPorcentagem(int.parse(ano), ((receita['valor'])/this.receita.valor)*100,
                  receita['funcao'].toString(), getCor(i)),
            );
            i++;
       
      });

      
      setState(() {
        tipoDeMaiorValor = receitas[0]['funcao'];
         graficoReceitasLiquidadas = graficoDeBarrasClassificacaoReceitaMoeda(listaClassificacaoReceitaMoeda, this.receita.codigo);

      });
     
    } else {
      print('Failed to load post');
    }
  }

  void setMoedaSelect(bool value) {
    setState(() {
      moedaSelect = value;
      if(value){
        graficoReceitasLiquidadas = graficoDeBarrasClassificacaoReceitaMoeda(listaClassificacaoReceitaMoeda, receita.codigo);
      }else{
        graficoReceitasLiquidadas = graficoDeBarrasClassificacaoReceitaPorcentagem(listaClassificacaoReceitaPorcentagem, receita.codigo);
      }
    });
  }


  Widget componentePreLoading(){
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
        componenteTitulo('Receitas de ' + this.receita.ano.toString()),
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

 

  static List<charts.Series<ClassificacaoReceitaMoeda, String>> gerarSeriesClassificacaoReceitaMoeda(
      List<ClassificacaoReceitaMoeda> receitas, int codigoMunicipio) {
    return [
      new charts.Series<ClassificacaoReceitaMoeda, String>(
          id: codigoMunicipio.toString(),
          domainFn: (ClassificacaoReceitaMoeda receita, _) => receita.getTipo(),
          measureFn: (ClassificacaoReceitaMoeda receita, _) =>
              receita.valor,
          data: receitas,
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

  static List<charts.Series<ClassificacaoReceitaPorcentagem, String>> gerarSeriesClassificacaoReceitaPorPorcentagem(
      List<ClassificacaoReceitaPorcentagem> receitas, int codigoMunicipio) {
    return [
      new charts.Series<ClassificacaoReceitaPorcentagem, String>(
          id: codigoMunicipio.toString(),
          domainFn: (ClassificacaoReceitaPorcentagem receita, _) => receita.getTipo(),
          measureFn: (ClassificacaoReceitaPorcentagem receita, _) => receita.valor,
          data: receitas,
          insideLabelStyleAccessorFn: (ClassificacaoReceitaPorcentagem receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          outsideLabelStyleAccessorFn: (ClassificacaoReceitaPorcentagem receita, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          colorFn: (ClassificacaoReceitaPorcentagem receita, _) =>
              charts.ColorUtil.fromDartColor(receita.cor),
          labelAccessorFn: (ClassificacaoReceitaPorcentagem receita, _) =>
              ' ${receita.formatPorcentagem()}%')
    ];
  }

  static Widget graficoDeBarrasClassificacaoReceitaMoeda(
      List<ClassificacaoReceitaMoeda> receitas, int codigoMunicipio) {
    return new charts.BarChart(
      gerarSeriesClassificacaoReceitaMoeda(receitas, codigoMunicipio),
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

  static Widget graficoDeBarrasClassificacaoReceitaPorcentagem(
      List<ClassificacaoReceitaPorcentagem> receitas, int codigoMunicipio) {
    return new charts.BarChart(
      gerarSeriesClassificacaoReceitaPorPorcentagem(receitas, codigoMunicipio),
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


  String getTextoExplicacao(){
    if(tipoDeMaiorValor == ''){
      return '';
    }else if(tipoDeMaiorValor == 'Receitas Correntes'){
      return ', que é formada pelos recursos arrecadados que incrementam o patrimônio do Estado como prestação de serviços, atividades industriais, e os impostos, taxas e contribuições que pagamos.';
    }else if(tipoDeMaiorValor == 'Receitas de Capital'){
      return ', que ocorre quando os recursos são obtidos, por exemplo, através de empréstimos e da venda do patrimônio público.';
    }else if(tipoDeMaiorValor == 'Receitas Correntes - Intraorçamentárias'){
      return '';
    }else{
      return '';
    }
  }
}
