
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';



class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _addItemController = TextEditingController();
  // ignore: unused_field
  TextEditingController _addNewStoreName = TextEditingController();
  // ignore: unused_field
  TextEditingController _addLocation = TextEditingController();
  // ignore: unused_field
  TextEditingController _addProduct = TextEditingController();
  // ignore: unused_field
  TextEditingController _addPrice = TextEditingController();
  DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  bool searchState = false;

  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  get column => null;
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
            child: column(
              children:[
            TextField(
              controller: _addItemController,
              onEditingComplete: () {
                if (utube.hasMatch(_addItemController.text)) {
                  _addItemFuntion();
                } else {
                  FocusScope.of(this.context).unfocus();
                  _addItemController.clear();
                  Flushbar(
                    title: 'Invalid Link',
                    message: 'Please provide a valid link',
                    duration: Duration(seconds: 3),
                    icon: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  )..show(context);
                }
              },
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  labelText: 'Your Video URL',
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.add, size: 32),
                    onTap: () {
                      if (utube.hasMatch(_addItemController.text)) {
                        _addItemFuntion();
                      } else {
                        FocusScope.of(this.context).unfocus();
                        _addItemController.clear();
                        Flushbar(
                          title: 'Invalid Link',
                          message: 'Please provide a valid link',
                          duration: Duration(seconds: 3),
                          icon: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                        )..show(context);
                      }
                    },
                  )),
            ),
            TextField(
                  controller: _addNewStoreName,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: 'Store Name',
                      ),),
                            TextField(
                    controller: _addLocation,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: 'Location',
                      ),),
                 TextField(
                    controller: _addProduct,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: 'Product sold',
                    ),),
                 TextField(
                    controller: _addPrice,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: 'Price',
                      ),),
                ElevatedButton(
                     onPressed:(){
                      
                    Map <String,dynamic> data= { "url":_addItemController,"store":_addNewStoreName,"location":_addLocation ,"product":_addProduct,"price":_addPrice};
                    FirebaseFirestore.instance.collection("shop").add(data);
                     },
                     child: Text("Submit"),
                ), 
           
              ]
            
            ),
          
          ),
          
        ],
      ),
      
    );
  }

  @override
  void initState() {
    linkRef = FirebaseFirestore.instance.collection('links').doc('urls');
    super.initState();
    getData();
    print(videoID);
  }

  _addItemFuntion() async {
    await linkRef.set({
      _addItemController.text.toString(): _addItemController.text.toString()
    }, SetOptions(merge: true));
    Flushbar(
        title: 'Added',
        message: 'updating...',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline))
      ..show(context);
    setState(() {
      videoID.add(_addItemController.text);
    });
    print('added');
    FocusScope.of(this.context).unfocus();
    _addItemController.clear();
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




