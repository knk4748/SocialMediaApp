import 'package:flutter/material.dart';
import 'package:cobra1/pages/home.dart';
//import 'package:google_sign_in/google_sign_in.dart';\


void main() {
 /* Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_){
    print("timestamps enabled");
  },   onError: (_){
    print("error  main.dart");
  });*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'login page',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      accentColor: Colors.white,

    ),
    home : Home(),
    
        //  child: child,
        );
  }
}
