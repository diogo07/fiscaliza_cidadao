import 'package:fiscaliza_cidadao/view/app_bar.dart';
import 'package:flutter/material.dart';

class TelaAjuda extends StatelessWidget{

 

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBarBack('Ajuda'),
          Expanded(
            child:ListView(
              children: <Widget>[              
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                  child: Text('Página Inicial', textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18, color: Colors.black54),)
                ),

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
                        new TextSpan(text: '\t\t\t\t\t\tNa página inicial do aplicativo, são oferecidas diversas opções de análise. A primeira delas é a busca por'),
                        new TextSpan(text: ' Municipios', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ', onde você pode pesquisar e selecionar o município desejado, para analisar as arrecadações e gastos que o mesmo obteve.'),
                      ],
                    ),
                  )              
                ),

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
                        new TextSpan(text: '\t\t\t\t\t\tNa opção '),
                        new TextSpan(text: 'Rankings', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ', são exibidos os municípios que destinaram a maior parte de suas receitas para as áreas de maior prioridade, como Educação, Saúde, Saneamento Básico, etc.'),
                      ],
                    ),
                  )              
                ),

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
                        new TextSpan(text: '\t\t\t\t\t\tA opção '),
                        new TextSpan(text: 'Comparações', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ', permite o cruzamento de valores entre dois municípios distintos. A partir disso é possivel comparar receitas e despesas de munícipios e analisar as diferenças na distribuição de verbas de cada um deles.'),
                      ],
                    ),
                  )              
                ),

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
                        new TextSpan(text: '\t\t\t\t\t\tNa opção '),
                        new TextSpan(text: 'Sobre', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ', é possível saber mais sobre a aplicação, o seu objetivo, versão atual e a fonte de dados utilizada para seu desenvolvimento.'),
                      ],
                    ),
                  )              
                ),


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
                        new TextSpan(text: '\t\t\t\t\t\tPor último, a opção '),
                        new TextSpan(text: 'Contato', style: new TextStyle(fontFamily: 'Poppins-Regular', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        new TextSpan(text: ', nela são exibidas algumas formas de se comunicar com o desenvolvedor do aplicativo, caso você tenha dúvidas, ou necessite de informações adicionais.'),
                      ],
                    ),
                  )              
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
                  child: Text('Municípios', textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18, color: Colors.black54),)
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                  child: Text(
                    '\t\t\t\t\t\tApós tocar na opção Municípios, o aplicativo apresentará uma tela com um breve texto, um campo de busca e um botão para buscar. Para fazer uma pesquisa, digite parte do nome do município e clique em buscar.',
                    textAlign: TextAlign.justify,
                      style: new TextStyle(
                        fontFamily: 'Poppins-Regular', 
                        fontSize: 15, 
                        color: Colors.black87
                      ),
                      
                  ),                                
                ),

               
                Image.asset('assets/images/img_busca_municipio.jpg', width: MediaQuery.of(context).size.width * 0.9, height: 260.0),


                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                  child: Text(
                    '\t\t\t\t\t\tSerá carregada uma lista com os nomes dos municípios, de acordo com o texto digitado. Após isso, escolha o município que deseja analisar. Ao clicar no município, serão apresentados em gráficos, os valores das receitas e despesas do município.',
                    textAlign: TextAlign.justify,
                      style: new TextStyle(
                        fontFamily: 'Poppins-Regular', 
                        fontSize: 15, 
                        color: Colors.black87
                      ),
                      
                  ),
                                
                ),

                Image.asset('assets/images/receitas.jpg', width: MediaQuery.of(context).size.width * 1, height: 260.0),
                Image.asset('assets/images/despesas.jpg', width: MediaQuery.of(context).size.width * 1, height: 260.0),
                
              ]
            )
          )
        ],
      ),
    );
  }

}