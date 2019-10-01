import 'package:fiscaliza_cidadao/controller/controller_tela_pesquisa.dart';
import 'package:fiscaliza_cidadao/model/municipio.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import "package:flutter/material.dart";
import "package:fiscaliza_cidadao/view/app_bar.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';

class TelaPesquisaMunicipios extends StatefulWidget {
  TelaPesquisaMunicipios({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TelaPesquisaMunicipios createState() => new _TelaPesquisaMunicipios();
}

class _TelaPesquisaMunicipios extends State<TelaPesquisaMunicipios> {
  TextEditingController editingController = TextEditingController();
  var municipios = List<Municipio>();

  bool buscandoMunicipios = false;

  void alterarStatusBusca(bool status) {
    setState(() {
      buscandoMunicipios = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new GradientAppBarBack('Municípios'),
        new Expanded(
            child: new Center(
                child: new Column(children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Digite o nome do município",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Poppins"),
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
                      controller: editingController,
                      decoration: new InputDecoration(
                        labelText: "Nome município",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: (){
                              setState(() {
                               WidgetsBinding.instance.addPostFrameCallback((_) => editingController.clear());
                               municipios.clear();
                              });
                            }
                          ),
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
                                    borderRadius: BorderRadius.circular(30.0)),
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: municipios.length,
              itemBuilder: (context, index) {
                var municipio = municipios[index];
                return criarCard(municipio);
              },
            ),
          ),
        ])))
      ]),
    );
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
      onTap: () => ControllerTelaPesquisa.abrirTelaMunicipio(
          context, municipio.codigo, municipio.nome + ' - ' + municipio.uf),
    );
  }

  void atualizarLista(List<Municipio> m) {
    setState(() {
      municipios.clear();
      municipios.addAll(m);
      buscandoMunicipios = false;
    });
  }

  void buscarMunicipios() {
    if (editingController.text.length > 0) {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        alterarStatusBusca(true);
      });
      buscarMunicipio(Utils.removerCaracteresEspeciais(editingController.text));
    } else {
      setState(() {
        municipios.clear();
      });
      Toast.show("Você precisa digitar algo para buscar!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  buscarMunicipio(String query) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
 
          final response =
              await http.get(Utils.api + 'municipio/' + query + '/');
          if (response.statusCode == 200) {
            print('status 200');
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
              print('nenhum municipio encontrado');
              setState(() {
                buscandoMunicipios = false;
                municipios.clear();
              });
              Toast.show("Nenhum município encontrado!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
          } else {
            print('status erro');
            setState(() {
              buscandoMunicipios = false;
              municipios.clear();
              Toast.show("Nenhum município encontrado!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            });
          }
        }else{
          print('Sem internet else');
           Toast.show("Sem conexão com a internet!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }

  }

  // void _showDialog(BuildContext context, String titulo) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: FittedBox(
  //           fit: BoxFit.fitWidth,
  //           child: new Text(titulo,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 20.0,
  //               )),
  //         ),
  //         content: new Icon(
  //           Icons.cloud_off,
  //           size: 90,
  //           color: Colors.blueAccent,
  //         ),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Fechar"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
