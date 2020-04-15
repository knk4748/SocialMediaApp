import 'package:cloud_firestore/cloud_firestore.dart';

class User{
final String id;
final String username;
final String email;
final String photoUrl;
final String bio;
final String displayName;


User({this.id,this.username,this.email,this.photoUrl,this.bio,this.displayName});

factory User.fromDocument(DocumentSnapshot doc){
  return User(
    id        :  doc["id"],
    email     :  doc['email'],
    username  :  doc['username'],
    photoUrl  :  doc['displayName'],
    bio       :  doc['bio'],
    displayName: doc['displayName']
    );

}

}