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
      height: MediaQuery.of(context).orientation == Orientation.portrait ? statusBarHeight + barHeight: statusBarHeight + 65,
      decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
      ),
      child: new Center(
        child: Row(
          children: <Widget>[
            
            new Expanded(
              flex: 8,
              child: Column(                
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  new Padding(
                    padding: EdgeInsets.only(top:10, bottom: 15, left: 20),
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
                            size: 24,
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