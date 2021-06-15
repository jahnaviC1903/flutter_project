import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'add.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  await Firebase.initializeApp();
  runApp(MaterialApp(
    
    debugShowCheckedModeBanner: false,
    
    home: MyApp(),
  ));
}


  
  class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
            title:Text("Shop Store"), 
            backgroundColor: Colors.cyan[900], //background color of app bar
        ),
        body:Center( 
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
             
              children:[ SizedBox( 
              height:100, //height of button
              width:300, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  
                  primary: Colors.cyan[700], //background color of button
                  side: BorderSide(width:3, color:Colors.cyan[100]), //border width and color
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                   Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(),),);
                }, 
                child: Text("Browse") 
              )
            ),
            SizedBox(
              height: 30,
              width:50,
            ),
            SizedBox( 
              height:100, //height of button
              width:300, //width of button
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  
                  primary: Colors.white54, //background color of button
                  side: BorderSide(width:3, color:Colors.grey[200]), //border width and color
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
                onPressed: (){ 
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AddPage(),),);
                }, 
                child: Text("Add New Video") 
              )
            )
              ]

        )
              
    )
    );
  }
}
