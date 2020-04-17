import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobra1/Widgets/progress.dart';
import 'package:cobra1/model/user.dart';
//import 'package:cobra1/pages/Timeline.dart';
import 'package:cobra1/pages/home.dart';
import 'package:flutter/material.dart';

//final usersRef = Firestore.instance.collection('Users');
class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  bool _bioValid = true;
  bool _displayNameValid = true;
  User user;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

logout() async{
  googleSignIn.signOut();
  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
}


  updateProfile() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.length > 250 ? _bioValid = false : _bioValid = true;
    });
    if (_displayNameValid && _bioValid) {
      usersRef.document(widget.currentUserId).updateData({
        "displayName": displayNameController.text,
        "bio": bioController.text
      });

      SnackBar snackbar = SnackBar(content: Text("Profile Updated"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  buildDisplayNameField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "display name",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
                hintText: "Update Display Name",
                errorText: _displayNameValid ? null : "display name too short"),
          )
        ]);
  }

  buildBioField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "Bio",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextField(
            controller: bioController,
            decoration: InputDecoration(
                hintText: "Update your bio",
                errorText:
                    _bioValid ? null : "bio must be less than 250 words"),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Profile",
            style: TextStyle(
              color: Colors.black,
            )),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30,
              color: Colors.green,
            ),
          )
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        backgroundImage: CachedNetworkImageProvider(
                            "https://i.imgur.com/5RUOqu6.jpeg"), //changeZone
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[
                        buildDisplayNameField(),
                        buildBioField(),
                      ]),
                    ),
                    RaisedButton(
                      onPressed: () => updateProfile(),
                      child: Text("Update profile"),
                    ),
                    FlatButton.icon(
                      onPressed: () => logout(),
                      icon: Icon(Icons.cancel),
                      label: Text(
                        "Log out",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
