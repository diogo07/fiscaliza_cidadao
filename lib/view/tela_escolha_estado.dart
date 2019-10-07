
import 'package:fiscaliza_cidadao/controller/controller_tela_escolha_estado.dart';
import 'package:fiscaliza_cidadao/utils/utils.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

class TelaEscolhaEstado extends StatefulWidget{
  
  _TelaEscolhaEstado createState() => _TelaEscolhaEstado();
}

class _TelaEscolhaEstado extends State<TelaEscolhaEstado>{

  final textEditingController = TextEditingController();
  var estados = List<String>();
  bool buscandoEstados = false;

  @override
  void initState() {
   
    textEditingController.addListener(() {
    if (textEditingController.text.isEmpty) {
      
    } else {
      buscarEstados();
    }
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(children: <Widget>[
        GradientAppBarBack('Estados'),
        Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Digite o nome do estado",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins"),
                ),
              ),
              Container(
                margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: new InputDecoration(
                            labelText: "Nome estado",
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (_) => textEditingController.clear());
                                    estados.clear();
                                  });
                                }),
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
                   
                  ],
                ),
              ),
              buscandoEstados
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
                  itemCount: estados.length,
                  itemBuilder: (context, index) {
                    var estado = estados[index];
                    return criarCard(estado);
                  },
                ),
              ),
              ]
            )
          )
        )
      ])
    );
  }


  Card criarCard(String estado) => Card(
        elevation: 8.0,
        color: Colors.transparent,
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: new BorderRadius.all(Radius.circular(10.0)),
          ),
          child: criarLista(estado),
        ),
      );

  Widget criarLista(String estado) {
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
        estado,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text(siglaEstado(estado),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          )
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => ControllerTelaEscolhaEstado.abrirTelaRankingEstados(
          context, estado),
    );
  }

  void atualizarLista(List<String> e) {
    setState(() {
      estados.clear();
      estados.addAll(e);
      buscandoEstados = false;
    });
  }

  void buscarEstados() {
    
      setState(() {
        buscandoEstados = true;
      });
      buscarEstado(Utils.removerCaracteresEspeciais(textEditingController.text));
    
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

  void buscarEstado(String filtro){
    var list = ["Acre", "Alagoas", "Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goiás", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins"];
    List<String> filtrada = new List<String>();
    list.forEach((uf){
      if(uf.toLowerCase().contains(filtro.toLowerCase())){
        filtrada.add(uf);
      }
    });

    atualizarLista(filtrada);


  }

}