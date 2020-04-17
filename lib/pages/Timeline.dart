import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobra1/Widgets/header.dart';
import 'package:cobra1/Widgets/progress.dart';
import 'package:cobra1/pages/home.dart';
import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';

//final usersRef = Firestore.instance.collection('Users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Text> users = [];

  @override
  void initState() {
    
    super.initState();
  }

/*
  deleteUser(){
     usersRef.document("hjbrgwjb").delete();
  }

  updateUser() {
    usersRef.document("hjbrgwjb").updateData({"username": "henry"});
  }

 createUser() async{
    usersRef.add({"username":"mark","postcount":8,"isadmin": false});
  }
 createUser() async{
    usersRef.document("hjbrgwjb").setData({"username":"john","postcount":1,"isadmin": false});
  }

   getUsersByID() async {
    String id = "SWlndWyoqOuYjRdLTKub";

    DocumentSnapshot doc = await usersRef.document(id).get();
    print(doc.documentID);
    print(doc.data);
  }

  getUsers() {
    usersRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        print(doc.data);
        print(doc.documentID);
        print(doc.exists);
      });
    });
  }

  getUsersByQuery() async {
    QuerySnapshot snapshot =
        await usersRef.where("postcount", isLessThan: 3).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) {
      print(doc.data);
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: "Timeline", isAppTitle: true),
        body: FutureBuilder<QuerySnapshot>(
          future: usersRef.getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            final List<Text> listedUserText = snapshot.data.documents
                .map(
                  (doc) => Text(
                    doc["username"],
                  ),
                )
                .toList();
            return Container(
              child: ListView(
                children: listedUserText,
              ),
            );
          },
        ));
  }
}
