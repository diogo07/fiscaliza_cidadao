import 'dart:convert';

import 'package:fiscaliza_cidadao/controller/controler_tela_consultas_personalizadas.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TelaConsultasPersonalizas extends StatefulWidget {
  _TelaConsultasPersonalizas createState() => new _TelaConsultasPersonalizas();
}

class _TelaConsultasPersonalizas extends State<TelaConsultasPersonalizas> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController editingControllerPrimeiroMunicipio,
      editingControllerSegundoMunicipio;
  List<Municipio> municipios = List<Municipio>();
  bool buscandoMunicipios = false;
  Municipio primeiroMunicipio, segundoMunicipio;
  bool campoPrimeiroMunicipio;
  int campoAtual;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print('foco node');
      }
    });
    editingControllerPrimeiroMunicipio = TextEditingController();
    editingControllerSegundoMunicipio = TextEditingController();
    campoPrimeiroMunicipio = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          body: ListView(
            children: <Widget>[
              GradientAppBarBack("Comparações"),
              Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 40, left: 40, right: 40),
              child: Text(
                '\t\t\t\t\t\tVocê pode selecionar dois municípios e comparar arrecadações e gastos que cada um obteve anualmente. Para fazer isso, digite o nome do primeiro município e toque em pesquisa, depois selecione o município desejado.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 14, color: Colors.black87),
              ),
            ),

            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: new Column(
                children: <Widget>[
                  new Row(children: <Widget>[
                    new Expanded(
                      child: TextField(
                        controller: editingControllerPrimeiroMunicipio,
                        decoration: new InputDecoration(
                          enabled: campoPrimeiroMunicipio,
                          labelText: "Nome do primeiro município",
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                  campoPrimeiroMunicipio
                      ? Container()
                      : new Row(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 30.0),
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editingControllerSegundoMunicipio,
                              decoration: new InputDecoration(
                                labelText: "Nome do segundo município",
                                prefixIcon: Icon(Icons.search),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ]),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: new RaisedButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: const Text(
                                    'Buscar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  color: Colors.blue[300],
                                  elevation: 4.0,
                                  splashColor: Colors.blueGrey,
                                  onPressed: () {
                                    buscarMunicipios();
                                  },
                                ))),
                      ])
                ],
              ),
            ),

            buscandoMunicipios
                ? new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 10),
                        child: new CircularProgressIndicator(),
                      )
                    ],
                  )
                : new Container(),
            Container(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: municipios.length,
                itemBuilder: (context, index) {
                  var municipio = municipios[index];
                  return criarCard(municipio);
                },
              ),
            ),



              // Container(
              //   height: 100,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: ClampingScrollPhysics(),
              //     itemBuilder: (_, i) => ListTile(title: Text("Item ${i}"))),
              // )
            ]
          )
          // )
      // GradientAppBarBack("Comparações"),
      // Expanded(
      //     child: Center(
      //   child: Column(
      //     children: <Widget>[
      //       Padding(
      //         padding:
      //             EdgeInsets.only(top: 20, bottom: 40, left: 40, right: 40),
      //         child: Text(
      //           '\t\t\t\t\t\tVocê pode selecionar dois municípios e comparar arrecadações e gastos que cada um obteve anualmente. Para fazer isso, digite o nome do primeiro município e toque em pesquisa, depois selecione o município desejado.',
      //           textAlign: TextAlign.justify,
      //           style: TextStyle(
      //               fontFamily: 'Poppins', fontSize: 14, color: Colors.black87),
      //         ),
      //       ),
      //       new Container(
      //         margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      //         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      //         child: new Column(
      //           children: <Widget>[
      //             new Row(children: <Widget>[
      //               new Expanded(
      //                 child: TextField(
      //                   controller: editingControllerPrimeiroMunicipio,
      //                   decoration: new InputDecoration(
      //                     enabled: campoPrimeiroMunicipio,
      //                     labelText: "Nome do primeiro município",
      //                     prefixIcon: Icon(Icons.search),
      //                     fillColor: Colors.white,
      //                     border: new OutlineInputBorder(
      //                       borderRadius: new BorderRadius.circular(30.0),
      //                       borderSide: new BorderSide(),
      //                     ),
      //                   ),
      //                   keyboardType: TextInputType.text,
      //                   style: new TextStyle(
      //                     fontFamily: "Poppins",
      //                     fontSize: 14,
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             campoPrimeiroMunicipio
      //                 ? Container()
      //                 : new Row(children: <Widget>[
      //                     Container(
      //                       margin: const EdgeInsets.only(top: 30.0),
      //                       padding: EdgeInsets.only(top: 20, bottom: 30),
      //                     ),
      //                     Expanded(
      //                       child: TextField(
      //                         controller: editingControllerSegundoMunicipio,
      //                         decoration: new InputDecoration(
      //                           labelText: "Nome do segundo município",
      //                           prefixIcon: Icon(Icons.search),
      //                           fillColor: Colors.white,
      //                           border: new OutlineInputBorder(
      //                             borderRadius: new BorderRadius.circular(30.0),
      //                             borderSide: new BorderSide(),
      //                           ),
      //                         ),
      //                         keyboardType: TextInputType.text,
      //                         style: new TextStyle(
      //                           fontFamily: "Poppins",
      //                           fontSize: 14,
      //                         ),
      //                       ),
      //                     ),
      //                   ]),
      //             new Row(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: <Widget>[
      //                   new Expanded(
      //                       child: new Container(
      //                           margin: const EdgeInsets.only(top: 10.0),
      //                           child: new RaisedButton(
      //                             padding: EdgeInsets.all(10.0),
      //                             child: const Text(
      //                               'Buscar',
      //                               style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontFamily: "Poppins",
      //                                 fontSize: 14,
      //                               ),
      //                             ),
      //                             shape: RoundedRectangleBorder(
      //                                 borderRadius:
      //                                     BorderRadius.circular(30.0)),
      //                             color: Colors.blue[300],
      //                             elevation: 4.0,
      //                             splashColor: Colors.blueGrey,
      //                             onPressed: () {
      //                               buscarMunicipios();
      //                             },
      //                           ))),
      //                 ])
      //           ],
      //         ),
      //       ),
      //       buscandoMunicipios
      //           ? new Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: <Widget>[
      //                 new Container(
      //                   padding: new EdgeInsets.only(top: 10),
      //                   child: new CircularProgressIndicator(),
      //                 )
      //               ],
      //             )
      //           : new Container(),
      //       Expanded(
      //         child: ListView.builder(
      //           shrinkWrap: true,
      //           itemCount: municipios.length,
      //           itemBuilder: (context, index) {
      //             var municipio = municipios[index];
      //             return criarCard(municipio);
      //           },
      //         ),
      //       ),
        //   ],
        // ),
      )
    ;
  }

  Card criarCard(Municipio municipio) => Card(
        elevation: 8.0,
        color: Colors.transparent,
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: new BorderRadius.all(Radius.circular(10.0)),
          ),
          child: criarLista(municipio),
        ),
      );

  Widget criarLista(Municipio municipio) {
    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(
          Icons.location_city,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        municipio.nome,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text(municipio.uf,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          )
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => campoPrimeiroMunicipio
          ? setPrimeiroMunicipio(municipio)
          : setSegundoMunicipio(municipio),
    );
  }

  void setPrimeiroMunicipio(Municipio municipio) {
    primeiroMunicipio = municipio;
    setState(() {
      editingControllerPrimeiroMunicipio.text =
          municipio.nome + " - " + municipio.uf;
      campoPrimeiroMunicipio = false;
      municipios.clear();
    });
  }

  void setSegundoMunicipio(Municipio municipio) {
    if (primeiroMunicipio.codigo != municipio.codigo) {
      segundoMunicipio = municipio;
      setState(() {
        editingControllerSegundoMunicipio.text =
            municipio.nome + " - " + municipio.uf;
        municipios.clear();
        ControllerTelaConsultasPersonalizadas.abrirTelaComparativoMunicipios(
            context, primeiroMunicipio, segundoMunicipio);
      });
    } else {
      Toast.show("O segundo município deve ser diferente do primeiro!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void atualizarLista(List<Municipio> m) {
    setState(() {
      municipios.clear();
      municipios.addAll(m);
      buscandoMunicipios = false;
    });
  }

  void buscarMunicipios() {
    if (campoPrimeiroMunicipio) {
      if (editingControllerPrimeiroMunicipio.text.length > 0) {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          buscandoMunicipios = true;
        });
        buscarMunicipio(Utils.removerCaracteresEspeciais(
            editingControllerPrimeiroMunicipio.text));
      } else {
        setState(() {
          municipios.clear();
        });
        Toast.show("Você precisa digitar algo para buscar!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      if (editingControllerSegundoMunicipio.text.length > 0) {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          buscandoMunicipios = true;
        });
        buscarMunicipio(Utils.removerCaracteresEspeciais(
            editingControllerSegundoMunicipio.text));
      } else {
        setState(() {
          municipios.clear();
        });
        Toast.show("Você precisa digitar algo para buscar!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  buscarMunicipio(String query) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      final response = await http.get(Utils.API + 'municipio/' + query + '/');
      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        List<Municipio> listaMunicipios = new List<Municipio>();

        if (dados.length > 0) {
          dados.forEach((dado) {
            listaMunicipios.add(new Municipio(
                dado['codigo'], dado['nome'], dado['uf'], dado['regiao']));
          });
          setState(() {
            buscandoMunicipios = false;
            municipios.clear();
            municipios.addAll(listaMunicipios);
          });
        } else {
          setState(() {
            buscandoMunicipios = false;
            municipios.clear();
          });
          Toast.show("Nenhum município encontrado!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      } else {
        setState(() {
          buscandoMunicipios = false;
          municipios.clear();
          Toast.show("Nenhum município encontrado!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        });
      }
    } else {
      setState(() {
        buscandoMunicipios = false;
      });
      _showDialog(context, 'SEM CONEXÃO COM A INTERNET!');
    }
  }

  void _showDialog(BuildContext context, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: new Text(titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )),
          ),
          content: new Icon(
            Icons.cloud_off,
            size: 90,
            color: Colors.blueAccent,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
