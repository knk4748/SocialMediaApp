import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobra1/Widgets/header.dart';
import 'package:cobra1/Widgets/progress.dart';
import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';

final userRef = Firestore.instance.collection('Users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Text> users = [];

  @override
  void initState() {
    // getUsersByQuery();
    // createUser();
    //updateUser();
    //deleteUser();
    super.initState();
  }

/*
  deleteUser(){
     userRef.document("hjbrgwjb").delete();
  }

  updateUser() {
    userRef.document("hjbrgwjb").updateData({"username": "henry"});
  }

 createUser() async{
    userRef.add({"username":"mark","postcount":8,"isadmin": false});
  }
 createUser() async{
    userRef.document("hjbrgwjb").setData({"username":"john","postcount":1,"isadmin": false});
  }

   getUsersByID() async {
    String id = "SWlndWyoqOuYjRdLTKub";

    DocumentSnapshot doc = await userRef.document(id).get();
    print(doc.documentID);
    print(doc.data);
  }

  getUsers() {
    userRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        print(doc.data);
        print(doc.documentID);
        print(doc.exists);
      });
    });
  }

  getUsersByQuery() async {
    QuerySnapshot snapshot =
        await userRef.where("postcount", isLessThan: 3).getDocuments();
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
          future: userRef.getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return cirularProgress();
            }
            final List<Text> listedUserText = snapshot.data.documents
                .map((doc) => Text(doc["username"]))
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
