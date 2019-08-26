import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 150.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
      .of(context)
      .padding
      .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
      ),
      child: new Center(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            new Expanded(
              flex: 8,
              child: Column(                
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 20),
                    child: new Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        
                      )
                    ),
                  )
                ]
              )    
            ),

            new Expanded(
              flex: 2,
              child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 20),
                        
                        child: new InkWell(
                          child: new Icon(
                            Icons.exit_to_app,
                            size: 28,
                            color: Colors.white,                          
                          ),
                          onTap: () => 
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                          ,
                        )
                      )
                    ],
                  ),
            )

          ],
        )
          
      )
    );
  }
}

class GradientAppBarBack extends StatelessWidget {

  final String title;
  final double barHeight = 60.0;

  GradientAppBarBack(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
      .of(context)
      .padding
      .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
      ),
      // decoration: new BoxDecoration(
      //   gradient: new LinearGradient(
      //     colors: [
      //       const Color.fromRGBO(26,19,133,1),
      //       const Color.fromRGBO(13,159,189,1)
      //     ],
      //     begin: const FractionalOffset(0.0, 0.9),
      //     end: const FractionalOffset(0.8, 1.0),
      //     stops: [0.0, 0.99],
      //     tileMode: TileMode.clamp
      //   ),
      // ),
      child: new Center(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                  
                ],
              ),
            ),
            new Expanded(
              flex: 6,
              child: Column(                
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[ 
                  FittedBox(
                    fit:BoxFit.fitWidth,                    
                    child: new Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        
                      )
                    ),
                  )
                ]
              )    
            ),

            new Expanded(
              flex: 2,
              child: Text(''),
            )

          ],
        )
          
      )
    );
  }
}