
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiscaliza_cidadao/view/tela_home.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class TelaSplash extends StatefulWidget{
  @override
  _TelaSplash createState() => new _TelaSplash();

}

class _TelaSplash extends State<TelaSplash>{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TelaHome()));
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,        
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(10),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/logo.png', width: 200.0, height: 200.0),
                  
                       new Container(
                        // elevation: 0,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 2.0, color: Colors.white),
                            bottom: BorderSide(width: 2.0, color: Colors.white),
                          ),
                          color: Colors.transparent,
                        ),
                        // color: Colors.transparent,
                        
                        // shape: StadiumBorder(
                          
                        //   side: BorderSide(width: 2.0, color: Colors.white)
                          
                        // ),
                        child: 
                        new Text(
                          'Fiscaliza Cidadão',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 35,
                            color: Colors.white,
                          )
                        ),
                       )  
                      ],
                    )
                  )
                
                      
              ],
            )  
          ),
          )
        ],
      ),
    );
  }

}