import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// ignore: unused_import


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool showItem = false;
  bool searchState = false;
  final String uid;
  _HomePageState({this.uid});
  final  CollectionReference shopid = FirebaseFirestore.instance.collection('shop');
  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchState?Text('Store Video'):
                            TextField(
                              decoration:InputDecoration(
                                icon: Icon(Icons.search),
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.white),
                               ),
                            ),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          !searchState?IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: (){
            setState(() {
              searchState = !searchState;
            });
          }
          ):
         IconButton(icon: Icon(Icons.cancel,color: Colors.white,), onPressed: (){ 
           setState((){
             searchState = !searchState;
           });
          }
         ),
         ],
        ),
      body: Column(
        children: [
          
          Flexible(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: ListView.builder(
                      itemCount: shop.length,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(8),
                            child: YoutubePlayer(
                              controller: YoutubePlayerController(
                                  initialVideoId: YoutubePlayer.convertUrlToId(
                                      shop[index]),
                                  flags: YoutubePlayerFlags(
                                    autoPlay: false,
                                  )),
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.blue,
                              progressColors: ProgressBarColors(
                                  playedColor: Colors.blue,
                                  handleColor: Colors.blueAccent),
                            ),
                          )))),
        ],
      ),
      
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    print(shop.url);
  }


  getData() async {
    await shopid
        .get()
        .then((value) => value.shop()?.forEach((key, value) {
              if (!shop.url.contains(value)) {
                shop.url.add(value);
              }
            }))
        .whenComplete(() => setState(() {
              shop.url.shuffle();
              showItem = true;
            }));
  }
}