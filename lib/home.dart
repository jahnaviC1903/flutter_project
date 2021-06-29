import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  bool searchState = false;

  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchState?Text('Youtube Player'):
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child:
          ),
          Flexible(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: ListView.builder(
                      itemCount: videoID.length,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(8),
                            child: YoutubePlayer(
                              controller: YoutubePlayerController(
                                  initialVideoId: YoutubePlayer.convertUrlToId(
                                      videoID[index]),
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
    linkRef = FirebaseFirestore.instance.collection('shop');
    super.initState();
    getData();
    print(videoID);
  }

  
  getData() async {
    await linkRef
        .get()
        .then((value) => value.data()?.forEach((key, value) {
              if (!videoID.contains(value)) {
                videoID.add(value);
              }
            }))
        .whenComplete(() => setState(() {
              videoID.shuffle();
              showItem = true;
            }));
  }
}