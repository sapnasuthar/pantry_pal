import 'dart:convert';
import 'dart:io';
import 'package:google_project/views/recipe_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe_model.dart';


class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = [];
  late String ingridients;
  bool loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();



  @override
  void initState(){
    super.initState();
  }

  getRecipes(String query) async {

    String url = "https://api.edamam.com/search?q=${textEditingController.text}&app_id=f45a3ded&app_key=c3c803a36ba675761ebdf51c2d72952c&from=0&to=12&calories=591-722&health=alcohol-free";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

      jsonData["hits"].forEach((element){
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel(url: '', source: '', label: '', image: null);
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);

    });

    setState(() {});
    print("${recipes.toString()}");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: <Widget> [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          const Color(0xffD0F0C0),
                          const Color(0xffD0F0C0)
                        ]
                    )
                ),
              ),
              SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Row(
                              mainAxisAlignment: kIsWeb ? MainAxisAlignment.start: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Pantry", style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                ),),
                                Text("Pal", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                ),),
                              ]
                          ),
                          SizedBox(height: 30,),

                          Text("List Your Ingredients Below", style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 8,),
                          Text("We will give you nutritous foods based off the ingredients you have", style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontStyle: FontStyle.italic
                          ),),
                          SizedBox(height: 30,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: <Widget> [
                                Expanded(
                                  child: TextField(

                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                        hintText: "Enter Ingredients",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black.withOpacity(0.5),
                                        )
                                    ),
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16,),
                                InkWell(
                                  onTap:(){
                                    if(textEditingController.text.isNotEmpty){
                                      getRecipes(textEditingController.text);
                                      print("just do it");
                                    }else{
                                      print("Just don't do it");
                                    }
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            child: GridView(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ClampingScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200, mainAxisSpacing: 10.0
                              ),
                              children:  List.generate(recipes.length, (index) {
                                return GridTile(
                                    child: RecipieTile(
                                        title: recipes[index].label,
                                        desc: recipes[index].source,
                                        imgUrl: recipes[index].image!,
                                        url: recipes[index].url,
                                    ));
                              })),
                          ),
                        ],
                    ),
                ),
              ),
            ],
        ),
    );
  }
}
class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({required this.title, required this.desc, required this.imgUrl, required this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

