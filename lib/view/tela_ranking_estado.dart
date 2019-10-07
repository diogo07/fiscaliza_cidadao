import 'package:fiscaliza_cidadao/model/municipio_ranking.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';

class TelaRankingEstado extends StatefulWidget {
  String uf;
  TelaRankingEstado(this.uf);
  _TelaRankingEstado createState() => new _TelaRankingEstado(this.uf);
}

class _TelaRankingEstado extends State<TelaRankingEstado> {
  List<MunicipioRanking> listaMunicipiosEducacao,
      listaMunicipiosSaude,
      listaMunicipiosSaneamento;
  Widget graficoMunicipiosSaude,
      graficoMunicipiosEducacao,
      graficoMunicipiosSaneamento;
  int anoEducacao, anoSaude, anoSaneamento;
  bool exibirTextoEducacao, exibirTextoSaude, exibirTextoSaneameto;
  String uf;
 
 
  _TelaRankingEstado(this.uf);


  @override
  void initState() {
    exibirTextoEducacao = false;
    exibirTextoSaude = false;
    exibirTextoSaneameto = false;
    anoEducacao = 2014;
    anoSaude = 2014;
    anoSaneamento = 2014;
    listaMunicipiosEducacao = new List<MunicipioRanking>();
    listaMunicipiosSaude = new List<MunicipioRanking>();
    listaMunicipiosSaneamento = new List<MunicipioRanking>();
    graficoMunicipiosEducacao = componentePreLoading();
    graficoMunicipiosSaude = componentePreLoading();
    graficoMunicipiosSaneamento = componentePreLoading();
    buscarListaRanking(12, 2014);
    buscarListaRanking(10, 2014);
    buscarListaRanking(17, 2014);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(children: <Widget>[
      new GradientAppBarBack("Rankings - "+this.uf),
      new Expanded(
          child: new ListView(shrinkWrap: true, children: <Widget>[
        new Center(
            child: new Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              componenteTitulo('Ranking de Investimento em Educação'),
            ],
          ),
          exibirTextoEducacao ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Text(
              '\t\t\t\t\t\tO gráfico abaixo apresenta o ranking com os dez municípios que destinaram a maior parte de sua arrecadação para a área da Educação, no ano de ' +
                  anoEducacao.toString() +
                  '. Tocando no menu do lado direito abaixo, você também pode verificar esse ranking em outros anos.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(right: 20),
                child: exibirTextoEducacao ? componenteMenuGraficoRankingEducacao() : Container(),
              ),
            ],
          ),

           Padding(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 40, right: 40),
                          child:
                  Text(
                    anoEducacao.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                          
              ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 1.4,
                    child: new Padding(
                        padding: new EdgeInsets.all(20),
                        child: graficoMunicipiosEducacao))
              ]),
          exibirTextoEducacao ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Text(
              '\t\t\t\t\t\tCaso no gráfico não seja possível visualizar o nome do município por completo, toque na barra referente a porcentagem do município ao qual deseja verificar.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              componenteTitulo('Ranking de Investimento em Saúde'),
            ],
          ),
          exibirTextoSaude ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Text(
              '\t\t\t\t\t\tNo gráfico a seguir, você pode visualizar os dez municípios que aplicaram a maior parte de sua arrecadação na área da Saúde, no ano de ' +
                  anoSaude.toString() +
                  '. Tocando no menu do lado direito abaixo, você também pode verificar esse ranking em outros anos.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(right: 20),
                child: exibirTextoSaude ? componenteMenuGraficoRankingSaude() : Container(),
              ),
            ],
          ),

           Padding(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 40, right: 40),
                          child:
                  Text(
                    anoSaude.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                          
              ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 1.4,
                    child: new Padding(
                        padding: new EdgeInsets.all(20),
                        child: graficoMunicipiosSaude))
              ]),
          exibirTextoSaude ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Text(
              '\t\t\t\t\t\tCaso no gráfico não seja possível visualizar o nome do município por completo, toque na barra referente a porcentagem do município ao qual deseja verificar.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              componenteTitulo('Ranking de Investimento em Saneamento Básico'),
            ],
          ),
          exibirTextoSaneameto ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Text(
              '\t\t\t\t\t\tLogo abaixo são exibidos os dez municípios que destinaram a maior parte de sua arrecadação para a área de Saneamento Básico, no ano de ' +
                  anoSaude.toString() +
                  '. Tocando no menu do lado direito abaixo, você também pode verificar esse ranking em outros anos.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(right: 20),
                child: exibirTextoSaneameto ? componenteMenuGraficoRankingSaneamento() : Container(),
              ),
            ],
          ),

           Padding(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 40, right: 40),
                          child:
                  Text(
                    anoSaneamento.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                          
              ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 1.4,
                    child: new Padding(
                        padding: new EdgeInsets.all(20),
                        child: graficoMunicipiosSaneamento))
              ]),
          exibirTextoSaneameto ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 80, left: 40, right: 40),
            child: Text(
              '\t\t\t\t\t\tCaso no gráfico não seja possível visualizar o nome do município por completo, toque na barra referente a porcentagem do município ao qual deseja verificar.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ) : Container(),
        ]))
      ]))
    ]));
  }

  buscarListaRanking(int codigoArea, int ano) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      final response = await http.get(Utils.api +
          'rankings/uf/'+siglaEstado(this.uf)+'/area/' +
          codigoArea.toString() +
          '/ano/' +
          ano.toString());

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        int i = 0;

        if (codigoArea == 12) listaMunicipiosEducacao.clear();
        if (codigoArea == 10) listaMunicipiosSaude.clear();
        if (codigoArea == 17) listaMunicipiosSaneamento.clear();

        dados.forEach((d) {
          if (codigoArea == 12) {
            listaMunicipiosEducacao.add(new MunicipioRanking(d['ano'],
                d['municipio'], d['uf'], d['porcentagem'], getCor(i)));
          }
          if (codigoArea == 10) {
            listaMunicipiosSaude.add(new MunicipioRanking(d['ano'],
                d['municipio'], d['uf'], d['porcentagem'], getCor(i)));
          }

          if (codigoArea == 17) {
            listaMunicipiosSaneamento.add(new MunicipioRanking(d['ano'],
                d['municipio'], d['uf'], d['porcentagem'], getCor(i)));
          }

          i++;
        });

        setState(() {
          if (codigoArea == 12) {
            this.anoEducacao = ano;
            graficoMunicipiosEducacao = graficoDeBarrasRanking(
                listaMunicipiosEducacao, codigoArea.toString());
            exibirTextoEducacao = true;
          }

          if (codigoArea == 10) {
            this.anoSaude = ano;
            graficoMunicipiosSaude = graficoDeBarrasRanking(
                listaMunicipiosSaude, codigoArea.toString());
            exibirTextoSaude = true;
          }

          if (codigoArea == 17) {
            this.anoSaneamento = ano;
            graficoMunicipiosSaneamento = graficoDeBarrasRanking(
                listaMunicipiosSaneamento, codigoArea.toString());
            exibirTextoSaneameto = true;
          }
        });
      } else {
          Toast.show(
            "Ocorreu um erro ao atualizar as informações, tente novamente!",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
        setState(() {
          if (codigoArea == 12) graficoMunicipiosEducacao = recarregarRanking(codigoArea, ano);
          if (codigoArea == 10) graficoMunicipiosSaude = recarregarRanking(codigoArea, ano);
          if (codigoArea == 17) graficoMunicipiosSaneamento = recarregarRanking(codigoArea, ano);
        });
        
      }
    } else {
      Toast.show("Sem conexão com a internet!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
          if (codigoArea == 12) graficoMunicipiosEducacao = recarregarRanking(codigoArea, ano);
          if (codigoArea == 10) graficoMunicipiosSaude = recarregarRanking(codigoArea, ano);
          if (codigoArea == 17) graficoMunicipiosSaneamento = recarregarRanking(codigoArea, ano);
        });
    }
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

  List<charts.Series<MunicipioRanking, String>> gerarSeriesRanking(
      List<MunicipioRanking> itens, String tipo) {
    return [
      new charts.Series<MunicipioRanking, String>(
          id: tipo,
          domainFn: (MunicipioRanking item, _) => limitTamanhoTexto(item.nome),
          measureFn: (MunicipioRanking item, _) => item.porcentagem,
          data: itens,
          insideLabelStyleAccessorFn: (MunicipioRanking item, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
          colorFn: (MunicipioRanking item, _) =>
              charts.ColorUtil.fromDartColor(item.cor),
          outsideLabelStyleAccessorFn: (MunicipioRanking item, _) =>
              charts.TextStyleSpec(
                  fontFamily: 'Poppins',
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),
          labelAccessorFn: (MunicipioRanking item, _) =>
              item.formatPorcentagem())
    ];
  }

  Widget graficoDeBarrasRanking(List<MunicipioRanking> itens, String tipo) {
    return new charts.BarChart(
      gerarSeriesRanking(itens, tipo),
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
          if (model.hasDatumSelection) {
            if (tipo == '12') {
              Toast.show(
                  listaMunicipiosEducacao[model.selectedDatum[0].index].nome +
                      ' - ' +
                      listaMunicipiosEducacao[model.selectedDatum[0].index].uf,
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
            }

            if (tipo == '10') {
              Toast.show(
                  listaMunicipiosSaude[model.selectedDatum[0].index].nome +
                      ' - ' +
                      listaMunicipiosSaude[model.selectedDatum[0].index].uf,
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
            }

            if (tipo == '17') {
              Toast.show(
                  listaMunicipiosSaneamento[model.selectedDatum[0].index].nome +
                      ' - ' +
                      listaMunicipiosSaneamento[model.selectedDatum[0].index]
                          .uf,
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
            }
          }
        })
      ],
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
                  color: charts.MaterialPalette.black))),
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

  Widget recarregarRanking(int codigoArea, int ano) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Sem conexão com a internet!',
          style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "Poppins-Regular",
                  fontSize: 14,
                ),
        ),
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
                  if (codigoArea == 12) graficoMunicipiosEducacao = componentePreLoading();
                  if (codigoArea == 10) graficoMunicipiosSaude = componentePreLoading();
                  if (codigoArea == 17) graficoMunicipiosSaneamento = componentePreLoading(); 
                });
                buscarListaRanking(codigoArea, ano);

              },
            )),
      ],
    );
  }

  String limitTamanhoTexto(String texto) {
    if (texto.length > 10) {
      return texto.substring(0, 11) + '...';
    } else {
      return texto;
    }
  }

  Color getCor(int index) {
    final list = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.grey,
      Colors.indigo,
      Colors.orange,
      Colors.orangeAccent,
      Colors.teal,
    ];

    list.shuffle();

    if (list.length - 1 >= index) {
      return list[index];
    } else {
      return list[0];
    }
  }

  Widget componenteMenuGraficoRankingEducacao() {
    return PopupMenuButton<int>(
      icon: new Icon(
        Icons.list,
        color: Colors.black,
        size: 30,
      ),
      onSelected: (item) => mudarGraficoRankingEducacao(item),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "2014",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "2015",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "2016",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            "2017",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(
            "2018",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget componenteMenuGraficoRankingSaude() {
    return PopupMenuButton<int>(
      icon: new Icon(
        Icons.list,
        color: Colors.black,
        size: 30,
      ),
      onSelected: (item) => mudarGraficoRankingSaude(item),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "2014",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "2015",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "2016",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            "2017",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(
            "2018",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget componenteMenuGraficoRankingSaneamento() {
    return PopupMenuButton<int>(
      icon: new Icon(
        Icons.list,
        color: Colors.black,
        size: 30,
      ),
      onSelected: (item) => mudarGraficoRankingSaneamento(item),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "2014",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "2015",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "2016",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            "2017",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(
            "2018",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void mudarGraficoRankingEducacao(int item) {
    setState(() {
      switch (item) {
        case 1:
          graficoMunicipiosEducacao = componentePreLoading();
          buscarListaRanking(12, 2014);
          break;
        case 2:
          graficoMunicipiosEducacao = componentePreLoading();
          buscarListaRanking(12, 2015);
          break;
        case 3:
          graficoMunicipiosEducacao = componentePreLoading();
          buscarListaRanking(12, 2016);
          break;
        case 4:
          graficoMunicipiosEducacao = componentePreLoading();
          buscarListaRanking(12, 2017);
          break;
        case 5:
          graficoMunicipiosEducacao = componentePreLoading();
          buscarListaRanking(12, 2018);
          break;
      }
    });
  }

  void mudarGraficoRankingSaude(int item) {
    setState(() {
      switch (item) {
        case 1:
          graficoMunicipiosSaude = componentePreLoading();
          buscarListaRanking(10, 2014);
          break;
        case 2:
          graficoMunicipiosSaude = componentePreLoading();
          buscarListaRanking(10, 2015);
          break;
        case 3:
          graficoMunicipiosSaude = componentePreLoading();
          buscarListaRanking(10, 2016);
          break;
        case 4:
          graficoMunicipiosSaude = componentePreLoading();
          buscarListaRanking(10, 2017);
          break;
        case 5:
          graficoMunicipiosSaude = componentePreLoading();
          buscarListaRanking(10, 2018);
          break;
      }
    });
  }

  void mudarGraficoRankingSaneamento(int item) {
    setState(() {
      switch (item) {
        case 1:
          graficoMunicipiosSaneamento = componentePreLoading();
          buscarListaRanking(17, 2014);
          break;
        case 2:
          graficoMunicipiosSaneamento = componentePreLoading();
          buscarListaRanking(17, 2015);
          break;
        case 3:
          graficoMunicipiosSaneamento = componentePreLoading();
          buscarListaRanking(17, 2016);
          break;
        case 4:
          graficoMunicipiosSaneamento = componentePreLoading();
          buscarListaRanking(17, 2017);
          break;
        case 5:
          graficoMunicipiosSaneamento = componentePreLoading();
          buscarListaRanking(17, 2018);
          break;
      }
    });
  }


  String siglaEstado(String estadoNome){
    switch (estadoNome) {
      case "Acre":
        return "AC";
        break;
      
      case "Alagoas":
        return "AL";
        break;
      
      case "Amapá":
        return "AP";
        break;
      
      case "Amazonas":
        return "AM";
        break;
      
      case "Bahia":
        return "BA";
        break;
      
      case "Ceará":
        return "CE";
        break;
      
      case "Distrito Federal":
        return "DF";
        break;

      case "Espírito Santo":
        return "ES";
        break;

      case "Goiás":
        return "GO";
        break;

      case "Maranhão":
        return "MA";
        break;
      
      case "Mato Grosso":
        return "MT";
        break;

      case "Mato Grosso do Sul":
        return "MS";
        break;

      case "Minas Gerais":
        return "MG";
        break;

      case "Pará":
        return "PA";
        break;
      
      case "Paraíba":
        return "PB";
        break;

      case "Paraná":
        return "PR";
        break;
      
      case "Pernambuco":
        return "PE";
        break;

      case "Piauí":
        return "PI";
        break;

      case "Rio de Janeiro":
        return "RJ";
        break;

      case "Rio Grande do Norte":
        return "RN";
        break;

      case "Rio Grande do Sul":
        return "RS";
        break;
      
      case "Rondônia":
        return "RO";
        break;

      case "Roraima":
        return "RR";
        break;

      case "Santa Catarina":
        return "SC";
        break;

      case "São Paulo":
        return "SP";
        break;

      case "Sergipe":
        return "SE";
        break;

      case "Tocantins":
        return "TO";
        break;
      
      default:
        return "";
        break;
      }
  }
}
