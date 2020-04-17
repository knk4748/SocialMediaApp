//import 'dart:html';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cobra1/Widgets/progress.dart';
import 'package:cobra1/model/user.dart';
import 'package:cobra1/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload image"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with camera"),
                onPressed: () => handleTakePhoto(),
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () => handleChooseFromGallery(),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(.3),
      child: Column(
        children: <Widget>[
          Image(
            image: AssetImage("assets/camera.jpg"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.cyan[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () => selectImage(context),
              child: Text("Upload image",
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85),
      );
    setState(() {
      file = compressedImageFile;
    });
  }

  createPostInFirestore(
      {String mediaUrl, String location, String description}) {
    postsRef
        .document(widget.currentUser.id)
        .collection("userPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "location": locationController.text,
      "mediaUrl": mediaUrl,
      "description": captionController.text,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child(("post_$postId.jpg")).putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadURl = await storageSnap.ref.getDownloadURL();
    return downloadURl;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);

    createPostInFirestore(
        mediaUrl: mediaUrl,
        description: captionController.text,
        location: locationController.text);
    locationController.clear();
    captionController.clear();
    setState(() {
      file = null;
      postId = Uuid().v4();
      isUploading = false;
    });
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    print("{$position.latitude} {$position.longitude}");
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
    print(locationController.text);
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: clearImage,
        ),
        title: Text("Add caption"),
        actions: <Widget>[
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text("Post"),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(" "),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write Caption",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was this photo taken",
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              color: Colors.amber,
              onPressed: () => getUserLocation(),
              label: Text(
                "Use Current location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
