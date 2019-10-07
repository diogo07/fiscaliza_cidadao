import 'package:connectivity/connectivity.dart';
import 'package:fiscaliza_cidadao/model/despesa.dart';
import 'package:fiscaliza_cidadao/model/receita.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:fiscaliza_cidadao/view/graficos.dart';
import 'package:flutter/cupertino.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';

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
  int codigo, anoInicialReceita, anoFinalReceita, anoInicialDespesa, anoFinalDespesa;
  String nome, tipoDespesas;
  double receitaMedia, despesaMedia;
  List<dynamic> despesas;
  List<Receita> listaReceitas;
  List<Despesa> listaDespesas;
  List<charts.Series<Receita, String>> seriesReceitas;
  List<charts.Series<Despesa, String>> seriesDespesas;
  Widget graficoReceitasAnuais, graficoDespesasAnuais, graficoReceitasDespesasAnuais;

  _TelaMunicipio(int codigo, String nome) {
    this.codigo = codigo;
    this.nome = nome;
  }

  @override
  void initState() {
    receitaMedia = 0.0;
    despesaMedia = 0.0;
    anoInicialReceita = 2014;
    anoFinalReceita = 2018;
    anoInicialDespesa = 2014;
    anoFinalDespesa = 2018;
    tipoDespesas = 'Valor Liquidado';
    graficoReceitasAnuais = new Container(width: 10, height: 10);
    listaReceitas = new List<Receita>();
    listaDespesas = new List<Despesa>();
    seriesReceitas = new List<charts.Series<Receita, String>>();    
    buscarReceitas(this.codigo.toString());
    buscarDespesas(this.codigo.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      GradientAppBarBack(this.nome),
      Expanded(
          child: ListView(shrinkWrap: true, children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  componenteTitulo('Receitas Anuais'),
                ],
              ),

              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 40, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\tOlá, você sabia que o município de '+nome+' arrecadou, em média, '+Utils.valorEmString(receitaMedia)+' por ano entre '+anoInicialReceita.toString()+' e '+anoFinalReceita.toString()+'. No gráfico apresentado a seguir, você pode verificar o valor arrecadado em cada ano.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 40, left: 40, right: 40),
                          child: graficoReceitasAnuais,
                        ))
              ]),

              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 40, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\tPara saber mais informações sobre a forma como esse valor foi arrecadado em cada ano, você pode tocar em uma das barras verdes do gráfico acima, de acordo com o ano que você deseja verificar.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),
            ],


          ),
        ),

        Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  componenteTitulo('Despesas Anuais'),
                ],
              ),

              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\tA média de despesas anuais do município de '+nome+', entre '+anoInicialDespesa.toString()+' e '+anoFinalDespesa.toString()+', é de '+Utils.valorEmString(despesaMedia)+'. O gráfico apresentado a seguir, expõe o valor de cada ano, podendo elas serem classificadas entre Empenhadas, Liquidadas, Pagas e Restos a Pagar.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),


              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\t'+getTextoTipoDespesa()+'.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.only(right:20),
                    child: componenteMenuGrafico(),
                  ),
                  
                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(
                              top: 20),
                    child: new Text(
                      tipoDespesas,
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
                          child: graficoDespesasAnuais,
                        ))
                  ]),
              Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 40, left: 40, right: 40),
                          child:
                  Text(
                    '\t\t\t\t\t\tAo tocar em alguma das barras vermelhas acima, você pode verificar a forma como foi distribuida a despesa de cada ano.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87),
                  ),
                          
              ),
            ],
          ),
        ),

     
      ]))
    ]));
  }

  
  buscarReceitas(String query) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
    final response = await http
        .get(Utils.api + 'receita/municipio/' + query);
    if (response.statusCode == 200) {
      List<dynamic> dados = jsonDecode(response.body);
      List<dynamic> receitas = dados[0]['receitas'];
      receitas.forEach((receita){
        listaReceitas.add(new Receita(int.parse(query), receita['ano'], receita['valor'],
            null, null, Colors.green));
      });
      
      calcularMediaReceitas();
      setAnosReceita();

      setState(() {
        graficoReceitasAnuais = Graficos.graficoDeBarrasReceita(listaReceitas, this.codigo, this.nome, context);
      });
    } else {
      Toast.show("Ocorreu um erro ao atualizar as informações, tente novamente!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      setState((){
        graficoReceitasAnuais = recarregarGraficoReceitas(query);
      });
    }
    }else{
      
      Toast.show("Sem conexão com a internet!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      setState((){
        graficoReceitasAnuais = recarregarGraficoReceitas(query);
      });
    }
  }

  buscarDespesas(String query) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {

      final response = await http
          .get(Utils.api + 'despesa/municipio/' + query);
      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);

        despesas = dados[0]['despesas'];
        
        despesas.forEach((despesa){
          if(despesa['classificacao'] == 'Despesas Liquidadas'){
            listaDespesas.add(new Despesa(int.parse(query), despesa['ano'], despesa['valor'],
              'Despesas Liquidadas', null, Colors.red),);
          }
        });

        calcularMediaDespesas();
        setAnosDespesa();

        setState(() {
          graficoDespesasAnuais = Graficos.graficoDeBarrasDespesa(listaDespesas, this.codigo, this.nome, context);
        });
      }else{
        Toast.show("Ocorreu um erro ao atualizar as informações, tente novamente!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        setState((){
          graficoDespesasAnuais = recarregarGraficoDespesas(query);
        });
      }
    } else {
      Toast.show("Sem conexão com a internet!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      setState((){
        graficoDespesasAnuais = recarregarGraficoDespesas(query);
      });
    }
  }


  
  void mudarGraficoDespesasAnuais(int item) {
    setState(() {
      switch (item) {
        case 1:
          graficoDespesasAnuais =
              Graficos.graficoDeBarrasDespesa(getListDespesas('Empenhadas'), this.codigo, this.nome, context);
              this.tipoDespesas = "Valor Empenhado";
          break;
        case 2:
          graficoDespesasAnuais =
              Graficos.graficoDeBarrasDespesa(getListDespesas('Liquidadas'), this.codigo, this.nome, context);
              this.tipoDespesas = "Valor Liquidado";
          break;
        case 3:
          graficoDespesasAnuais =
            Graficos.graficoDeBarrasDespesa(getListDespesas('Pagas'), this.codigo, this.nome, context);
              this.tipoDespesas = "Valor Pago";
          break;
        case 4:
          graficoDespesasAnuais =
            Graficos.graficoDeBarrasDespesa(getListDespesas('Restos a Pagar'), this.codigo, this.nome, context);
              this.tipoDespesas = "Restos a Pagar";
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

  List<Despesa> getListDespesas(String classificacao){

    List<Despesa> list = new List<Despesa>();

    if(classificacao == 'Empenhadas'){
       despesas.forEach((despesa){
        if(despesa['classificacao'] == 'Despesas Empenhadas'){
          list.add(new Despesa(codigo, despesa['ano'], despesa['valor'],
            'Despesas Empenhadas', null, Colors.red),);
        }
      });
    }

    if(classificacao == "Liquidadas"){
       despesas.forEach((despesa){
        if(despesa['classificacao'] == 'Despesas Liquidadas'){
          list.add(new Despesa(codigo, despesa['ano'], despesa['valor'],
            'Despesas Liquidadas', null, Colors.red),);
        }
      });
    }

    if(classificacao == "Pagas"){
       despesas.forEach((despesa){
        if(despesa['classificacao'] == 'Despesas Pagas'){
          list.add(new Despesa(codigo, despesa['ano'], despesa['valor'],
            'Despesas Pagas', null, Colors.red),);
        }
      });
    }

    if(classificacao == "Restos a Pagar"){
       despesas.forEach((despesa){
        if(despesa['classificacao'] == 'Inscrição de Restos a Pagar Não Processados'){
          list.add(new Despesa(codigo, despesa['ano'], despesa['valor'],
            'Inscrição de Restos a Pagar Não Processados', null, Colors.red),);
        }
      });
    }

    return list;
  }

  Widget componenteMenuGrafico() {
    return PopupMenuButton<int>(
        icon: new Icon(
          Icons.tune,
          color: Colors.black45,
          size: 30,
          
        ),
        onSelected: (item) => mudarGraficoDespesasAnuais(item),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Despesas Empenhadas",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Despesas Liquidadas",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              "Despesas Pagas",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Text(
              "Restos a Pagar",
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
    );
  }


  void calcularMediaReceitas(){
    double total = 0.0;
    listaReceitas.forEach((receita){
      total += receita.valor;
    });
    setState(() {
      receitaMedia = total/listaReceitas.length;
    });
    
  }

  void calcularMediaDespesas(){
    double total = 0.0;
    listaDespesas.forEach((despesa){
      total += despesa.valor;
    });
    setState(() {
      despesaMedia = total/listaDespesas.length;
    });
    
  }

  void setAnosReceita(){
    anoInicialReceita = listaReceitas[0].ano;
    anoFinalReceita = listaReceitas[listaReceitas.length-1].ano;
  }

  void setAnosDespesa(){
    anoInicialDespesa = listaDespesas[0].ano;
    anoFinalDespesa = listaDespesas[listaDespesas.length-1].ano;
  }

  String getTextoTipoDespesa(){
    if(this.tipoDespesas == 'Valor Empenhado'){
      return "As despesas empenhadas correspondem aos valores reservados para os gastos planejados pelo município";
    }else if(this.tipoDespesas == 'Valor Liquidado'){
      return "As despesas liquidadas correspondem aos valores das despesas concretizadas pelo município";
    }else if(this.tipoDespesas == 'Valor Pago'){
      return "As despesas pagas ocorrem quando o município de fato realiza o pagamento pelo serviço ou produto disponibilizado";
    }else{
      return "Os restos a pagar correspondem as despesas liquidadas que o município não concretizou o pagamento dentro do ano planejado";
    }
  }

  Widget recarregarGraficoReceitas(String query) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: new RaisedButton(
              padding: EdgeInsets.all(10.0),              
              child: const Text(
                'Tente novamente',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.blue[300],
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                setState(() {
                  graficoReceitasAnuais =  componentePreLoading();
                });
                buscarReceitas(query);

              },
            )),
      ],
    );
  }


  Widget recarregarGraficoDespesas(String query) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: new RaisedButton(
              padding: EdgeInsets.all(10.0),              
              child: const Text(
                'Tente novamente',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.blue[300],
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                setState(() {
                  graficoDespesasAnuais =  componentePreLoading();
                });
                buscarDespesas(query);

              },
            )),
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
}