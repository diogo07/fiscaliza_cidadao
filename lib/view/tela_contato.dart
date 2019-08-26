import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:fiscaliza_cidadao/view/app_bar.dart';

class TelaContato extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBarBack('Contato'),
          new Expanded(
            child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 30),
                ),
                new Icon(
                  Icons.email,
                  color: Colors.black,
                  size: 50,
                ),
                new Text(
                  'diogosousa36@gmail.com',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),

                new Padding(
                  padding: new EdgeInsets.only(top: 60),
                ),

                Image.asset('assets/images/git.png', width: 100.0, height: 60.0),
                InkWell(
                child: Text(
                  'github.com/diogo07',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  if (await canLaunch("https://www.github.com/diogo07")) {
                    await launch("https://www.github.com/diogo07");
                  }
                },               
                                            
                ),

                new Padding(
                  padding: new EdgeInsets.only(top: 60),
                ),

                Image.asset('assets/images/linkedin.png', width: 100.0, height: 60.0),
                InkWell(
                child: Text(
                  'Diogo Sousa',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  if (await canLaunch("https://www.linkedin.com/in/diogo-sousa-47164493/")) {
                    await launch("https://www.linkedin.com/in/diogo-sousa-47164493/");
                  }
                },               
                                            
                ),

                new Padding(
                  padding: new EdgeInsets.only(bottom:30),
                )
              ],
            )
            ]
            ) 
          )
        ],
      ),
    );
  }

}