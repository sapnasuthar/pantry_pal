import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  //const RecipeView({super.key, required this.postUrl});

  final String postUrl;

  RecipeView({required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
  //State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  late String finalUrl;

  @override
  void initState() {
    super.initState();

    if(widget.postUrl.contains("http://")){
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    }else{
      finalUrl = widget.postUrl;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                    colors:[
                      const Color(0xfff9f9f9),
                      const Color(0xfff9f9f9)
                    ],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft
                  )
                ),
                child: Row(
                    mainAxisAlignment: kIsWeb ? MainAxisAlignment.start: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("PantryPal", style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontFamily: 'Overpass',
                          fontWeight: FontWeight.w500
                      ),),
                      Text ("Recipes",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontFamily: 'Overpass'
                        ),
                      )
                    ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width,
                child: WebView(
                    onPageFinished:(val){
                      print(val);
                    },
                    //javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: finalUrl,
                    onWebViewCreated: (WebViewController webViewController){
                      setState(() {
                        _controller.complete(webViewController);
                      });
                    }),
              )
            ],
          )
      ),
    );
  }
}
